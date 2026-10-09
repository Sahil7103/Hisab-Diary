import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/theme/diary_theme.dart';
import '../../app/theme/diary_motion.dart';
import '../../app/app_providers.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../l10n/app_localizations.dart';
import 'today_repository.dart';
import 'vendor_card.dart';
import '../../core/widgets/diary_tutorial.dart';
import '../settings/settings_repository.dart';
import '../vendors/vendor_type_screen.dart';
import '../vendors/vendor_details_screen.dart';
import '../vendors/vendor_repository.dart';
import '../vendors/vendor_type.dart';
import '../../core/storage/app_database.dart';
import '../month/month_repository.dart' show activeVendorsProvider;

// Prevent duplicate dialogs while the persisted setting is being saved.
bool _homeTutorialShown = false;

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key, required this.onOpenVendor, this.navigationKey});
  final GlobalKey? navigationKey;
  final ValueChanged<int> onOpenVendor;
  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}
class _TodayScreenState extends ConsumerState<TodayScreen>
    with WidgetsBindingObserver {
  late DateTime _day;
  Timer? _midnight;
  bool _busy = false;
  final _scrollController = ScrollController();
  final _addKey = GlobalKey();
  final _cardKey = GlobalKey();
  final _allCameKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateDay();
  }
  void _updateDay() {
    final now = DateTime.now();
    _day = DateTime(now.year, now.month, now.day);
    _midnight?.cancel();
    _midnight = Timer(DateTime(now.year, now.month, now.day + 1)
      .difference(now), () { if (mounted) setState(_updateDay); });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) setState(_updateDay);
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

  void _startTutorial(bool hasDeliveries) {
    final settings = ref.watch(settingsProvider).asData?.value;
    if (settings == null || settings['tutorialSeen_home'] == 'true') return;
    if (_homeTutorialShown || widget.navigationKey == null) return;
    _homeTutorialShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
        _homeTutorialShown = false;
        return;
      }
      final repository = ref.read(settingsRepositoryProvider);
      final strings = AppLocalizations.of(context)!;
      await showGeneralDialog<void>(context: context, barrierDismissible: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, _, _) => DiaryTutorial(steps: [
          DiaryTutorialStep(target: _addKey, title: strings.tutorialAddTitle,
            body: strings.tutorialAddBody,
            onReveal: () => _revealTutorialTarget(bottom: true)),
          if (hasDeliveries) ...[
            DiaryTutorialStep(target: _cardKey, title: strings.tutorialMarkTitle,
              body: strings.tutorialMarkBody, onReveal: _revealTutorialTarget),
            DiaryTutorialStep(target: _allCameKey, title: strings.tutorialAllTitle,
              body: strings.tutorialAllBody, onReveal: _revealTutorialTarget),
          ],
          DiaryTutorialStep(target: widget.navigationKey!, title: strings.tutorialTabsTitle,
            body: strings.tutorialTabsBody),
        ]));
      try {
        await repository.markTutorialSeen('home');
      } catch (error) {
        debugPrint('Tutorial progress could not be saved (${error.runtimeType}).');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(strings.saveError)));
        }
      }
    });
  }

  Future<void> _mark(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      await ref.read(databaseProvider).saveSetting('reminderActionError', 'false');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.saveError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  void _editVendor(Vendor vendor) {
    if (_busy) return;
    Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => VendorDetailsScreen(
      type: VendorType.values.firstWhere((type) => type.name == vendor.type,
        orElse: () => VendorType.other), vendor: vendor)));
  }

  Future<void> _deleteVendor(Vendor vendor) async {
    if (_busy) return;
    final strings = AppLocalizations.of(context)!;
    final name = vendor.name.trim().isEmpty ? vendorTypeLabel(strings, vendor.type) : vendor.name;
    final confirmed = await showDialog<bool>(context: context, builder: (context) =>
      AlertDialog(title: Text(strings.deleteVendor),
        content: Text(strings.deleteVendorConfirm(name)), actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(strings.cancel)),
          TextButton(style: TextButton.styleFrom(foregroundColor: DiaryColors.absentEdge),
            onPressed: () => Navigator.of(context).pop(true), child: Text(strings.deleteVendor)),
        ]));
    if (!mounted || confirmed != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(vendorRepositoryProvider).deleteVendor(vendor.id);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(strings.saveError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final records = ref.watch(todayVendorsProvider(_day));
    final hasAccounts = ref.watch(activeVendorsProvider).asData?.value.isNotEmpty ?? false;
    final repository = ref.read(todayRepositoryProvider);
    final vendors = records.asData?.value;
    if (vendors != null) _startTutorial(vendors.isNotEmpty);
    void addVendor() => Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => const VendorTypeScreen()));
    return ListView(controller: _scrollController, padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
      children: [
        DiaryScreenHeader(title: strings.today),
        Text(DateFormat.yMMMMEEEEd(strings.localeName).format(_day),
          style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        if (ref.watch(settingsProvider).asData?.value['reminderActionError'] == 'true')
          Semantics(liveRegion: true, child: Text(strings.reminderError,
            style: Theme.of(context).textTheme.bodyLarge)),
        ...records.when(
          loading: () => [Center(child: Semantics(label: strings.loading,
            child: const CircularProgressIndicator()))],
          error: (_, _) => [
            Text(strings.storageError, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            DiaryButton(label: strings.retry,
              onPressed: () => ref.invalidate(todayVendorsProvider(_day))),
          ],
          data: (vendors) => vendors.isEmpty ? [
            const SizedBox(height: 24),
            if (hasAccounts) ...[
              Text(strings.noDeliveries, textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
            ],
            DiaryButton(key: _addKey, label: hasAccounts ? strings.addNew : strings.addFirst, onPressed: addVendor,
              color: Colors.white, foreground: DiaryColors.ink, edge: DiaryColors.ink),
          ] : [
            DiaryButton(key: _allCameKey, label: '${strings.allCame} ✔',
              color: DiaryColors.cameTint, foreground: DiaryColors.cameEdge,
              edge: DiaryColors.cameEdge,
              onPressed: _busy ? null : () => _mark(() => repository.markAllCame(_day))),
            const SizedBox(height: 14),
            for (final record in vendors) VendorCard(
              key: record == vendors.first ? _cardKey : null, record: record, busy: _busy,
              onOpen: () => widget.onOpenVendor(record.vendor.id),
              onEdit: () => _editVendor(record.vendor),
              onDelete: () => _deleteVendor(record.vendor),
              onMark: (status) => _mark(() => repository.toggle(record.vendor.id, _day, status))),
            DiaryButton(key: _addKey, label: strings.addNew, onPressed: addVendor,
              color: Colors.white, foreground: DiaryColors.ink, edge: DiaryColors.ink),
          ],
        ),
      ]);
  }
}



