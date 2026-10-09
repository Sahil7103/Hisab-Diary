import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/utils/billing_amounts.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import 'vendor_repository.dart';
import 'vendor_type.dart';
import '../pro/vendor_limits.dart';
import '../pro/pro_screen.dart';

class VendorDetailsScreen extends ConsumerStatefulWidget {
  const VendorDetailsScreen({super.key, required this.type});
  final VendorType type;
  @override
  ConsumerState<VendorDetailsScreen> createState() => _VendorDetailsScreenState();
}
class _VendorDetailsScreenState extends ConsumerState<VendorDetailsScreen> {
  final _name = TextEditingController();
  late double _quantity;
  late double _rate;
  bool _daily = true;
  int _weekdays = 127;
  bool _saving = false;
  bool _scheduleError = false;
  @override
  void initState() {
    super.initState();
    _quantity = widget.type.defaultQuantity;
    _rate = widget.type.defaultRate;
  }
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }
  Future<void> _editNumber({required bool quantity}) async {
    final strings = AppLocalizations.of(context)!;
    final label = quantity ? strings.dailyQuantity
      : strings.unitRate(vendorUnitLabel(strings, widget.type.unit));
    final form = GlobalKey<FormState>();
    var input = (quantity ? _quantity : _rate).toString();
    final selected = await showModalBottomSheet<double>(
      context: context, isScrollControlled: true, useSafeArea: true,
      backgroundColor: DiaryColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: DiaryColors.ink, width: 2)),
      clipBehavior: Clip.antiAlias, builder: (dialogContext) {
      void save() {
        if (form.currentState!.validate()) {
          Navigator.of(dialogContext).pop(double.parse(input.trim()));
        }
      }
      return NotebookBackground(child: SafeArea(top: false,
        child: SingleChildScrollView(padding: EdgeInsets.fromLTRB(18, 20, 18,
          18 + MediaQuery.viewInsetsOf(dialogContext).bottom),
          child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(child: Container(width: 40, height: 4,
            decoration: BoxDecoration(color: DiaryColors.muted,
              borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 18),
          Semantics(header: true, child: Text(label,
            style: Theme.of(dialogContext).textTheme.titleLarge)),
          const SizedBox(height: 16),
          Form(key: form, child: TextFormField(initialValue: input, autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(filled: true, fillColor: Colors.white,
            errorMaxLines: 3, contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: DiaryColors.ink, width: 2)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: DiaryColors.ink, width: 2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: DiaryColors.pen, width: 2))),
          onChanged: (value) => input = value,
          onFieldSubmitted: (_) => save(),
          validator: (value) {
            final number = double.tryParse((value ?? '').trim());
            return number != null && validBillAmounts(
              quantity ? number : _quantity, quantity ? _rate : number)
              ? null : strings.invalidVendorAmount;
          })),
          const SizedBox(height: 18),
          DiaryButton(label: strings.saveVendor, onPressed: save),
          const SizedBox(height: 12),
          DiaryButton(label: strings.cancel, color: Colors.white,
            foreground: DiaryColors.ink, edge: DiaryColors.ink,
            onPressed: () => Navigator.of(dialogContext).pop()),
        ]))));
    });
    if (mounted && selected != null) {
      setState(() {
        if (quantity) { _quantity = selected; } else { _rate = selected; }
      });
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    final days = _daily ? 127 : _weekdays;
    if (days == 0) {
      setState(() => _scheduleError = true);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    try {
      await ref.read(vendorRepositoryProvider).create(type: widget.type,
        name: _name.text, quantity: _quantity, rate: _rate, scheduleDays: days);
      if (mounted) Navigator.of(context).pop(true);
    } on VendorLimitException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.vendorLimitReached(error.limit.toString())),
        action: SnackBarAction(label: AppLocalizations.of(context)!.proTitle,
          onPressed: () => Navigator.of(context).push<void>(MaterialPageRoute(
            builder: (_) => const ProScreen())))));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.saveError)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final numbers = NumberFormat.decimalPattern(strings.localeName);
    final unit = vendorUnitLabel(strings, widget.type.unit);
    final weekdays = [strings.monday, strings.tuesday, strings.wednesday,
      strings.thursday, strings.friday, strings.saturday, strings.sunday];
    final weekdayShort = [strings.mondayShort, strings.tuesdayShort,
      strings.wednesdayShort, strings.thursdayShort, strings.fridayShort,
      strings.saturdayShort, strings.sundayShort];
    Widget fieldLabel(String label) => Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(label, style: Theme.of(context).textTheme.bodyLarge!
        .copyWith(fontWeight: FontWeight.w700)));
    Widget scheduleButton(String label, bool daily) => DiaryButton(label: label,
      selected: _daily == daily, color: _daily == daily
          ? DiaryColors.haldi : Colors.white,
      foreground: DiaryColors.ink, edge: DiaryColors.ink,
      onPressed: _saving ? null : () => setState(() {
        _daily = daily;
        _scheduleError = false;
      }));
    return NotebookBackground(child: PopScope(canPop: !_saving, child: Scaffold(
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
        Align(alignment: Alignment.centerLeft, child: TextButton.icon(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(minimumSize: const Size(64, 64),
            foregroundColor: DiaryColors.ink,
            textStyle: Theme.of(context).textTheme.labelLarge),
          icon: const Icon(Icons.arrow_back),
          label: Text(vendorTypeLabel(strings, widget.type.name)))),
        fieldLabel(strings.optionalName),
        TextField(controller: _name, enabled: !_saving,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(filled: true, fillColor: Colors.white,
            hintText: strings.nameHint,
            contentPadding: const EdgeInsets.all(14),
            constraints: const BoxConstraints(minHeight: 64),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: DiaryColors.ink, width: 2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: DiaryColors.pen, width: 2)))),
        fieldLabel(strings.dailyQuantity),
        _NumberStepper(value: '${numbers.format(_quantity)} $unit',
          onEdit: _saving ? null : () => _editNumber(quantity: true),
          decreaseLabel: strings.decreaseQuantity, increaseLabel: strings.increaseQuantity,
          onDecrease: !_saving && _quantity > widget.type.quantityStep
              ? () => setState(() => _quantity -= widget.type.quantityStep) : null,
          onIncrease: _saving ? null
              : () => setState(() => _quantity += widget.type.quantityStep)),
        fieldLabel(strings.unitRate(unit)),
        _NumberStepper(value: '₹ ${numbers.format(_rate)}',
          onEdit: _saving ? null : () => _editNumber(quantity: false),
          decreaseLabel: strings.decreaseRate, increaseLabel: strings.increaseRate,
          onDecrease: !_saving && _rate > 0 ? () => setState(() => _rate = (_rate - 1).clamp(0, double.infinity)) : null,
          onIncrease: _saving ? null : () => setState(() => _rate += 1)),
        fieldLabel(strings.deliverySchedule),
        LayoutBuilder(builder: (context, constraints) {
          final large = MediaQuery.textScalerOf(context).scale(24) > 30;
          return Wrap(spacing: 10, runSpacing: 10, children: [
            for (final daily in [true, false]) SizedBox(
              width: large ? constraints.maxWidth : (constraints.maxWidth - 10) / 2,
              child: scheduleButton(daily ? strings.everyDay : strings.someDays, daily)),
          ]);
        }),
        if (!_daily) ...[
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (int index = 0; index < 7; index++) SizedBox(width: 72,
              child: DiaryButton(label: weekdays[index],
                selected: (_weekdays & (1 << index)) != 0,
                color: (_weekdays & (1 << index)) != 0
                    ? DiaryColors.haldi : Colors.white,
                foreground: DiaryColors.ink, edge: DiaryColors.ink,
                onPressed: _saving ? null : () => setState(() {
                  _weekdays ^= 1 << index;
                  _scheduleError = false;
                }),
                child: Text(weekdayShort[index], textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge))),
          ]),
          if (_scheduleError) Padding(padding: const EdgeInsets.only(top: 8),
            child: Semantics(liveRegion: true, child: Text(strings.chooseWeekday,
              style: Theme.of(context).textTheme.bodyMedium!
                .copyWith(color: DiaryColors.absentEdge)))),
        ],
        const SizedBox(height: 18),
        DiaryButton(label: _saving ? strings.saving : '${strings.saveVendor} ✔',
          onPressed: _saving ? null : _save),
      ])),
    )));
  }
}

class _NumberStepper extends StatelessWidget {
  const _NumberStepper({required this.value, required this.decreaseLabel,
    required this.increaseLabel, required this.onDecrease, required this.onIncrease,
    required this.onEdit});
  final String value;
  final String decreaseLabel;
  final String increaseLabel;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final VoidCallback? onEdit;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: Colors.white,
      border: Border.all(color: DiaryColors.ink, width: 2),
      borderRadius: BorderRadius.circular(18)),
    child: Row(children: [
      SizedBox(width: 64, child: DiaryButton(label: decreaseLabel, radius: 32,
        onPressed: onDecrease, child: const Icon(Icons.remove, color: Colors.white))),
      Expanded(child: InkWell(onTap: onEdit, borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(constraints: const BoxConstraints(minHeight: 64),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(child: Semantics(liveRegion: true, child: Text(value,
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge))),
              const SizedBox(width: 6),
              const Icon(Icons.edit_outlined, size: 20, color: DiaryColors.muted),
            ]))))),
      SizedBox(width: 64, child: DiaryButton(label: increaseLabel, radius: 32,
        onPressed: onIncrease, child: const Icon(Icons.add, color: Colors.white))),
    ]),
  );
}




