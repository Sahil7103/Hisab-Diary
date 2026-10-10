import 'dart:async';
import '../../app/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/theme/diary_theme.dart';
import '../../app/theme/diary_motion.dart';
import '../../core/widgets/diary_tutorial.dart';
import '../help/help_spotlight.dart';
import '../help/help_assistant_overlay.dart';
import '../settings/settings_repository.dart';
import '../../core/storage/app_database.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../l10n/app_localizations.dart';
import '../vendors/vendor_selector.dart';
import '../vendors/vendor_type_screen.dart';
import 'month_bill.dart';
import 'calendar_day.dart';
import 'month_repository.dart';
import '../ledger/ledger_screen.dart';
import '../../l10n/v3_strings.dart';

// Prevent duplicate dialogs while the persisted setting is being saved.
bool _monthTutorialShown = false;

class MonthScreen extends ConsumerWidget {
  const MonthScreen({super.key, required this.selectedVendorId,
    required this.onSelectVendor, required this.onBack, this.tutorialStep});
  final int? selectedVendorId;
  final int? tutorialStep;
  final ValueChanged<int> onSelectVendor;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final vendors = ref.watch(activeVendorsProvider);
    return vendors.when(
      loading: () => Center(child: Semantics(label: strings.loading,
        child: const CircularProgressIndicator())),
      error: (_, _) => ListView(padding: const EdgeInsets.fromLTRB(18, 6, 18, 16), children: [
        Text(strings.storageError, style: Theme.of(context).textTheme.bodyLarge),
        DiaryButton(label: strings.retry,
          onPressed: () => ref.invalidate(activeVendorsProvider)),
      ]),
      data: (rows) {
        if (rows.isEmpty) {
          return ListView(padding: const EdgeInsets.fromLTRB(18, 6, 18, 16), children: [
          DiaryScreenHeader(title: strings.month),
          const SizedBox(height: 24),
          Text(strings.noVendorsCalendar, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          HelpSpotlight(enabled: tutorialStep != null, title: strings.tutorialAddTitle,
            body: strings.tutorialAddBody, child: DiaryButton(label: strings.addFirst, onPressed: () => Navigator.of(context)
            .push<bool>(MaterialPageRoute(builder: (_) => const VendorTypeScreen())))),
          ]);
        }
        final vendor = rows.firstWhere((row) => row.id == selectedVendorId,
          orElse: () => rows.first);
        return _VendorCalendar(key: ValueKey(vendor.id), vendor: vendor,
          vendors: rows, onSelectVendor: onSelectVendor, onBack: onBack, tutorialStep: tutorialStep);
      },
    );
  }
}

