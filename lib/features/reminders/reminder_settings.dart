import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import 'reminder_service.dart';
import 'reminder_time.dart';

class ReminderSettings extends ConsumerStatefulWidget {
  const ReminderSettings({super.key});
  @override
  ConsumerState<ReminderSettings> createState() => _ReminderSettingsState();
}
class _ReminderSettingsState extends ConsumerState<ReminderSettings> {
  bool _busy = false;
  Future<void> _perform(Future<void> Function() action, {String? success}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted && success != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success)));
      }
    } catch (error) {
      if (error is PlatformException) {
        debugPrint('Reminder settings failed: ${error.code}: ${error.message}');
      } else {
        debugPrint('Reminder settings failed: ${error.runtimeType}: $error');
      }
      if (mounted) {
        final strings = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          error is ReminderPermissionException ? strings.reminderPermission : strings.reminderError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final values = ref.watch(settingsProvider).asData?.value ?? const <String, String>{};
    final enabled = values['reminderOn'] == 'true';
    final clock = reminderClock(values['reminderTime']);
    final time = TimeOfDay(hour: clock.hour, minute: clock.minute);
    final service = ref.read(reminderServiceProvider);
    return ListenableBuilder(listenable: service, builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Semantics(label: strings.eveningReminder, toggled: enabled,
          enabled: !_busy && service.supported, excludeSemantics: true,
          onTap: _busy || !service.supported ? null
            : () => _perform(() => service.setEnabled(!enabled),
              success: enabled ? null : strings.reminderAt(time.format(context))),
          child: InkWell(onTap: _busy || !service.supported ? null
            : () => _perform(() => service.setEnabled(!enabled),
                success: enabled ? null : strings.reminderAt(time.format(context))),
            child: ConstrainedBox(constraints: const BoxConstraints(minHeight: 72),
              child: Row(children: [
                Expanded(child: Text(strings.eveningReminder,
                  style: Theme.of(context).textTheme.bodyLarge)),
                ExcludeSemantics(child: Switch(value: enabled,
                  activeTrackColor: DiaryColors.cameEdge,
                  onChanged: _busy || !service.supported ? null
                    : (value) => _perform(() => service.setEnabled(value),
                      success: value ? strings.reminderAt(time.format(context)) : null))),
              ])))),
        if (enabled) ...[
          DiaryButton(label: strings.reminderAt(time.format(context)), color: Colors.white,
            foreground: DiaryColors.ink, edge: DiaryColors.ink,
            onPressed: _busy ? null : () async {
              final selected = await showTimePicker(context: context, initialTime: time,
                initialEntryMode: TimePickerEntryMode.dialOnly,
                cancelText: strings.cancel, confirmText: strings.saveVendor);
              if (mounted && context.mounted && selected != null) {
                await _perform(() => service.setTime(selected),
                  success: strings.reminderAt(selected.format(context)));
              }
            }),
          if (service.approximate) Text(strings.reminderApproximate,
            style: Theme.of(context).textTheme.bodyMedium),
          if (service.problem || values['reminderActionError'] == 'true') ...[
            Text(strings.reminderError, style: Theme.of(context).textTheme.bodyLarge),
            DiaryButton(label: strings.retry, onPressed: _busy ? null : () => _perform(() async {
              await service.setEnabled(true);
              await ref.read(databaseProvider).saveSetting('reminderActionError', 'false');
            }, success: strings.reminderAt(time.format(context)))),
          ],
        ],
        const SizedBox(height: 12),
        DiaryButton(label: strings.reminderHelpTitle, color: Colors.white,
          foreground: DiaryColors.ink, edge: DiaryColors.ink,
          onPressed: _busy ? null : () => Navigator.of(context).push<void>(MaterialPageRoute(
            builder: (_) => const ReminderHelpScreen()))),
        const SizedBox(height: 12),
      ]));
  }
}

class ReminderHelpScreen extends ConsumerStatefulWidget {
  const ReminderHelpScreen({super.key});
  @override
  ConsumerState<ReminderHelpScreen> createState() => _ReminderHelpScreenState();
}
class _ReminderHelpScreenState extends ConsumerState<ReminderHelpScreen> {
  bool _busy = false;
  Future<void> _perform(Future<void> Function() action, {bool test = false}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted && test) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.testReminderSent)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          error is ReminderPermissionException ? AppLocalizations.of(context)!.enableReminderFirst
            : AppLocalizations.of(context)!.reminderError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final service = ref.read(reminderServiceProvider);
    return NotebookBackground(child: Scaffold(body: SafeArea(child: ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 16), children: [
        Row(children: [
          const BackButton(color: DiaryColors.ink),
          Expanded(child: DiaryScreenHeader(title: strings.reminderHelpTitle)),
        ]),
        const SizedBox(height: 18),
        Text(strings.reminderBatteryIntro, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 18),
        for (final instruction in [
          strings.reminderXiaomi, strings.reminderOppo,
          strings.reminderVivo, strings.reminderRealme,
        ].indexed) ...[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 32, child: Text('${instruction.$1 + 1}.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700))),
            Expanded(child: Text(instruction.$2,
              style: Theme.of(context).textTheme.bodyLarge)),
          ]),
          const SizedBox(height: 18),
        ],
        DiaryButton(label: strings.openBatterySettings, color: Colors.white,
          foreground: DiaryColors.ink, edge: DiaryColors.ink,
          onPressed: _busy || !service.supported ? null : () => _perform(service.openBatterySettings)),
        const SizedBox(height: 12),
        DiaryButton(label: strings.testReminder,
          onPressed: _busy || !service.supported ? null
            : () => _perform(service.testReminder, test: true)),
      ]))));
  }
}
