import 'package:flutter/material.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../l10n/app_localizations.dart';
import 'bill_export_service.dart';

class BillShareActions extends StatelessWidget {
  const BillShareActions({super.key, required this.busy,
    required this.onShareText, required this.onShareExport, this.textShareKey});
  final bool busy;
  final Key? textShareKey;
  final VoidCallback onShareText;
  final ValueChanged<BillExportFormat> onShareExport;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final pdf = _exportButton(context, strings.sharePdf,
      Icons.picture_as_pdf_outlined, BillExportFormat.pdf);
    final csv = _exportButton(context, strings.shareCsv,
      Icons.table_chart_outlined, BillExportFormat.csv);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      DiaryButton(key: textShareKey, label: strings.shareWhatsApp,
        color: DiaryColors.cameEdge, edge: DiaryColors.cameEdge,
        onPressed: busy ? null : onShareText),
      const SizedBox(height: 12),
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 320 || MediaQuery.textScalerOf(context).scale(1) > 1.2) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [pdf, const SizedBox(height: 12), csv]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: pdf), const SizedBox(width: 12), Expanded(child: csv),
        ]);
      }),
      if (busy) const Padding(padding: EdgeInsets.only(top: 8),
        child: LinearProgressIndicator()),
    ]);
  }

  Widget _exportButton(BuildContext context, String label, IconData icon,
      BillExportFormat format) => DiaryButton(
    label: label, color: DiaryColors.paper, edge: DiaryColors.pen,
    foreground: DiaryColors.pen,
    onPressed: busy ? null : () => onShareExport(format),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: DiaryColors.pen),
      const SizedBox(width: 8),
      Flexible(child: Text(label, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: DiaryColors.pen))),
    ]),
  );
}
