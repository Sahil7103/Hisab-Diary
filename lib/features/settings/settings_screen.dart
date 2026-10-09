import '../../core/constants/app_languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../l10n/app_localizations.dart';
import '../auth/language_screen.dart';
import 'backup_service.dart';
import 'settings_repository.dart';
import '../reminders/reminder_settings.dart';
import '../pro/pro_screen.dart';
import '../pro/vendor_limits.dart';
import '../vendors/manage_vendors_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}
class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;
  void _notify(String message) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)));
  Future<void> _perform(Future<void> Function() action, String error) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on BackupTooLargeException {
      if (mounted) _notify(AppLocalizations.of(context)!.backupTooLarge);
    } catch (_) {
      if (mounted) _notify(error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  Future<void> _restore() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final service = ref.read(backupServiceProvider);
      final backup = await service.pickBackup();
      if (!mounted || backup == null) return;
      final strings = AppLocalizations.of(context)!;
      final confirm = await showDialog<bool>(context: context,
        builder: (context) => AlertDialog(title: Text(strings.restoreBackup),
          content: Text(strings.restoreSummary(backup.vendors.length.toString(),
            backup.entries.length.toString())),
          actions: [
            TextButton(style: TextButton.styleFrom(minimumSize: const Size(64, 64)),
              onPressed: () => Navigator.of(context).pop(false), child: Text(strings.cancel)),
            TextButton(style: TextButton.styleFrom(minimumSize: const Size(64, 64)),
              onPressed: () => Navigator.of(context).pop(true), child: Text(strings.restoreBackup)),
          ]));
      if (!mounted || confirm != true) return;
      await service.restore(backup);
      if (mounted) _notify(AppLocalizations.of(context)!.restoreSuccess);
    } on VendorLimitException catch (error) {
      if (mounted) _notify(AppLocalizations.of(context)!.vendorLimitReached(error.limit.toString()));
    } on FormatException {
      if (mounted) _notify(AppLocalizations.of(context)!.invalidBackup);
    } on BackupTooLargeException {
      if (mounted) _notify(AppLocalizations.of(context)!.backupTooLarge);
    } catch (_) {
      if (mounted) _notify(AppLocalizations.of(context)!.restoreError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final values = settings.asData?.value ?? const <String, String>{};
    final repository = ref.read(settingsRepositoryProvider);
    final language = values['language'] ?? 'hi';
    final languageLabel = languageNativeNames[language] ?? languageNativeNames['hi']!;
    final scale = double.tryParse(values['textScale'] ?? '') ?? 1.0;
    final automatic = values['countUnmarkedAsCame'] != 'false';
    return ListView(padding: const EdgeInsets.fromLTRB(18, 6, 18, 16), children: [
      DiaryScreenHeader(title: strings.settings),
      _SettingsRow(label: strings.languageLabel, trailing: Text(languageLabel,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700)),
        onTap: _busy ? null : () => Navigator.of(context).push<void>(MaterialPageRoute(
          builder: (_) => LanguageScreen(initialLanguage: language, changing: true)))),
      _SettingsRow(label: strings.textSize, trailing: const SizedBox.shrink()),
      Row(children: [for (int index = 0; index < 3; index++) Expanded(
        child: Padding(padding: EdgeInsets.only(right: index < 2 ? 8 : 0),
          child: DiaryButton(label: [strings.smallText, strings.normalText, strings.largeText][index],
            selected: scale == [0.9, 1.0, 1.2][index],
            color: scale == [0.9, 1.0, 1.2][index] ? DiaryColors.haldi : Colors.white,
            foreground: DiaryColors.ink, edge: DiaryColors.ink,
            onPressed: _busy ? null : () => _perform(
              () => repository.setTextScale([0.9, 1.0, 1.2][index]), strings.saveError),
            child: Text(strings.textSizeSample, textAlign: TextAlign.center,
              style: [Theme.of(context).textTheme.bodyMedium,
                Theme.of(context).textTheme.labelLarge,
                Theme.of(context).textTheme.headlineLarge][index]!
                  .copyWith(color: DiaryColors.ink)),
          ))),
      ]),
      const ReminderSettings(),
      _SettingsRow(label: proPurchasesEnabled
          ? (values[proEntitlementKey] == 'true' ? strings.proActive : strings.proTitle)
          : strings.proComingSoon,
        trailing: proPurchasesEnabled ? const SizedBox.shrink()
          : const Icon(Icons.lock_outline, color: DiaryColors.muted),
        onTap: _busy || !proPurchasesEnabled ? null
          : () => Navigator.of(context).push<void>(MaterialPageRoute(
            builder: (_) => const ProScreen()))),
      if (!proPurchasesEnabled) Padding(padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Text(strings.allFeaturesFree, style: Theme.of(context).textTheme.bodyMedium)),
      _SettingsRow(label: strings.manageVendors, trailing: const SizedBox.shrink(),
        onTap: _busy ? null : () => Navigator.of(context).push<void>(MaterialPageRoute(
          builder: (_) => const ManageVendorsScreen()))),
      _SettingsToggle(label: strings.countUnmarkedLabel, value: automatic,
        onChanged: _busy ? null : (value) => _perform(
          () => repository.setCountUnmarked(value), strings.saveError)),
      const SizedBox(height: 18),
      DiaryButton(label: strings.shareBackup, color: Colors.white,
        foreground: DiaryColors.ink, edge: DiaryColors.ink,
        onPressed: _busy ? null : () => _perform(
          () => ref.read(backupServiceProvider).shareBackup(), strings.shareError)),
      const SizedBox(height: 12),
      DiaryButton(label: strings.restoreBackup, color: Colors.white,
        foreground: DiaryColors.ink, edge: DiaryColors.ink,
        onPressed: _busy ? null : _restore),
      if (_busy) Padding(padding: const EdgeInsets.only(top: 12),
        child: Semantics(label: strings.saving, liveRegion: true,
          child: const Center(child: CircularProgressIndicator()))),
      const SizedBox(height: 12),
      Text(strings.privacy, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium),
    ]);
  }
}
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, required this.trailing, this.onTap});
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(color: Colors.transparent,
    child: InkWell(onTap: onTap, child: Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: DiaryColors.rule, width: 2))),
      child: Row(children: [
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge!
          .copyWith(fontWeight: FontWeight.w700))),
        const SizedBox(width: 8), Flexible(child: trailing),
        if (onTap != null) const Icon(Icons.chevron_right),
      ])),
  ));
}
class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({required this.label, required this.value, required this.onChanged});
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  @override
  Widget build(BuildContext context) => Semantics(label: label, toggled: value,
    enabled: onChanged != null, excludeSemantics: true,
    onTap: onChanged == null ? null : () => onChanged!(!value),
    child: _SettingsRow(label: label,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      trailing: IgnorePointer(child: Switch(value: value, onChanged: onChanged,
        activeTrackColor: DiaryColors.cameEdge, activeThumbColor: Colors.white,
        inactiveThumbColor: Colors.white, inactiveTrackColor: DiaryColors.rule,
        trackOutlineColor: WidgetStateProperty.all(DiaryColors.ink),
        trackOutlineWidth: WidgetStateProperty.all(2))),
    ));
}

