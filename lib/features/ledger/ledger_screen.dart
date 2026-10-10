import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/theme/diary_theme.dart';
import '../../core/utils/billing_amounts.dart';
import '../../core/utils/date_keys.dart';
import '../../core/widgets/diary_button.dart';
import '../../core/widgets/diary_screen_header.dart';
import '../../core/widgets/notebook_background.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/v3_strings.dart';
import '../vendors/vendor_type.dart';
import '../reminders/vendor_reminder_screen.dart';
import 'diary_ledger_repository.dart';
import 'ledger_widgets.dart';

class LedgerScreen extends ConsumerStatefulWidget {
  const LedgerScreen({super.key, required this.vendorId, required this.month,
    this.selectedDate});
  final int vendorId;
  final DateTime month;
  final DateTime? selectedDate;

  @override
  ConsumerState<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends ConsumerState<LedgerScreen> {
  late DateTime _month;
  late DateTime _date;
  bool _busy = false;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _month = DateTime(widget.month.year, widget.month.month);
    _date = widget.selectedDate ?? _defaultDate(_month);
  }

  DateTime _defaultDate(DateTime month) => month.year == _today.year &&
      month.month == _today.month ? _today
        : DateTime(month.year, month.month + 1, 0);

  String _dateLabel(String date) => DateFormat.yMMMd(
    AppLocalizations.of(context)!.localeName).format(DateTime.parse(date));

