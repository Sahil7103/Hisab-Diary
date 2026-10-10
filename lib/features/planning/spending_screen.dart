import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/v3_strings.dart';
import '../bill/all_vendors_bill.dart';
import '../bill/bill_message.dart';
import '../vendors/vendor_type.dart';
import 'spending_repository.dart';

class SpendingScreen extends ConsumerStatefulWidget {
  const SpendingScreen({super.key});
  @override
  ConsumerState<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends ConsumerState<SpendingScreen> {
  int _months = 6;
  DateTime? _selected;
  bool _busy = false;

  Future<void> _editBudget(SpendingHistory history, DateTime month, VendorType? type,
      {bool chooseCategory = false}) async {
    final repository = ref.read(spendingRepositoryProvider);
    final existing = chooseCategory ? null : history.budget(month, type);
    final controller = TextEditingController(text: existing == null ? '' :
      '${existing ~/ 100}.${(existing % 100).toString().padLeft(2, '0')}');
    final form = GlobalKey<FormState>();
    var category = type ?? VendorType.milk;
    final result = await showDialog<({VendorType? type, int? amount})>(
      context: context, builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final strings = AppLocalizations.of(dialogContext)!;
          return AlertDialog(scrollable: true,
            title: Text(v3Text(dialogContext, existing == null ? 'setBudget' : 'editBudget')),
            content: Form(key: form, child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (chooseCategory) DropdownButtonFormField<VendorType>(
                initialValue: category, isExpanded: true,
                decoration: InputDecoration(labelText: v3Text(dialogContext, 'category')),
                items: [for (final value in VendorType.values) DropdownMenuItem(
                  value: value, child: Text(vendorTypeLabel(strings, value.name)))],
                onChanged: (value) { if (value != null) setDialogState(() => category = value); }),
              TextFormField(controller: controller, autofocus: !chooseCategory,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: v3Text(dialogContext, 'budgetAmount')),
                validator: (value) => parseBudgetPaise(value ?? '') == null
                  ? v3Text(dialogContext, 'budgetInvalid') : null),
            ])),
            actions: [
              if (existing != null && !chooseCategory) TextButton(
                onPressed: () => Navigator.of(dialogContext).pop((type: type, amount: null)),
                child: Text(v3Text(dialogContext, 'removeBudget'))),
              TextButton(onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(strings.cancel)),
              TextButton(onPressed: () {
                if (form.currentState?.validate() != true) return;
                Navigator.of(dialogContext).pop((type: chooseCategory ? category : type,
                  amount: parseBudgetPaise(controller.text)));
              }, child: Text(strings.saveVendor)),
            ]);
        }));
    controller.dispose();
    if (!mounted || result == null || _busy ||
        !identical(repository, ref.read(spendingRepositoryProvider))) {
      return;
    }
    setState(() => _busy = true);
    try {
      await repository.setBudget(month, result.type, result.amount);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.saveError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final request = (months: _months, today: DateTime(now.year, now.month, now.day));
    final history = ref.watch(spendingHistoryProvider(request));
    final text = Theme.of(context).textTheme;
    return NotebookBackground(child: Scaffold(body: SafeArea(child: ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 24), children: [
        Row(children: [const BackButton(color: DiaryColors.ink),
          Expanded(child: DiaryScreenHeader(title: v3Text(context, 'spendingTitle')))]),
        const SizedBox(height: 16),
        Text(v3Text(context, 'activeSpendingOnly'), style: text.bodyMedium),
        Text(v3Text(context, 'currentMonthPartial'), style: text.bodyMedium),
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 8, children: [for (final count in [6, 12])
          ChoiceChip(label: Text(v3Text(context, count == 6 ? 'sixMonths' : 'twelveMonths')),
            selected: _months == count, onSelected: (_) => setState(() {
              _months = count;
              _selected = null;
            }))]),
        const SizedBox(height: 16),
        history.when(loading: () => Center(child: Semantics(label: strings.loading,
          child: const CircularProgressIndicator())),
          error: (_, _) => DiaryButton(label: strings.retry,
            onPressed: () => ref.invalidate(spendingHistoryProvider(request))),
          data: (value) => _history(context, value)),
      ]))));
  }

  Widget _history(BuildContext context, SpendingHistory history) {
    final strings = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final selected = history.months.firstWhere((bill) => bill.month == _selected,
      orElse: () => history.months.last);
    final categories = categorySpending(selected);
    final budgetTypes = VendorType.values.where((type) =>
      categories.containsKey(type) || history.budget(selected.month, type) != null);
    final maximum = history.months.fold<int>(0, (amount, bill) => math.max(amount, bill.totalPaise));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(v3Text(context, 'monthlySpending'), style: text.titleLarge),
      const SizedBox(height: 8),
      // Rows preserve month and amount labels at large text sizes and in RTL.
      Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
        for (final bill in history.months) Semantics(
          selected: bill.month == selected.month, button: true,
          child: InkWell(onTap: () => setState(() => _selected = bill.month),
            borderRadius: BorderRadius.circular(10),
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Wrap(alignment: WrapAlignment.spaceBetween, spacing: 12, children: [
                Text(DateFormat.yMMM(strings.localeName).format(bill.month), style: text.bodyMedium),
                Text(allVendorsTotalLabel(bill, strings.localeName), style: text.bodyMedium),
              ]),
              const SizedBox(height: 6),
              ExcludeSemantics(child: LinearProgressIndicator(minHeight: 12,
                value: maximum == 0 ? 0 : bill.totalPaise / maximum,
                color: bill.month == selected.month ? DiaryColors.pen : DiaryColors.muted,
                backgroundColor: DiaryColors.rule, borderRadius: BorderRadius.circular(6))),
            ])))),
      ]))),
      if (maximum == 0) Padding(padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(v3Text(context, 'spendingEmpty'), style: text.bodyMedium)),
      const SizedBox(height: 14),
      Text(DateFormat.yMMMM(strings.localeName).format(selected.month), style: text.titleLarge),
      Text(allVendorsTotalLabel(selected, strings.localeName), style: text.headlineLarge),
      for (final bill in selected.bills) Padding(padding: const EdgeInsets.symmetric(vertical: 6),
        child: Wrap(alignment: WrapAlignment.spaceBetween, spacing: 12, children: [
          Text(billVendorLabel(bill, strings), style: text.bodyMedium),
          Text(billTotalLabel(bill, strings.localeName), style: text.bodyMedium),
        ])),
      const SizedBox(height: 18),
      Text(v3Text(context, 'budgets'), style: text.titleLarge),
      _budget(context, history, selected, null, selected.totalPaise),
      for (final type in budgetTypes) _budget(context, history, selected, type, categories[type] ?? 0),
      const SizedBox(height: 10),
      DiaryButton(label: v3Text(context, 'addCategoryBudget'), color: Colors.white,
        foreground: DiaryColors.ink, edge: DiaryColors.ink,
        onPressed: _busy ? null : () => _editBudget(history, selected.month, null, chooseCategory: true)),
    ]);
  }

  Widget _budget(BuildContext context, SpendingHistory history, AllVendorsBill month,
      VendorType? type, int spent) {
    final strings = AppLocalizations.of(context)!;
    final text = Theme.of(context).textTheme;
    final amount = history.budget(month.month, type);
    final fraction = amount == null ? 0.0 : spent / amount;
    final status = fraction > 1 ? 'budgetExceeded' : fraction >= 1 ? 'budgetReached'
      : fraction >= .8 ? 'budgetNear' : null;
    String money(int paise) => NumberFormat.currency(locale: strings.localeName, symbol: '₹',
      decimalDigits: paise % 100 == 0 ? 0 : 2).format(paise / 100);
    return Card(margin: const EdgeInsets.symmetric(vertical: 8), child: Padding(
      padding: const EdgeInsets.all(14), child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(type == null ? v3Text(context, 'overallBudget') : vendorTypeLabel(strings, type.name),
          style: text.bodyLarge),
        const SizedBox(height: 6),
        Text(amount == null ? v3Text(context, 'noBudget') : '${money(spent)} / ${money(amount)}',
          style: text.bodyMedium),
        if (amount != null) ...[
          const SizedBox(height: 8),
          LinearProgressIndicator(value: fraction.clamp(0.0, 1.0), minHeight: 8,
            color: fraction >= 1 ? DiaryColors.absent : fraction >= .8 ? DiaryColors.haldi : DiaryColors.came,
            backgroundColor: DiaryColors.rule),
          if (status != null) Padding(padding: const EdgeInsets.only(top: 8),
            child: Text(v3Text(context, status), style: text.bodyMedium?.copyWith(
              color: fraction >= 1 ? DiaryColors.absentEdge : DiaryColors.ink,
              fontWeight: FontWeight.w700))),
        ],
        TextButton(onPressed: _busy ? null : () => _editBudget(history, month.month, type),
          child: Text(v3Text(context, amount == null ? 'setBudget' : 'editBudget'))),
      ])));
  }
}


