import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import 'vendor_details_screen.dart';
import 'vendor_type.dart';
import 'vendor_icon.dart';

class VendorTypeScreen extends StatefulWidget {
  const VendorTypeScreen({super.key});
  @override
  State<VendorTypeScreen> createState() => _VendorTypeScreenState();
}
class _VendorTypeScreenState extends State<VendorTypeScreen> {
  bool _opening = false;
  Future<void> _select(VendorType type) async {
    if (_opening) return;
    setState(() => _opening = true);
    try {
      final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(
        builder: (_) => VendorDetailsScreen(type: type)));
      if (mounted && saved == true) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return NotebookBackground(child: Scaffold(body: SafeArea(
      child: ListView(padding: const EdgeInsets.all(18), children: [
        Align(alignment: Alignment.centerLeft, child: TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(minimumSize: const Size(64, 64),
            foregroundColor: DiaryColors.ink,
            textStyle: Theme.of(context).textTheme.labelLarge),
          icon: const Icon(Icons.arrow_back), label: Text(strings.back))),
        Text(strings.pickVendorType, style: Theme.of(context).textTheme.headlineLarge),
        Text(strings.chooseOne, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, constraints) => Wrap(
          spacing: 12, runSpacing: 12,
          children: [for (final type in VendorType.values) SizedBox(
            width: MediaQuery.textScalerOf(context).scale(24) > 36
              ? constraints.maxWidth : (constraints.maxWidth - 12) / 2,
            child: DiaryButton(label: vendorTypeLabel(strings, type.name),
              color: Colors.white, edge: DiaryColors.ink, foreground: DiaryColors.ink,
              onPressed: _opening ? null : () => _select(type),
              child: ConstrainedBox(constraints: const BoxConstraints(minHeight: 96),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 48, height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: DiaryColors.haldiSoft,
                        borderRadius: BorderRadius.circular(14)),
                      child: VendorIcon(type: type.name)),
                    const SizedBox(height: 8),
                    Text(vendorTypeLabel(strings, type.name), textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge!
                        .copyWith(color: DiaryColors.ink)),
                  ])),
            ),
          )],
        )),
      ]),
    )));
  }
}
