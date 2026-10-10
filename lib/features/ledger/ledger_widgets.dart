import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/v3_strings.dart';
import 'diary_ledger_repository.dart';

String ledgerMoney(BuildContext context, int paise) => NumberFormat.currency(
  locale: AppLocalizations.of(context)!.localeName, symbol: '₹',
  decimalDigits: paise % 100 == 0 ? 0 : 2).format(paise / 100);

class LedgerBalanceCard extends StatelessWidget {
  const LedgerBalanceCard({super.key, required this.balance});
  final VendorBalance balance;

  @override
  Widget build(BuildContext context) => Card(margin: EdgeInsets.zero,
    child: Padding(padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _row(context, 'monthTotal', balance.monthTotalPaise),
        _row(context, 'openingBalance', balance.openingBalancePaise),
        _row(context, 'paidAmount', balance.monthPaidPaise),
        const Divider(color: DiaryColors.rule, thickness: 2),
        _row(context, 'amountDue', balance.duePaise, emphasis: true),
        if (balance.creditPaise > 0)
          _row(context, 'creditBalance', balance.creditPaise, emphasis: true),
      ])));

  Widget _row(BuildContext context, String key, int amount,
      {bool emphasis = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: LayoutBuilder(builder: (context, constraints) {
      final vertical = constraints.maxWidth < 260 ||
        MediaQuery.textScalerOf(context).scale(19) > 28;
      final label = Text(v3Text(context, key),
        style: Theme.of(context).textTheme.bodyMedium);
      final value = Text(ledgerMoney(context, amount),
        textAlign: vertical ? TextAlign.start : TextAlign.end,
        style: (emphasis ? Theme.of(context).textTheme.titleLarge
          : Theme.of(context).textTheme.bodyLarge)?.copyWith(
            color: key == 'creditBalance' ? DiaryColors.cameEdge : DiaryColors.ink));
      return vertical ? Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [label, value]) : Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: label), const SizedBox(width: 12),
            Flexible(child: value)]);
    }));
}

class LedgerSection extends StatelessWidget {
  const LedgerSection({super.key, required this.title, required this.children,
    this.actionLabel, this.onAction});
  final String title;
  final List<Widget> children;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(top: 16),
    child: Padding(padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Semantics(header: true, child: Text(title,
          style: Theme.of(context).textTheme.titleLarge)),
        const SizedBox(height: 8),
        ...children,
        if (actionLabel != null) ...[
          const SizedBox(height: 12),
          DiaryButton(label: actionLabel!, onPressed: onAction,
            color: Colors.white, foreground: DiaryColors.ink, edge: DiaryColors.ink),
        ],
      ])));
}

class LedgerRecordTile extends StatelessWidget {
  const LedgerRecordTile({super.key, required this.title, required this.subtitle,
    this.amount, this.onDelete});
  final String title;
  final String subtitle;
  final String? amount;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          if (subtitle.isNotEmpty)
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          if (amount != null) Text(amount!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
        ])),
      if (onDelete != null) IconButton(onPressed: onDelete,
        tooltip: v3Text(context, 'removeRecord'),
        icon: const Icon(Icons.delete_outline, color: DiaryColors.absentEdge)),
    ]));
}
