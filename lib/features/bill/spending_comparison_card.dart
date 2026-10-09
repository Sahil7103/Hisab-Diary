import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/theme/diary_theme.dart';
import '../../l10n/app_localizations.dart';
import 'all_vendors_bill.dart';
import 'bill_message.dart';
import 'spending_comparison.dart';

class SpendingComparisonCard extends StatelessWidget {
  const SpendingComparisonCard({super.key, required this.comparison});
  final SpendingComparison comparison;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final delta = comparison.deltaPaise;
    final amount = NumberFormat.currency(locale: strings.localeName, symbol: '\u20b9',
      decimalDigits: delta % 100 == 0 ? 0 : 2).format(delta.abs() / 100);
    final percent = comparison.percentChange;
    final percentFormat = NumberFormat.decimalPattern(strings.localeName)
      ..maximumFractionDigits = 1;
    final change = delta == 0 ? strings.comparisonUnchanged
      : delta > 0 ? strings.comparisonHigher(amount) : strings.comparisonLower(amount);
    final maximum = math.max(comparison.current.totalPaise, comparison.previous.totalPaise);
    return Card(margin: const EdgeInsets.symmetric(vertical: 8), child: Padding(
      padding: const EdgeInsets.all(14), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.bar_chart_rounded, color: DiaryColors.pen)),
            const SizedBox(width: 8),
            Expanded(child: Text(strings.spendingComparison, style: text.bodyLarge)),
          ]),
          const SizedBox(height: 8),
          Text(comparison.monthToDate ? strings.comparisonMonthToDate
            : strings.comparisonFullMonths, style: text.bodyMedium),
          const SizedBox(height: 16),
          _period(context, comparison.current, comparison.currentThrough, maximum,
            DiaryColors.pen),
          const SizedBox(height: 16),
          _period(context, comparison.previous, comparison.previousThrough, maximum,
            DiaryColors.muted),
          const SizedBox(height: 16),
          Container(width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: DiaryColors.haldiSoft,
              borderRadius: BorderRadius.circular(12)),
            child: Text(percent == null ? strings.comparisonNoBaseline
              : delta == 0 ? change : '$change \u00b7 ${strings.comparisonChangePercent(percentFormat.format(percent.abs()))}',
              style: text.bodyMedium?.copyWith(color: DiaryColors.ink,
                fontWeight: FontWeight.w700))),
        ])));
  }

  Widget _period(BuildContext context, AllVendorsBill bill, DateTime through,
      int maximum, Color color) {
    final strings = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final dates = DateFormat.MMMd(strings.localeName);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(DateFormat.yMMMM(strings.localeName).format(bill.month), style: text.bodyMedium),
      if (comparison.monthToDate) Text(strings.comparisonPeriod(
        dates.format(bill.month), dates.format(through)), style: text.bodySmall),
      const SizedBox(height: 4),
      Text(allVendorsTotalLabel(bill, strings.localeName),
        style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: DiaryColors.ink)),
      const SizedBox(height: 8),
      ExcludeSemantics(child: LinearProgressIndicator(
        value: maximum == 0 ? 0 : bill.totalPaise / maximum,
        minHeight: 8, color: color, backgroundColor: DiaryColors.rule,
        borderRadius: BorderRadius.circular(8))),
    ]);
  }
}
