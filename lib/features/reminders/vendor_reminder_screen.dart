import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/app_providers.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/storage/app_database.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/v3_strings.dart';
import '../vendors/manage_vendors_screen.dart';
import '../vendors/vendor_type.dart';
import 'reminder_service.dart';
import 'reminder_time.dart';
import 'vendor_reminder_service.dart';

class VendorReminderScreen extends ConsumerStatefulWidget {
  const VendorReminderScreen({super.key, this.vendorId});
  final int? vendorId;
  @override
  ConsumerState<VendorReminderScreen> createState() => _VendorReminderScreenState();
}

class _VendorReminderScreenState extends ConsumerState<VendorReminderScreen> {
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    ref.read(vendorReminderServiceProvider).start();
  }

  Future<void> _perform(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          v3Text(context, error is ReminderPermissionException ? 'notificationDenied' : 'reminderScheduleError'))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _time(Vendor vendor, VendorReminderConfig config, bool delivery) async {
    final service = ref.read(vendorReminderServiceProvider);
    final clock = reminderClock(delivery ? config.deliveryTime : config.paymentTime);
    final strings = AppLocalizations.of(context)!;
    final selected = await showTimePicker(context: context,
      initialTime: TimeOfDay(hour: clock.hour, minute: clock.minute),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      cancelText: strings.cancel, confirmText: strings.saveVendor);
    if (!mounted || selected == null ||
        !identical(service, ref.read(vendorReminderServiceProvider))) {
      return;
    }
    final time = '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}';
    await _perform(() => service.saveConfig(vendor.id,
      delivery ? config.copyWith(deliveryTime: time) : config.copyWith(paymentTime: time)));
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final vendors = ref.watch(allVendorsProvider);
    final settings = ref.watch(settingsProvider);
    final service = ref.watch(vendorReminderServiceProvider);
    final text = Theme.of(context).textTheme;
    return ListenableBuilder(listenable: service, builder: (context, _) =>
      NotebookBackground(child: Scaffold(body: SafeArea(child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 24), children: [
          Row(children: [const BackButton(color: DiaryColors.ink),
            Expanded(child: DiaryScreenHeader(title: v3Text(context, 'vendorReminders')))]),
          const SizedBox(height: 16),
          Text(v3Text(context, 'deliveryReminderInfo'), style: text.bodyMedium),
          const SizedBox(height: 8),
          Text(v3Text(context, 'paymentReminderInfo'), style: text.bodyMedium),
          const SizedBox(height: 8),
          Text(v3Text(context, 'reminderApproximateV3'), style: text.bodyMedium),
          if (!service.supported) Padding(padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(v3Text(context, 'reminderUnsupported'), style: text.bodyLarge)),
          if (service.problem) Card(child: Padding(padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(v3Text(context, service.permissionDenied ? 'notificationDenied' : 'reminderScheduleError'),
                style: text.bodyLarge),
              DiaryButton(label: strings.retry, onPressed: _busy ? null : () => _perform(service.refresh)),
            ]))),
          const SizedBox(height: 12),
          settings.when(loading: () => Center(child: Semantics(label: strings.loading,
            child: const CircularProgressIndicator())),
            error: (_, _) => DiaryButton(label: strings.retry,
              onPressed: () => ref.invalidate(settingsProvider)),
            data: (values) => vendors.when(loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => DiaryButton(label: strings.retry,
                onPressed: () => ref.invalidate(allVendorsProvider)),
              data: (rows) {
                final active = rows.where((vendor) => !vendor.archived &&
                  (widget.vendorId == null || widget.vendorId == vendor.id)).toList();
                if (active.isEmpty) return Text(strings.noVendorsCalendar, style: text.bodyLarge);
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  for (final vendor in active) _vendor(context, vendor, values, service),
                ]);
              })),
        ])))));
  }

  Widget _vendor(BuildContext context, Vendor vendor, Map<String, String> values,
      VendorReminderService service) {
    final strings = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    VendorReminderConfig config;
    try {
      config = VendorReminderConfig.decode(values['v3Reminder:${vendor.id}']);
    } catch (_) {
      return Card(child: Padding(padding: const EdgeInsets.all(14),
        child: Text(v3Text(context, 'reminderScheduleError'), style: text.bodyMedium)));
    }
    final canEdit = service.supported && !_busy;
    final purchasesOnly = values['v3PurchasesOnly:${vendor.id}'] == 'true';
    String clockLabel(String value) {
      final clock = reminderClock(value);
      return TimeOfDay(hour: clock.hour, minute: clock.minute).format(context);
    }
    return Card(margin: const EdgeInsets.symmetric(vertical: 8), child: Padding(
      padding: const EdgeInsets.all(14), child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(vendor.name.trim().isEmpty ? vendorTypeLabel(strings, vendor.type) : vendor.name,
          style: text.titleLarge),
        if (!purchasesOnly) ...[
          SwitchListTile(contentPadding: EdgeInsets.zero,
            title: Text(v3Text(context, 'deliveryReminder'), style: text.bodyLarge),
            value: config.deliveryOn, activeTrackColor: DiaryColors.cameEdge,
            onChanged: !canEdit ? null : (enabled) => _perform(() => service.saveConfig(
              vendor.id, config.copyWith(deliveryOn: enabled)))),
          if (config.deliveryOn) DiaryButton(label: clockLabel(config.deliveryTime), color: Colors.white,
            foreground: DiaryColors.ink, edge: DiaryColors.ink,
            onPressed: !canEdit ? null : () => _time(vendor, config, true)),
        ],
        SwitchListTile(contentPadding: EdgeInsets.zero,
          title: Text(v3Text(context, 'paymentReminder'), style: text.bodyLarge),
          value: config.paymentOn, activeTrackColor: DiaryColors.cameEdge,
          onChanged: !canEdit ? null : (enabled) => _perform(() => service.saveConfig(
            vendor.id, config.copyWith(paymentOn: enabled)))),
        if (config.paymentOn) ...[
          DropdownButtonFormField<int>(initialValue: config.paymentDay, isExpanded: true,
            decoration: InputDecoration(labelText: v3Text(context, 'reminderDay')),
            items: [for (var day = 1; day <= 28; day++) DropdownMenuItem(value: day,
              child: Text(NumberFormat.decimalPattern(strings.localeName).format(day)))],
            onChanged: !canEdit ? null : (day) {
              if (day != null) _perform(() => service.saveConfig(vendor.id, config.copyWith(paymentDay: day)));
            }),
          const SizedBox(height: 12),
          DiaryButton(label: clockLabel(config.paymentTime), color: Colors.white,
            foreground: DiaryColors.ink, edge: DiaryColors.ink,
            onPressed: !canEdit ? null : () => _time(vendor, config, false)),
        ],
      ])));
  }
}



