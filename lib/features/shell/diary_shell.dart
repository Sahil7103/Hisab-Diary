import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/services/app_telemetry.dart';
import '../../app/theme/diary_motion.dart';
import '../../app/diary_navigation.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import '../bill/bill_screen.dart';
import '../month/month_screen.dart';
import '../settings/settings_screen.dart';
import '../today/today_screen.dart';
import '../help/help_topic.dart';

class DiaryShell extends StatefulWidget {
  const DiaryShell({super.key, this.storageLoading = false,
    this.storageError = false, required this.onRetry});
  final bool storageLoading;
  final bool storageError;
  final VoidCallback onRetry;
  @override
  State<DiaryShell> createState() => _DiaryShellState();
}
class _DiaryShellState extends State<DiaryShell> {
  @override
  void initState() {
    super.initState();
    todayRequests.addListener(_openToday);
    AppTelemetry.screen('today');
  }
  void _openToday() {
    if (mounted) _selectTab(0);
  }
  @override
  void dispose() {
    todayRequests.removeListener(_openToday);
    super.dispose();
  }
  final _navigationKey = GlobalKey();
  int _selected = 0;
  HelpTopic? _helpTopic;
  int _helpRequest = 0;
  void _openHelp(HelpTopic topic) {
    setState(() { _helpTopic = topic; _helpRequest++; _selected = topic.tabIndex; });
    AppTelemetry.screen(const ['today', 'month', 'bill', 'settings'][_selected]);
  }
  int? _selectedVendorId;
  static const _icons = [Icons.today_outlined, Icons.calendar_month_outlined,
    Icons.receipt_long_outlined, Icons.settings_outlined];
  void _selectTab(int index) {
    if (_selected == index) return;
    setState(() { _selected = index; _helpTopic = null; });
    AppTelemetry.screen(const ['today', 'month', 'bill', 'settings'][index]);
  }
  void _selectVendor(int id) => setState(() => _selectedVendorId = id);
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final labels = [strings.today, strings.month, strings.bill, strings.settings];
    final Widget body;
    if (widget.storageLoading || widget.storageError) {
      body = ListView(padding: const EdgeInsets.all(18), children: [
        Text(strings.appName, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 28),
        if (widget.storageLoading) Center(child: Semantics(label: strings.loading,
          child: const CircularProgressIndicator()))
        else ...[
          Text(strings.storageError, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          DiaryButton(label: strings.retry, onPressed: widget.onRetry),
        ],
      ]);
    } else {
      body = switch (_selected) {
        0 => TodayScreen(key: ValueKey(_helpRequest),
          tutorialStep: _helpTopic?.tabIndex == 0 ? _helpTopic!.tutorialStep : null, navigationKey: _navigationKey, onOpenVendor: (id) => setState(() {
          _selectedVendorId = id;
          _helpTopic = null;
          _selected = 1;
          AppTelemetry.screen('month');
        })),
        1 => MonthScreen(key: ValueKey(_helpRequest),
          tutorialStep: _helpTopic?.tabIndex == 1 ? _helpTopic!.tutorialStep : null, selectedVendorId: _selectedVendorId,
          onSelectVendor: _selectVendor, onBack: () => _selectTab(0)),
        2 => BillScreen(key: ValueKey(_helpRequest),
          tutorialStep: _helpTopic?.tabIndex == 2 ? _helpTopic!.tutorialStep : null, selectedVendorId: _selectedVendorId, onSelectVendor: _selectVendor),
        _ => SettingsScreen(key: ValueKey(_helpRequest),
          helpTopic: _helpTopic, onHelpRequested: _openHelp),
      };
    }
    return NotebookBackground(child: Scaffold(
      body: SafeArea(child: TweenAnimationBuilder<double>(
        key: ValueKey((_selected, widget.storageLoading, widget.storageError)),
        tween: Tween(begin: MediaQuery.disableAnimationsOf(context) ? 1.0 : 0.0, end: 1.0),
        duration: DiaryMotion.duration(context, DiaryMotion.transition),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Opacity(opacity: value,
          child: Transform.translate(offset: Offset(0, 8 * (1 - value)), child: child)),
        child: RepaintBoundary(child: body))),
      bottomNavigationBar: DecoratedBox(key: _navigationKey,
        decoration: const BoxDecoration(color: Colors.white,
          border: Border(top: BorderSide(color: DiaryColors.ink, width: 2))),
        child: SafeArea(top: false, child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.ltr,
            children: List.generate(4, (index) => Expanded(
              child: Semantics(button: true, label: labels[index],
                selected: _selected == index, excludeSemantics: true,
                onTap: () => _selectTab(index),
                child: Material(animationDuration: DiaryMotion.duration(context, DiaryMotion.press),
                  color: _selected == index
                    ? DiaryColors.haldi : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(onTap: () => _selectTab(index),
                    borderRadius: BorderRadius.circular(14),
                    child: ConstrainedBox(constraints: const BoxConstraints(minHeight: 56),
                      child: Padding(padding: const EdgeInsets.all(6),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          ExcludeSemantics(child: AnimatedScale(
                            scale: _selected == index ? 1.08 : 1,
                            duration: DiaryMotion.duration(context, DiaryMotion.press),
                            child: Icon(_icons[index], size: 24))),
                          Text(labels[index], textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: DiaryColors.ink, fontWeight: FontWeight.w700)),
                        ])),
                    )),
                )),
            )),
          ),
        )),
      ),
    ));
  }
}