  Future<void> _perform(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.saveError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete(Future<void> Function() action) async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DiaryColors.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: DiaryColors.ink, width: 2)),
        title: Text(v3Text(context, 'deleteRecordTitle')),
        content: Text(v3Text(context, 'deleteRecordMessage')),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: DiaryColors.absentEdge),
            child: Text(v3Text(context, 'removeRecord'))),
        ]));
    if (mounted && confirmed == true) await _perform(action);
  }

  Future<void> _edit(_LedgerEdit kind, LedgerDetails details) async {
    if (_busy) return;
    await showModalBottomSheet<void>(context: context,
      isScrollControlled: true, useSafeArea: true,
      isDismissible: false, enableDrag: false,
      backgroundColor: DiaryColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: DiaryColors.ink, width: 2)),
      clipBehavior: Clip.antiAlias,
      builder: (_) => _LedgerEditor(kind: kind, details: details,
        month: _month, selectedDate: _date));
  }

  Future<void> _chooseDay(LedgerDetails details) async {
    final first = _month.isAfter(DateTime.parse(details.vendor.createdAt))
      ? _month : DateTime.parse(details.vendor.createdAt);
    final monthEnd = DateTime(_month.year, _month.month + 1, 0);
    final last = monthEnd.isBefore(_today) ? monthEnd : _today;
    if (first.isAfter(last)) return;
    final initial = _date.isBefore(first) ? first : _date.isAfter(last) ? last : _date;
    final chosen = await showDatePicker(context: context, initialDate: initial,
      firstDate: first, lastDate: last);
    if (mounted && chosen != null) setState(() => _date = chosen);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final request = (vendorId: widget.vendorId, month: _month);
    return NotebookBackground(child: PopScope(canPop: !_busy,
      child: Scaffold(body: SafeArea(child: ListView(
        padding: const EdgeInsets.all(18), children: [
          Align(alignment: Alignment.centerLeft, child: TextButton.icon(
            onPressed: _busy ? null : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: Text(MaterialLocalizations.of(context).backButtonTooltip))),
          DiaryScreenHeader(title: v3Text(context, 'ledgerTitle')),
          const SizedBox(height: 12),
          ...ref.watch(ledgerDetailsProvider(request)).when(
            loading: () => [Center(child: Semantics(label: strings.loading,
              child: const CircularProgressIndicator()))],
            error: (_, _) => [Text(strings.storageError,
              style: Theme.of(context).textTheme.bodyLarge),
              DiaryButton(label: strings.retry,
                onPressed: () => ref.invalidate(ledgerDetailsProvider(request)))],
            data: (details) => _content(details),
          ),
        ])))));
  }

  List<Widget> _content(LedgerDetails details) {
    final strings = AppLocalizations.of(context)!;
    final vendor = details.vendor;
    final repo = ref.read(diaryLedgerRepositoryProvider);
    final numbers = NumberFormat.decimalPattern(strings.localeName);
    final unit = vendorUnitLabel(strings, vendor.unit);
    final daily = details.dailyDetails.where((row) => row.date == diaryDate(_date));
    final detail = daily.isEmpty ? null : daily.first;
    final created = DateTime.parse(vendor.createdAt);
    final canDeliver = !_date.isAfter(_today) && !_date.isBefore(created);
    final canPay = !_month.isAfter(DateTime(_today.year, _today.month)) &&
      !_month.isBefore(DateTime(created.year, created.month));
    final canPurchase = canPay && !DateTime(_month.year, _month.month + 1, 0).isBefore(created);
    Widget empty(String key) => Text(v3Text(context, key),
      style: Theme.of(context).textTheme.bodyMedium);
    return [
      Text(vendor.name.trim().isEmpty ? vendorTypeLabel(strings, vendor.type)
        : vendor.name, style: Theme.of(context).textTheme.titleLarge),
      Row(children: [
        IconButton(tooltip: strings.previousMonth,
          onPressed: _busy ? null : () => setState(() {
            _month = DateTime(_month.year, _month.month - 1);
            _date = _defaultDate(_month);
          }), icon: const Icon(Icons.chevron_left)),
        Expanded(child: Text(DateFormat.yMMMM(strings.localeName).format(_month),
          textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge)),
        IconButton(tooltip: strings.nextMonth,
          onPressed: _busy || !_month.isBefore(DateTime(_today.year, _today.month))
            ? null : () => setState(() {
              _month = DateTime(_month.year, _month.month + 1);
              _date = _defaultDate(_month);
            }), icon: const Icon(Icons.chevron_right)),
      ]),
      LedgerBalanceCard(balance: details.balance),
      const SizedBox(height: 12),
      DiaryButton(label: v3Text(context, 'vendorReminders'),
        onPressed: _busy ? null : () => Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (_) => VendorReminderScreen(vendorId: vendor.id))),
        color: Colors.white, foreground: DiaryColors.ink, edge: DiaryColors.ink),
      LedgerSection(title: v3Text(context, 'deliveryDetails'),
        actionLabel: v3Text(context, 'editDelivery'),
        onAction: _busy || !canDeliver ? null : () => _edit(_LedgerEdit.daily, details),
        children: [
          TextButton.icon(onPressed: _busy ? null : () => _chooseDay(details),
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(_dateLabel(diaryDate(_date)))),
          Text(detail?.quantity == null ? v3Text(context, 'useDefaultQuantity')
            : '${numbers.format(detail!.quantity)} $unit',
            style: Theme.of(context).textTheme.bodyLarge),
          if (detail?.note.isNotEmpty == true)
            Text(detail!.note, style: Theme.of(context).textTheme.bodyMedium),
        ]),
      LedgerSection(title: v3Text(context, 'rateChanges'),
        actionLabel: v3Text(context, 'addRate'),
        onAction: _busy ? null : () => _edit(_LedgerEdit.rate, details), children: [
          if (details.rates.isEmpty) empty('noRateChanges'),
          for (final rate in details.rates) LedgerRecordTile(
            title: _dateLabel(rate.effectiveDate),
            subtitle: '${numbers.format(rate.quantity)} $unit × '
              '${ledgerMoney(context, (rate.rate * 100).round())}'),
        ]),
      LedgerSection(title: v3Text(context, 'pauseDeliveries'),
        actionLabel: v3Text(context, 'addPause'),
        onAction: _busy ? null : () => _edit(_LedgerEdit.pause, details), children: [
          if (details.pauses.isEmpty) empty('noPauses'),
          for (final pause in details.pauses) LedgerRecordTile(
            title: '${_dateLabel(pause.startDate)} – ${_dateLabel(pause.endDate)}',
            subtitle: pause.note,
            onDelete: _busy ? null : () => _delete(() => repo.deletePause(pause.id))),
        ]),
      LedgerSection(title: v3Text(context, 'purchases'),
        actionLabel: v3Text(context, 'addPurchase'),
        onAction: _busy || !canPurchase ? null : () => _edit(_LedgerEdit.purchase, details),
        children: [
          SwitchListTile.adaptive(contentPadding: EdgeInsets.zero,
            title: Text(v3Text(context, 'purchasesOnly'),
              style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(v3Text(context, 'purchasesOnlyInfo'),
              style: Theme.of(context).textTheme.bodyMedium),
            value: details.itemizedOnly,
            onChanged: _busy ? null : (value) => _perform(
              () => repo.setPurchasesOnly(vendor.id, value))),
          if (details.purchases.isEmpty) empty('noPurchases'),
          for (final purchase in details.purchases) LedgerRecordTile(
            title: purchase.name,
            subtitle: '${_dateLabel(purchase.date)} · '
              '${numbers.format(purchase.quantity)} × '
              '${ledgerMoney(context, purchase.unitPricePaise)}',
            amount: ledgerMoney(context,
              purchase.totalPaise),
            onDelete: _busy ? null : () => _delete(() => repo.deletePurchase(purchase.id))),
        ]),
      LedgerSection(title: v3Text(context, 'payments'),
        actionLabel: v3Text(context, 'addPayment'),
        onAction: _busy || !canPay ? null : () => _edit(_LedgerEdit.payment, details),
        children: [
          if (details.payments.isEmpty) empty('noPayments'),
          for (final payment in details.payments) LedgerRecordTile(
            title: v3Text(context, payment.kind == 'advance' ? 'advancePayment' : 'payment'),
            subtitle: [_dateLabel(payment.date), if (payment.note.isNotEmpty) payment.note].join(' · '),
            amount: ledgerMoney(context, payment.amountPaise),
            onDelete: _busy ? null : () => _delete(() => repo.deletePayment(payment.id))),
        ]),
    ];
  }
}

