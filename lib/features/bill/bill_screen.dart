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
import '../month/month_repository.dart';
import '../vendors/vendor_type.dart';
import '../vendors/vendor_selector.dart';
import '../vendors/vendor_type_screen.dart';
import 'bill_message.dart';
import 'bill_repository.dart';
import 'all_vendors_bill.dart';
import 'bill_export_service.dart';
import 'bill_share_actions.dart';
import 'spending_comparison.dart';
import 'spending_comparison_card.dart';

// Prevent duplicate dialogs while the persisted setting is being saved.
bool _billTutorialShown = false;

class BillScreen extends ConsumerStatefulWidget {
  const BillScreen({super.key, required this.selectedVendorId, required this.onSelectVendor, this.tutorialStep});
  final int? selectedVendorId;
  final int? tutorialStep;
  final ValueChanged<int> onSelectVendor;
  @override
  ConsumerState<BillScreen> createState() => _BillScreenState();
}
class _BillScreenState extends ConsumerState<BillScreen> with WidgetsBindingObserver {
  late DateTime _month;
  late DateTime _today;
  Timer? _midnight;
  bool _busy = false;
  bool _replayShown = false;
  bool _allVendors = false;
  final _scrollController = ScrollController();
  final _vendorKey = GlobalKey();
  final _monthKey = GlobalKey();
  final _totalKey = GlobalKey();
  final _shareKey = GlobalKey();
  final _paidKey = GlobalKey();

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
  Future<void> _revealTutorialTarget({bool bottom = false, GlobalKey? target}) async {
    if (!mounted || !_scrollController.hasClients) return;
    final targetContext = target?.currentContext;
    if (targetContext != null) {
      await Scrollable.ensureVisible(targetContext, alignment: 0.3,
        duration: DiaryMotion.duration(context, DiaryMotion.transition), curve: Curves.easeOut);
    } else {
      await _scrollController.animateTo(bottom ? _scrollController.position.maxScrollExtent : 0,
        duration: DiaryMotion.duration(context, DiaryMotion.transition), curve: Curves.easeOut);
    }
    await WidgetsBinding.instance.endOfFrame;
  }

