import 'dart:math' as math;
import 'dart:convert';
import 'delivery_mode.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/utils/billing_amounts.dart';
import '../../core/utils/date_keys.dart';
import '../month/month_repository.dart';
import '../month/month_bill.dart' show diaryMonth;
export '../../core/storage/app_database.dart';

final diaryLedgerRepositoryProvider = Provider<DiaryLedgerRepository>((ref) =>
  DiaryLedgerRepository(ref.watch(databaseProvider)));
final ledgerDetailsProvider = StreamProvider.autoDispose.family<LedgerDetails,
  ({int vendorId, DateTime month})>((ref, request) => ref.watch(diaryLedgerRepositoryProvider)
    .watchDetails(request.vendorId, request.month));

extension PurchaseMoney on Purchase {
  int get totalPaise => (quantity * unitPricePaise).round();
}
class VendorBalance {
  const VendorBalance({required this.monthTotalPaise, required this.monthPaidPaise,
    required this.openingBalancePaise});
  final int monthTotalPaise;
  final int monthPaidPaise;
  final int openingBalancePaise;
  int get balancePaise => openingBalancePaise + monthTotalPaise - monthPaidPaise;
  int get duePaise => math.max(0, balancePaise);
  int get creditPaise => math.max(0, -balancePaise);
}
class LedgerDetails {
  const LedgerDetails({required this.vendor, required this.dailyDetails, required this.rates,
    required this.pauses, required this.purchases, required this.payments,
    required this.itemizedOnly, required this.balance});
  final Vendor vendor;
  final List<DailyDetail> dailyDetails;
  final List<RateChange> rates;
  final List<VendorPause> pauses;
  final List<Purchase> purchases;
  final List<LedgerPayment> payments;
  final bool itemizedOnly;
  final VendorBalance balance;
}
class DiaryLedgerRepository {
  DiaryLedgerRepository(this.database);
  final AppDatabase database;
  Future<Vendor> _vendor(int id) => (database.select(database.vendors)
    ..where((row) => row.id.equals(id))).getSingle();
  Future<String> _day(int id, DateTime date, {bool future = false}) async {
    final vendor = await _vendor(id);
    final day = diaryDate(date);
    if (date.year < 1 || date.year > 2100 || day.compareTo(vendor.createdAt) < 0 ||
        (!future && day.compareTo(diaryDate(DateTime.now())) > 0)) {
      throw ArgumentError('Date is outside this vendor diary');
    }
    return day;
  }
  String _note(String note) {
    final value = note.trim();
    if (value.length > 500) throw ArgumentError('Note is too long');
    return value;
  }
  Future<void> saveDaily(int vendorId, DateTime day, {double? quantity, String note = ''}) =>
    database.transaction(() async {
      final date = await _day(vendorId, day);
      final vendor = await _vendor(vendorId);
      if (quantity != null && !validBillAmounts(quantity, vendor.rate)) {
        throw ArgumentError('Invalid quantity');
      }
      final value = _note(note);
      if (quantity != null) {
        await database.into(database.entries).insertOnConflictUpdate(
          EntriesCompanion.insert(vendorId:vendorId,date:date,status:'came'));
      }
      if (quantity == null && value.isEmpty) {
        await (database.delete(database.dailyDetails)..where((row) =>
          row.vendorId.equals(vendorId) & row.date.equals(date))).go();
      } else {
        await database.into(database.dailyDetails).insertOnConflictUpdate(
          DailyDetailsCompanion.insert(vendorId: vendorId, date: date,
            quantity: Value(quantity), note: Value(value)));
      }
    });
  Future<void> saveRate(int vendorId, DateTime effectiveDate,
      {required double quantity, required double rate}) => database.transaction(() async {
    if (!validBillAmounts(quantity, rate)) throw ArgumentError('Invalid rate');
    final date = await _day(vendorId, effectiveDate, future: true);
    await database.into(database.rateChanges).insertOnConflictUpdate(
      RateChangesCompanion.insert(vendorId: vendorId, effectiveDate: date,
        quantity: quantity, rate: rate));
    final current = await (database.select(database.rateChanges)..where((row) =>
      row.vendorId.equals(vendorId) & row.effectiveDate.isSmallerOrEqualValue(diaryDate(DateTime.now())))
      ..orderBy([(row) => OrderingTerm.desc(row.effectiveDate)])..limit(1)).getSingleOrNull();
    if (current != null) {
      await (database.update(database.vendors)..where((row) => row.id.equals(vendorId)))
        .write(VendorsCompanion(defaultQty: Value(current.quantity), rate: Value(current.rate)));
    }
  });
  Future<void> addPause(int vendorId, DateTime start, DateTime end, {String note = ''}) =>
    database.transaction(() async {
      final from = await _day(vendorId, start, future: true);
      final to = await _day(vendorId, end, future: true);
      if (from.compareTo(to) > 0) throw ArgumentError('Invalid pause range');
      await database.into(database.vendorPauses).insert(VendorPausesCompanion.insert(
        vendorId: vendorId, startDate: from, endDate: to, note: Value(_note(note))));
    });
  Future<void> deletePause(int id) => (database.delete(database.vendorPauses)
    ..where((row) => row.id.equals(id))).go();
  Future<void> addPurchase(int vendorId, DateTime date, {required String name,
      required double quantity, required double unitPrice}) => database.transaction(() async {
    final day = await _day(vendorId, date);
    final value = name.trim();
    if (value.isEmpty || value.length > 100 || !validBillAmounts(quantity, unitPrice)) {
      throw ArgumentError('Invalid purchase');
    }
    final paise = (unitPrice * 100).round();
    if (paise > maxExactPaise || quantity * paise > maxExactPaise) {
      throw ArgumentError('Purchase amount is too large');
    }
    await database.into(database.purchases).insert(PurchasesCompanion.insert(vendorId: vendorId,
      date: day, name: value, quantity: quantity, unitPricePaise: paise));
  });
  Future<void> deletePurchase(int id) => (database.delete(database.purchases)
    ..where((row) => row.id.equals(id))).go();
  Future<void> setPurchasesOnly(int vendorId, bool value, {DateTime? effectiveDate}) =>
    database.transaction(() async {
      final vendor=await _vendor(vendorId);
      final day=await _day(vendorId,effectiveDate ?? DateTime.now());
      final settings={for(final row in await database.select(database.settings).get()) row.key:row.value};
      final modes=decodePurchaseModes(settings['v3PurchaseModes:$vendorId']);
      if(modes.isEmpty && settings['v3PurchasesOnly:$vendorId']=='true') modes[vendor.createdAt]=true;
      modes[day]=value;
      settings['v3PurchaseModes:$vendorId']=jsonEncode(modes);
      await database.saveSetting('v3PurchaseModes:$vendorId',jsonEncode(modes));
      await database.saveSetting('v3PurchasesOnly:$vendorId',
        purchasesOnlyOn(settings,vendorId,diaryDate(DateTime.now())).toString());
    });
  Future<void> addPayment(int vendorId, DateTime month, DateTime date,
      {required int amountPaise, bool advance = false, String note = ''}) => database.transaction(() async {
    final day = await _day(vendorId, date);
    final vendor = await _vendor(vendorId);
    final key = diaryMonth(month);
    if (key.compareTo(vendor.createdAt.substring(0,7)) < 0 ||
        key.compareTo(diaryMonth(DateTime.now())) > 0 || amountPaise <= 0 || amountPaise > maxExactPaise) {
      throw ArgumentError('Invalid payment');
    }
    await database.into(database.ledgerPayments).insert(LedgerPaymentsCompanion.insert(
      vendorId: vendorId, month: key, date: day, amountPaise: amountPaise,
      kind: advance ? 'advance' : 'payment', note: Value(_note(note))));
  });
  Future<void> deletePayment(int id) => (database.delete(database.ledgerPayments)
    ..where((row) => row.id.equals(id))).go();
  Future<void> settleBalance(int vendorId, DateTime month) => database.transaction(() async {
    final balance = await balanceForMonth(vendorId, month);
    if (balance.duePaise > 0) {
      await addPayment(vendorId, month, DateTime.now(), amountPaise: balance.duePaise);
    }
  });
  Future<VendorBalance> balanceForMonth(int vendorId, DateTime month) => database.transaction(() async {
    final vendor = await _vendor(vendorId);
    final key = diaryMonth(month);
    final current = DateTime(month.year, month.month);
    final created = DateTime.parse(vendor.createdAt);
    var cursor = DateTime(created.year, created.month);
    final legacy = await (database.select(database.payments)..where((row) =>
      row.vendorId.equals(vendorId) & row.month.isSmallerOrEqualValue(key))).get();
    final settled = legacy.map((row) => row.month).toSet();
    final payments = await (database.select(database.ledgerPayments)..where((row) =>
      row.vendorId.equals(vendorId) & row.month.isSmallerOrEqualValue(key))).get();
    var opening = -payments.where((row) => row.month.compareTo(key) < 0)
      .fold<int>(0, (sum,row) => sum + row.amountPaise);
    var total = 0;
    while (!cursor.isAfter(current)) {
      final bill = await MonthRepository(database).loadMonth(vendorId, cursor, DateTime.now());
      final value = settled.contains(diaryMonth(cursor)) ? 0 : bill.totalPaise;
      if (cursor == current) { total = bill.totalPaise; } else { opening += value; }
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return VendorBalance(monthTotalPaise: total, openingBalancePaise: opening,
      monthPaidPaise: payments.where((row) => row.month == key)
        .fold<int>(settled.contains(key) ? total : 0, (sum,row) => sum + row.amountPaise));
  });
  Stream<LedgerDetails> watchDetails(int vendorId, DateTime month) => database.customSelect(
    'SELECT 1', readsFrom: {database.vendors, database.entries, database.monthRates, database.payments,
      database.settings, database.dailyDetails, database.rateChanges, database.vendorPauses,
      database.purchases, database.ledgerPayments}).watch().asyncMap((_) => database.transaction(() async {
        final key = diaryMonth(month);
        final vendor = await _vendor(vendorId);
        final modes={for(final row in await database.select(database.settings).get()) row.key:row.value};
        return LedgerDetails(vendor: vendor, itemizedOnly: purchasesOnlyOn(modes,vendorId,diaryDate(month)),
          balance: await balanceForMonth(vendorId, month),
          dailyDetails: await (database.select(database.dailyDetails)..where((row) =>
            row.vendorId.equals(vendorId) & row.date.like('$key-%'))).get(),
          rates: await (database.select(database.rateChanges)..where((row) => row.vendorId.equals(vendorId))
            ..orderBy([(row) => OrderingTerm.desc(row.effectiveDate)])).get(),
          pauses: await (database.select(database.vendorPauses)..where((row) => row.vendorId.equals(vendorId))
            ..orderBy([(row) => OrderingTerm.desc(row.startDate)])).get(),
          purchases: await (database.select(database.purchases)..where((row) =>
            row.vendorId.equals(vendorId) & row.date.like('$key-%'))
            ..orderBy([(row) => OrderingTerm.desc(row.date)])).get(),
          payments: await (database.select(database.ledgerPayments)..where((row) =>
            row.vendorId.equals(vendorId) & row.month.equals(key))
            ..orderBy([(row) => OrderingTerm.desc(row.date)])).get());
      }));
}
