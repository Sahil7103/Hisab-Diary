import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/storage/app_database.dart';
import '../../core/widgets/diary_button.dart';
import '../../l10n/app_localizations.dart';
import 'vendor_type.dart';

class VendorSelector extends StatelessWidget {
  const VendorSelector({super.key, required this.vendor, required this.vendors,
    required this.onSelectVendor, this.enabled = true});
  final Vendor vendor;
  final List<Vendor> vendors;
  final ValueChanged<int> onSelectVendor;
  final bool enabled;
  Future<void> _chooseVendor(BuildContext context) async {
    final strings = AppLocalizations.of(context)!;
    final selected = await showModalBottomSheet<int>(
      context: context, useSafeArea: true, showDragHandle: true,
      backgroundColor: DiaryColors.paper,
      builder: (context) => SafeArea(top: false, child: Column(
        mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: Semantics(header: true, child: Text(strings.chooseVendor,
              style: Theme.of(context).textTheme.titleLarge))),
          Flexible(child: ListView(shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 12), children: [
              for (final vendor in vendors) ListTile(
                minVerticalPadding: 16,
                selected: vendor.id == this.vendor.id,
                selectedTileColor: DiaryColors.haldiSoft,
                textColor: DiaryColors.ink, selectedColor: DiaryColors.pen,
                title: Text(vendorTypeLabel(strings, vendor.type)),
                subtitle: vendor.name.trim().isEmpty ? null : Text(vendor.name),
                trailing: vendor.id == this.vendor.id ? const Icon(Icons.check_circle) : null,
                onTap: () => Navigator.of(context).pop(vendor.id)),
            ])),
        ])),
    );
    if (context.mounted && selected != null && selected != vendor.id) {
      onSelectVendor(selected);
    }
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(strings.chooseVendor, style: Theme.of(context).textTheme.bodyMedium!
        .copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      DiaryButton(label: [strings.chooseVendor, vendorTypeLabel(strings, vendor.type),
        if (vendor.name.trim().isNotEmpty) vendor.name].join(', '),
        color: DiaryColors.haldiSoft, edge: DiaryColors.pen,
        foreground: DiaryColors.ink,
        onPressed: enabled ? () => _chooseVendor(context) : null,
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(vendorTypeLabel(strings, vendor.type),
              style: Theme.of(context).textTheme.titleLarge),
            if (vendor.name.trim().isNotEmpty) Text(vendor.name,
              style: Theme.of(context).textTheme.bodyMedium),
          ])),
          const SizedBox(width: 8),
          const Icon(Icons.expand_more, color: DiaryColors.pen),
        ])),
    ]);
  }
}