  void _startTutorial() {
    final settings = ref.watch(settingsProvider).asData?.value;
    final replay = widget.tutorialStep != null;
    if (replay && _replayShown) return;
    if (!replay && (settings == null || settings['tutorialSeen_bill'] == 'true')) return;
    if (!replay && _billTutorialShown) return;
    if (replay) { _replayShown = true; } else { _billTutorialShown = true; }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
        if (replay) { _replayShown = false; } else { _billTutorialShown = false; }
        return;
      }
      final repository = ref.read(settingsRepositoryProvider);
      final strings = AppLocalizations.of(context)!;
      if (!replay) {
        await greetAssistantOnce(context, repository,
          alreadyIntroduced: settings?['assistantIntroduced'] == 'true');
        if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
          _billTutorialShown = false;
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
          DiaryTutorialStep(target: _totalKey, title: strings.tutorialBillTotalTitle,
            body: _allVendors ? strings.allVendorsBillInfo : strings.tutorialBillTotalBody,
            onReveal: () => _revealTutorialTarget(bottom: false)),
          DiaryTutorialStep(target: _shareKey, title: strings.tutorialShareTitle,
            body: strings.tutorialShareBody, onReveal: () => _revealTutorialTarget(target: _shareKey)),
          if (!_allVendors) DiaryTutorialStep(target: _paidKey, title: strings.tutorialPaidTitle,
            body: strings.tutorialPaidBody, onReveal: () => _revealTutorialTarget(bottom: true)),
        ]));
      if (replay) return;
      try {
        await repository.markTutorialSeen('bill');
      } catch (error) {
        debugPrint('Tutorial progress could not be saved (${error.runtimeType}).');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(strings.saveError)));
        }
      }
    });
  }

  Future<void> _perform(Future<void> Function() action, String error) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  Future<void> _shareExport(AllVendorsBill bill, BillExportFormat format) {
    final strings = AppLocalizations.of(context)!;
    return _perform(() async {
      final file = await BillExportService().createExport(bill, strings, format);
      if (!mounted) return;
      await ref.read(billRepositoryProvider).shareExport(file);
    }, strings.shareError);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final vendors = ref.watch(activeVendorsProvider);
    return vendors.when(
      loading: () => Center(child: Semantics(label: strings.loading,
        child: const CircularProgressIndicator())),
      error: (_, _) => ListView(padding: const EdgeInsets.fromLTRB(18, 6, 18, 16), children: [
        Text(strings.storageError, style: Theme.of(context).textTheme.bodyLarge),
        DiaryButton(label: strings.retry, onPressed: () => ref.invalidate(activeVendorsProvider)),
      ]),
      data: (rows) {
        if (rows.isEmpty) {
          return ListView(controller: _scrollController, padding: const EdgeInsets.fromLTRB(18, 6, 18, 16), children: [
          DiaryScreenHeader(title: strings.bill),
          const SizedBox(height: 24),
          Text(strings.noVendorsBill, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          HelpSpotlight(enabled: widget.tutorialStep != null, title: strings.tutorialAddTitle,
            body: strings.tutorialAddBody, child: DiaryButton(label: strings.addFirst, onPressed: () => Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const VendorTypeScreen())))),
          ]);
        }
        final vendor = rows.firstWhere((row) => row.id == widget.selectedVendorId,
          orElse: () => rows.first);
        return _billView(context, vendor, rows);
      },
    );
  }
  Widget _billView(BuildContext context, Vendor vendor, List<Vendor> vendors) {
    final strings = AppLocalizations.of(context)!;
    return ListView(controller: _scrollController, padding: const EdgeInsets.fromLTRB(18, 6, 18, 16), children: [
      DiaryScreenHeader(title: strings.bill),
      const SizedBox(height: 16),
      VendorSelector(key: _vendorKey, vendor: vendor, vendors: vendors, enabled: !_busy,
        allSelected: _allVendors,
        onSelectAll: () => setState(() => _allVendors = true),
        onSelectVendor: (id) {
          setState(() => _allVendors = false);
          widget.onSelectVendor(id);
        }),
      const SizedBox(height: 12),
      Row(key: _monthKey, children: [
        IconButton(onPressed: _busy ? null : () => setState(() =>
          _month = DateTime(_month.year, _month.month - 1)), tooltip: strings.previousMonth,
          constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
          icon: const Icon(Icons.chevron_left)),
        Expanded(child: Text(DateFormat.yMMMM(strings.localeName).format(_month),
          textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge)),
        IconButton(onPressed: _busy || !_month.isBefore(DateTime(_today.year, _today.month))
            ? null : () => setState(() => _month = DateTime(_month.year, _month.month + 1)),
          tooltip: strings.nextMonth,
          constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
          icon: const Icon(Icons.chevron_right)),
      ]),
      ...(_allVendors ? _allBillsContent(context) : _vendorBillContent(context, vendor)),
    ]);
  }
  List<Widget> _vendorBillContent(BuildContext context, Vendor vendor) {
    final strings = AppLocalizations.of(context)!;
    final request = (vendorId: vendor.id, month: _month, today: _today);
    final bill = ref.watch(monthBillProvider(request));
    final paid = ref.watch(paidMonthProvider((vendorId: vendor.id, month: _month)));
    final numbers = NumberFormat.decimalPattern(strings.localeName);
    if (bill.hasValue && !bill.hasError && paid.hasValue && !paid.hasError) _startTutorial();
    return bill.when(
        loading: () => [Center(child: Semantics(label: strings.loading,
          child: const CircularProgressIndicator()))],
        error: (_, _) => [
          Text(strings.storageError, style: Theme.of(context).textTheme.bodyLarge),
          DiaryButton(label: strings.retry, onPressed: () => ref.invalidate(monthBillProvider(request))),
        ],
        data: (summary) {
          final total = billTotalLabel(summary, strings.localeName);
          final message = billShareMessage(summary, strings);
          final repository = ref.read(billRepositoryProvider);
          return [
            Card(key: _totalKey, margin: const EdgeInsets.only(bottom: 8), child: Padding(
              padding: const EdgeInsets.all(14), child: Column(children: [
                Text(paid.asData?.value == true ? strings.paid : strings.totalDue,
                  style: Theme.of(context).textTheme.bodyMedium),
                Text(total, textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 12),
                _BillRow(label: strings.came, value: strings.dayCount(numbers.format(summary.cameDays))),
            _BillRow(label: strings.notCame, value: strings.dayCount(numbers.format(summary.notCameDays))),
            if (summary.automaticDays > 0) _BillRow(
              label: strings.autoCame, value: strings.dayCount(numbers.format(summary.automaticDays))),
                const SizedBox(height: 12),
            Text( '${numbers.format(summary.cameDays * summary.quantity)} '
              '${vendorUnitLabel(strings, vendor.unit)} × ₹${numbers.format(summary.rate)}',
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
              ]))),
            const SizedBox(height: 8),
            ..._comparisonContent(context, vendorId: vendor.id),
            BillShareActions(textShareKey: _shareKey, busy: _busy,
              onShareText: () => _perform(() => repository.shareMessage(message), strings.shareError),
              onShareExport: (format) => _shareExport(
                AllVendorsBill(month: summary.month, bills: [summary]), format)),
            const SizedBox(height: 12),
            if (paid.hasError) ...[
              Text(strings.storageError, style: Theme.of(context).textTheme.bodyMedium),
              DiaryButton(label: strings.retry, onPressed: () => ref.invalidate(
                paidMonthProvider((vendorId: vendor.id, month: _month)))),
            ] else DiaryButton(key: _paidKey, label: paid.asData?.value == true
                  ? '${strings.paid} ✔' : '${strings.markPaid} ✔',
              color: paid.asData?.value == true ? DiaryColors.cameTint : Colors.white,
              foreground: paid.asData?.value == true ? DiaryColors.cameEdge : DiaryColors.ink,
              edge: DiaryColors.ink, selected: paid.asData?.value == true,
              onPressed: _busy || paid.isLoading || paid.asData?.value == true ? null
                : () => _perform(() => repository.markPaid(vendor.id, _month), strings.saveError)),
          ];
        },
    );
  }

  List<Widget> _allBillsContent(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final request = (month: _month, today: _today);
    final bill = ref.watch(allVendorsBillProvider(request));
    if (bill.hasValue && !bill.hasError) _startTutorial();
    return bill.when(
      loading: () => [Center(child: Semantics(label: strings.loading,
        child: const CircularProgressIndicator()))],
      error: (_, _) => [
        Text(strings.storageError, style: Theme.of(context).textTheme.bodyLarge),
        DiaryButton(label: strings.retry,
          onPressed: () => ref.invalidate(allVendorsBillProvider(request))),
      ],
      data: (summary) => [
        Card(key: _totalKey, margin: const EdgeInsets.only(bottom: 8), child: Padding(
          padding: const EdgeInsets.all(14), child: Column(children: [
            Text(strings.monthlyTotal, style: Theme.of(context).textTheme.bodyMedium),
            Text(allVendorsTotalLabel(summary, strings.localeName), textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 12),
            for (final vendorBill in summary.bills) _BillRow(
              label: billVendorLabel(vendorBill, strings),
              value: billTotalLabel(vendorBill, strings.localeName)),
          ]))),
        Text(strings.allVendorsBillInfo, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        ..._comparisonContent(context),
        BillShareActions(textShareKey: _shareKey, busy: _busy,
          onShareText: () => _perform(() => ref.read(billRepositoryProvider)
            .shareMessage(allVendorsShareMessage(summary, strings)), strings.shareError),
          onShareExport: (format) => _shareExport(summary, format)),
      ],
    );
  }

  List<Widget> _comparisonContent(BuildContext context, {int? vendorId}) {
    final strings = AppLocalizations.of(context)!;
    final request = (vendorId: vendorId, month: _month, today: _today);
    return ref.watch(spendingComparisonProvider(request)).when(
      loading: () => [const LinearProgressIndicator(), const SizedBox(height: 16)],
      error: (_, _) => [
        Text(strings.storageError, style: Theme.of(context).textTheme.bodyMedium),
        DiaryButton(label: strings.retry,
          onPressed: () => ref.invalidate(spendingComparisonProvider(request))),
        const SizedBox(height: 16),
      ],
      data: (comparison) => [SpendingComparisonCard(comparison: comparison),
        const SizedBox(height: 16)],
    );
  }

}
class _BillRow extends StatelessWidget {
  const _BillRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: DiaryColors.rule, width: 2))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
      const SizedBox(width: 10),
      Flexible(child: Text(value, textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700))),
    ]),
  );
}