enum _LedgerEdit { daily, rate, pause, purchase, payment }

class _LedgerEditor extends ConsumerStatefulWidget {
  const _LedgerEditor({required this.kind, required this.details,
    required this.month, required this.selectedDate});
  final _LedgerEdit kind;
  final LedgerDetails details;
  final DateTime month;
  final DateTime selectedDate;

  @override
  ConsumerState<_LedgerEditor> createState() => _LedgerEditorState();
}

class _LedgerEditorState extends ConsumerState<_LedgerEditor> {
  final _form = GlobalKey<FormState>();
  final _quantity = TextEditingController();
  final _price = TextEditingController();
  final _name = TextEditingController();
  final _note = TextEditingController();
  late DateTime _date;
  late DateTime _end;
  bool _advance = false;
  bool _saving = false;
  bool _rangeError = false;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    final vendor = widget.details.vendor;
    _date = widget.kind == _LedgerEdit.payment ? _today : widget.selectedDate;
    final created = DateTime.parse(vendor.createdAt);
    if (_date.isBefore(created)) _date = created;
    if (widget.kind != _LedgerEdit.rate && widget.kind != _LedgerEdit.pause &&
        _date.isAfter(_today)) {
      _date = _today;
    }
    _end = _date;
    if (widget.kind == _LedgerEdit.daily) {
      _loadDaily();
    } else if (widget.kind == _LedgerEdit.rate) {
      _quantity.text = vendor.defaultQty.toString();
      _price.text = vendor.rate.toString();
    } else if (widget.kind == _LedgerEdit.purchase) {
      _quantity.text = '1';
    } else if (widget.kind == _LedgerEdit.payment && widget.details.balance.duePaise > 0) {
      _price.text = (widget.details.balance.duePaise / 100).toStringAsFixed(2);
    }
  }

  void _loadDaily() {
    final rows = widget.details.dailyDetails.where((row) => row.date == diaryDate(_date));
    _quantity.text = rows.isEmpty ? '' : rows.first.quantity?.toString() ?? '';
    _note.text = rows.isEmpty ? '' : rows.first.note;
  }

  @override
  void dispose() {
    _quantity.dispose();
    _price.dispose();
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate({bool end = false}) async {
    final future = widget.kind == _LedgerEdit.rate || widget.kind == _LedgerEdit.pause;
    var first = DateTime.parse(widget.details.vendor.createdAt);
    var last = future ? DateTime(2100, 12, 31) : _today;
    if (widget.kind == _LedgerEdit.daily || widget.kind == _LedgerEdit.purchase) {
      if (widget.month.isAfter(first)) first = widget.month;
      final monthEnd = DateTime(widget.month.year, widget.month.month + 1, 0);
      if (monthEnd.isBefore(last)) {
        last = monthEnd;
      }
    }
    if (first.isAfter(last)) return;
    final selected = end ? _end : _date;
    final initial = selected.isBefore(first) ? first : selected.isAfter(last) ? last : selected;
    final chosen = await showDatePicker(context: context, initialDate: initial,
      firstDate: first, lastDate: last);
    if (mounted && chosen != null) setState(() {
      if (end) { _end = chosen; } else { _date = chosen; }
      _rangeError = false;
      if (widget.kind == _LedgerEdit.daily) {
        _loadDaily();
      }
    });
  }

  String? _number(String? value, {bool optional = false, bool zero = false}) {
    final text = (value ?? '').trim();
    if (optional && text.isEmpty) return null;
    final number = double.tryParse(text);
    return number != null && number.isFinite && (zero ? number >= 0 : number > 0)
      && number * 100 <= maxExactPaise ? null
      : v3Text(context, zero ? 'invalidNonNegativeNumber' : 'invalidPositiveNumber');
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    if (widget.kind == _LedgerEdit.pause && _end.isBefore(_date)) {
      setState(() => _rangeError = true);
      return;
    }
    final quantity = double.tryParse(_quantity.text.trim());
    final price = double.tryParse(_price.text.trim());
    if ((widget.kind == _LedgerEdit.rate || widget.kind == _LedgerEdit.purchase) &&
        !validBillAmounts(quantity!, price!)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.invalidVendorAmount)));
      return;
    }
    if (widget.kind == _LedgerEdit.payment && (price! * 100).round() <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(v3Text(context, 'invalidPositiveNumber'))));
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    try {
      final repo = ref.read(diaryLedgerRepositoryProvider);
      final id = widget.details.vendor.id;
      switch (widget.kind) {
        case _LedgerEdit.daily:
          await repo.saveDaily(id, _date, quantity: quantity, note: _note.text);
        case _LedgerEdit.rate:
          await repo.saveRate(id, _date, quantity: quantity!, rate: price!);
        case _LedgerEdit.pause:
          await repo.addPause(id, _date, _end, note: _note.text);
        case _LedgerEdit.purchase:
          await repo.addPurchase(id, _date, name: _name.text,
            quantity: quantity!, unitPrice: price!);
        case _LedgerEdit.payment:
          await repo.addPayment(id, widget.month, _date,
            amountPaise: (price! * 100).round(), advance: _advance, note: _note.text);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.saveError)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _field(String key, TextEditingController controller,
      {bool number = false, bool optional = false, bool zero = false}) => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: TextFormField(controller: controller, enabled: !_saving,
      keyboardType: number ? const TextInputType.numberWithOptions(decimal: true)
        : TextInputType.text,
      textCapitalization: number ? TextCapitalization.none : TextCapitalization.sentences,
      style: Theme.of(context).textTheme.bodyLarge,
      maxLength: number ? null : key == 'purchaseName' ? 100 : 500,
      maxLines: key == 'deliveryNote' || key == 'pauseNote' || key == 'paymentNote' ? 3 : 1,
      decoration: InputDecoration(labelText: v3Text(context, key),
        helperText: optional && number ? v3Text(context, 'defaultQuantityInfo') : null,
        helperMaxLines: 3, errorMaxLines: 3, filled: true, fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: DiaryColors.ink, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: DiaryColors.ink, width: 2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: DiaryColors.pen, width: 2))),
      validator: number ? (value) => _number(value, optional: optional, zero: zero)
        : key == 'purchaseName' ? (value) => (value ?? '').trim().isEmpty
          ? v3Text(context, 'requiredName') : null : null));

  Widget _dateButton(String key, DateTime date, {bool end = false}) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: DiaryButton(label: '${v3Text(context, key)}: '
      '${DateFormat.yMMMd(AppLocalizations.of(context)!.localeName).format(date)}',
      onPressed: _saving ? null : () => _pickDate(end: end),
      color: Colors.white, foreground: DiaryColors.ink, edge: DiaryColors.ink));

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final kind = widget.kind;
    final title = switch (kind) {
      _LedgerEdit.daily => 'editDelivery', _LedgerEdit.rate => 'addRate',
      _LedgerEdit.pause => 'addPause', _LedgerEdit.purchase => 'addPurchase',
      _LedgerEdit.payment => 'addPayment',
    };
    return PopScope(canPop: !_saving, child: NotebookBackground(
      child: SafeArea(top: false, child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(18, 20, 18,
          18 + MediaQuery.viewInsetsOf(context).bottom),
        child: Form(key: _form, child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Semantics(header: true, child: Text(v3Text(context, title),
            style: Theme.of(context).textTheme.titleLarge)),
          _dateButton(kind == _LedgerEdit.rate ? 'effectiveDate'
            : kind == _LedgerEdit.pause ? 'pauseStart'
            : kind == _LedgerEdit.payment ? 'paymentDate' : 'chooseDate', _date),
          if (kind == _LedgerEdit.pause) ...[
            _dateButton('pauseEnd', _end, end: true),
            if (_rangeError) Text(v3Text(context, 'invalidDateRange'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DiaryColors.absentEdge)),
            _field('pauseNote', _note),
          ],
          if (kind == _LedgerEdit.daily) ...[
            _field('deliveryQuantity', _quantity, number: true, optional: true),
            _field('deliveryNote', _note),
          ],
          if (kind == _LedgerEdit.rate || kind == _LedgerEdit.purchase) ...[
            if (kind == _LedgerEdit.purchase) _field('purchaseName', _name),
            _field(kind == _LedgerEdit.purchase ? 'purchaseQuantity' : 'dailyQuantity',
              _quantity, number: true),
            _field('unitPrice', _price, number: true, zero: true),
          ],
          if (kind == _LedgerEdit.payment) ...[
            _field('paymentAmount', _price, number: true),
            SwitchListTile.adaptive(contentPadding: EdgeInsets.zero,
              title: Text(v3Text(context, 'advancePayment'),
                style: Theme.of(context).textTheme.bodyLarge),
              value: _advance,
              onChanged: _saving ? null : (value) => setState(() => _advance = value)),
            _field('paymentNote', _note),
          ],
          const SizedBox(height: 18),
          DiaryButton(label: _saving ? strings.saving : v3Text(context, 'save'),
            onPressed: _saving ? null : _save),
          const SizedBox(height: 10),
          DiaryButton(label: strings.cancel, onPressed: _saving ? null
            : () => Navigator.of(context).pop(), color: Colors.white,
            foreground: DiaryColors.ink, edge: DiaryColors.ink),
        ]))))));
  }
}