class _VendorCalendar extends ConsumerStatefulWidget {
  const _VendorCalendar({super.key, required this.vendor, required this.vendors,
    required this.onSelectVendor, required this.onBack, this.tutorialStep});
  final Vendor vendor;
  final int? tutorialStep;
  final List<Vendor> vendors;
  final ValueChanged<int> onSelectVendor;
  final VoidCallback onBack;
  @override
  ConsumerState<_VendorCalendar> createState() => _VendorCalendarState();
}
class _VendorCalendarState extends ConsumerState<_VendorCalendar>
    with WidgetsBindingObserver {
  late DateTime _month;
  late DateTime _today;
  Timer? _midnight;
  bool _saving = false;
  bool _replayShown = false;
  final _scrollController = ScrollController();
  final _vendorKey = GlobalKey();
  final _monthKey = GlobalKey();
  final _calendarKey = GlobalKey();
  final _totalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshToday();
    _month = DateTime(_today.year, _today.month);
  }
  void _refreshToday() {
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _midnight?.cancel();
    _midnight = Timer(DateTime(now.year, now.month, now.day + 1).difference(now),
      () { if (mounted) setState(_refreshToday); });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) setState(_refreshToday);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _midnight?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
  Future<void> _revealTutorialTarget({bool bottom = false}) async {
    if (!mounted || !_scrollController.hasClients) return;
    await _scrollController.animateTo(bottom ? _scrollController.position.maxScrollExtent : 0,
      duration: DiaryMotion.duration(context, DiaryMotion.transition), curve: Curves.easeOut);
    await WidgetsBinding.instance.endOfFrame;
  }

  void _startTutorial() {
    final settings = ref.watch(settingsProvider).asData?.value;
    final replay = widget.tutorialStep != null;
    if (replay && _replayShown) return;
    if (!replay && (settings == null || settings['tutorialSeen_month'] == 'true')) return;
    if (!replay && _monthTutorialShown) return;
    if (replay) { _replayShown = true; } else { _monthTutorialShown = true; }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
        if (replay) { _replayShown = false; } else { _monthTutorialShown = false; }
        return;
      }
      final repository = ref.read(settingsRepositoryProvider);
      final strings = AppLocalizations.of(context)!;
      if (!replay) {
        await greetAssistantOnce(context, repository,
          alreadyIntroduced: settings?['assistantIntroduced'] == 'true');
        if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
          _monthTutorialShown = false;
          return;
        }
      }
      await showGeneralDialog<void>(context: context, barrierDismissible: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, _, _) => DiaryTutorial(initialStep: widget.tutorialStep ?? 0, steps: [
          DiaryTutorialStep(target: _vendorKey, title: strings.tutorialVendorTitle,
            body: strings.tutorialVendorBody, onReveal: () => _revealTutorialTarget(bottom: false)),
          DiaryTutorialStep(target: _monthKey, title: strings.tutorialMonthTitle,
            body: strings.tutorialMonthBody, onReveal: () => _revealTutorialTarget(bottom: false)),
          DiaryTutorialStep(target: _calendarKey, title: strings.tutorialCalendarTitle,
            body: strings.tutorialCalendarBody, onReveal: () => _revealTutorialTarget(bottom: false)),
          DiaryTutorialStep(target: _totalKey, title: strings.tutorialTotalTitle,
            body: strings.tutorialTotalBody, onReveal: () => _revealTutorialTarget(bottom: true)),
        ]));
      if (replay) return;
      try {
        await repository.markTutorialSeen('month');
      } catch (error) {
        debugPrint('Tutorial progress could not be saved (${error.runtimeType}).');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(strings.saveError)));
        }
      }
    });
  }

  Future<void> _toggle(int number) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(monthRepositoryProvider).toggleDay(widget.vendor.id,
        DateTime(_month.year, _month.month, number));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.saveError)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final request = (vendorId: widget.vendor.id, month: _month, today: _today);
    final bill = ref.watch(monthBillProvider(request));
    final weekdays = [strings.mondayShort, strings.tuesdayShort,
      strings.wednesdayShort, strings.thursdayShort, strings.fridayShort,
      strings.saturdayShort, strings.sundayShort];
    final numbers = NumberFormat.decimalPattern(strings.localeName);
    final summary = bill.asData?.value;
    if (summary != null) _startTutorial();
    return ListView(controller: _scrollController, padding: const EdgeInsets.fromLTRB(18, 6, 18, 16), children: [
      DiaryScreenHeader(title: strings.month),
      const SizedBox(height: 8),
      VendorSelector(key: _vendorKey, vendor: widget.vendor, vendors: widget.vendors,
        enabled: !_saving, onSelectVendor: widget.onSelectVendor),
      const SizedBox(height: 12),
      Row(key: _monthKey, children: [
        IconButton(onPressed: _saving ? null : () => setState(() =>
          _month = DateTime(_month.year, _month.month - 1)),
          tooltip: strings.previousMonth,
          constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
          icon: const Icon(Icons.chevron_left)),
        Expanded(child: Text(DateFormat.yMMMM(strings.localeName).format(_month),
          textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge!
            .copyWith(fontWeight: FontWeight.w700))),
        IconButton(onPressed: _saving ? null : () => setState(() =>
          _month = DateTime(_month.year, _month.month + 1)),
          tooltip: strings.nextMonth,
          constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
          icon: const Icon(Icons.chevron_right)),
      ]),
      ...bill.when(
        loading: () => [Center(child: Semantics(label: strings.loading,
          child: const CircularProgressIndicator()))],
        error: (_, _) => [
          Text(strings.storageError, style: Theme.of(context).textTheme.bodyLarge),
          DiaryButton(label: strings.retry,
            onPressed: () => ref.invalidate(monthBillProvider(request))),
        ],
        data: (summary) => [
          Row(children: [
            Expanded(child: _CountChip(label: strings.cameCount(numbers.format(summary.cameDays)),
              color: DiaryColors.cameTint, ink: DiaryColors.cameEdge)),
            const SizedBox(width: 8),
            Expanded(child: _CountChip(label: strings.notCameCount(numbers.format(summary.notCameDays)),
              color: DiaryColors.absentTint, ink: DiaryColors.absentEdge)),
          ]),
          const SizedBox(height: 8),
          LayoutBuilder(key: _calendarKey, builder: (context, constraints) {
            final minimumWidth = MediaQuery.textScalerOf(context).scale(18) * 1.6;
            final calendarWidth = (minimumWidth * 7 + 36)
              .clamp(constraints.maxWidth, double.infinity);
            final dayWidth = (calendarWidth - 36) / 7;
            return SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: SizedBox(width: calendarWidth, child: Column(children: [
                Row(children: [for (final label in weekdays) Expanded(child: Text(label,
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700)))]),
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  for (int blank = 0; blank < monthWeekdayOffset(_month); blank++)
                    SizedBox(width: dayWidth, height: 64),
                  for (int day = 1; day <= daysInMonth(_month); day++) SizedBox(
                    width: dayWidth,
                    child: CalendarDay(number: numbers.format(day),
                      dateLabel: DateFormat.yMMMMEEEEd(strings.localeName)
                        .format(DateTime(_month.year, _month.month, day)),
                      attendance: summary.days[day]!,
                      isToday: _month.year == _today.year && _month.month == _today.month && day == _today.day,
                      onPressed: _saving || summary.days[day] == DayAttendance.disabled
                          ? null : () => _toggle(day)),
                  ),
                ]),
              ])));
          }),
          const SizedBox(height: 12),
          Text(strings.calendarHint, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
          if (summary.automaticDays > 0) Padding(padding: const EdgeInsets.only(top: 8),
            child: Text(strings.autoCounted(numbers.format(summary.automaticDays)),
              style: Theme.of(context).textTheme.bodyMedium)),

        ],
      ),
      if (summary != null) Card(key: _totalKey, margin: const EdgeInsets.only(top: 12), child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(strings.runningTotal, style: Theme.of(context).textTheme.bodyMedium),
              Text(NumberFormat.currency(locale: strings.localeName,
                symbol: '₹', decimalDigits: summary.totalPaise % 100 == 0 ? 0 : 2)
                  .format(summary.total),
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
            ]))),
      const SizedBox(height: 12),
      DiaryButton(label: v3Text(context, 'ledgerOpen'),
        onPressed: _saving ? null : () => Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (_) => LedgerScreen(
            vendorId: widget.vendor.id, month: _month))),
        color: Colors.white, foreground: DiaryColors.ink, edge: DiaryColors.ink),
    ]);
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.label, required this.color, required this.ink});
  final String label;
  final Color color;
  final Color ink;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
    child: Text(label, textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium!
        .copyWith(color: ink, fontWeight: FontWeight.w700)));
}





