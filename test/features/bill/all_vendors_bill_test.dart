import 'dart:async';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/bill/all_vendors_bill.dart';
import 'package:hisab_diary/features/bill/bill_message.dart';
import 'package:hisab_diary/features/bill/bill_repository.dart';
import 'package:hisab_diary/features/month/month_repository.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;
  late BillRepository repository;
  final month = DateTime(2020, 1);
  final today = DateTime(2020, 2, 1);

  setUpAll(() => initializeDateFormatting());
  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = BillRepository(db);
  });
  tearDown(() => db.close());

  Future<int> addVendor({String name = '', double rate = 60,
      double quantity = 1, bool archived = false}) =>
    db.into(db.vendors).insert(VendorsCompanion.insert(
      type: 'milk', name: Value(name), unit: 'litre', defaultQty: quantity,
      rate: rate, archived: Value(archived), createdAt: '2020-01-01'));

  test('combined total sums rounded vendor bills with historical rates and paid bills', () async {
    await db.saveSetting('countUnmarkedAsCame', 'false');
    final first = await addVendor(name: 'First', rate: 99);
    final second = await addVendor(name: 'Second', rate: 0.03, quantity: 0.5);
    final zero = await addVendor(name: 'No deliveries');
    final archived = await addVendor(name: 'Archived', archived: true);
    await db.into(db.monthRates).insert(MonthRatesCompanion.insert(
      vendorId: first, month: '2019-12', rate: 0.03, qty: 0.5));
    await db.into(db.monthRates).insert(MonthRatesCompanion.insert(
      vendorId: first, month: '2020-02', rate: 99, qty: 1));
    for (final id in [first, second, archived]) {
      await db.into(db.entries).insert(EntriesCompanion.insert(
        vendorId: id, date: '2020-01-01', status: 'came'));
    }
    await db.into(db.payments).insert(PaymentsCompanion.insert(
      vendorId: first, month: '2020-01', paidAt: '2020-02-01'));

    final bill = await repository.loadAllBills(DateTime(2020, 1, 15), today);
    expect(bill.month, month);
    expect(bill.bills.map((row) => row.vendor.id), [first, second, zero]);
    expect(bill.bills.map((row) => row.totalPaise), [2, 2, 0]);
    expect(bill.totalPaise, 4);
    expect(bill.total, 0.04);
    for (final row in bill.bills) {
      final individual = await MonthRepository(db).loadMonth(row.vendor.id, month, today);
      expect(row.totalPaise, individual.totalPaise);
    }
    expect(await db.select(db.entries).get(), hasLength(3));
    expect(await db.select(db.monthRates).get(), hasLength(2));
    expect(await db.select(db.payments).get(), hasLength(1));
    expect(() => bill.bills.clear(), throwsUnsupportedError);
  });

  test('combined bills refresh on attendance, rates, vendors and counting settings', () async {
    await db.saveSetting('countUnmarkedAsCame', 'false');
    final first = await addVendor(rate: 10);
    final iterator = StreamIterator(repository.watchAllBills(month, today));
    Future<AllVendorsBill> next() async {
      expect(await iterator.moveNext().timeout(const Duration(seconds: 5)), isTrue);
      return iterator.current;
    }
    try {
      expect((await next()).total, 0);
      await db.into(db.entries).insert(EntriesCompanion.insert(
        vendorId: first, date: '2020-01-01', status: 'came'));
      expect((await next()).total, 10);
      await db.into(db.monthRates).insert(MonthRatesCompanion.insert(
        vendorId: first, month: '2020-01', rate: 20, qty: 1));
      expect((await next()).total, 20);
      await addVendor(name: 'Second', rate: 5);
      expect((await next()).bills, hasLength(2));
      await db.saveSetting('countUnmarkedAsCame', 'true');
      expect((await next()).total, 775);
      await (db.update(db.vendors)..where((row) => row.id.equals(first)))
        .write(const VendorsCompanion(archived: Value(true)));
      final remaining = await next();
      expect(remaining.bills, hasLength(1));
      expect(remaining.total, 155);
      expect(await db.select(db.entries).get(), hasLength(1));
    } finally {
      await iterator.cancel();
    }
  });

  test('no active accounts has a zero combined total', () async {
    await addVendor(archived: true);
    final bill = await repository.loadAllBills(month, today);
    expect(bill.bills, isEmpty);
    expect(bill.totalPaise, 0);
  });

  test('combined sharing lists names, fallback categories and totals in all locales', () async {
    await db.saveSetting('countUnmarkedAsCame', 'false');
    final first = await addVendor(name: 'Ramu\nDelivery', rate: 31.25);
    final second = await addVendor(name: '  ', rate: 60);
    for (final id in [first, second]) {
      await db.into(db.entries).insert(EntriesCompanion.insert(
        vendorId: id, date: '2020-01-01', status: 'came'));
    }
    final bill = await repository.loadAllBills(month, today);
    for (final locale in ['hi', 'en', 'gu', 'mr', 'ta', 'ur', 'bn', 'te', 'kn']) {
      final strings = await AppLocalizations.delegate.load(Locale(locale));
      final numbers = NumberFormat.decimalPattern(locale);
      final message = allVendorsShareMessage(bill, strings);
      expect(message, startsWith('*${strings.bill}: ${strings.allVendors}*\n'));
      expect(message, contains('${strings.shareBillingMonth}: ${DateFormat.yMMMM(locale).format(month)}'));
      expect(message, contains('${numbers.format(1)}. Ramu Delivery \u00b7 ${strings.milk}: ${billTotalLabel(bill.bills.first, locale)}'));
      expect(message, contains('${numbers.format(2)}. ${strings.milk}: ${billTotalLabel(bill.bills.last, locale)}'));
      expect(message, contains('*${strings.monthlyTotal}: ${allVendorsTotalLabel(bill, locale)}*'));
      expect(message, contains(strings.allVendorsBillInfo));
      expect(message, contains('${strings.shareSource}: ${strings.appName}'));
      expect(message, endsWith('https://play.google.com/store/apps/details?id=com.trevio.hisabdiary'));
      expect(message, isNot(contains('Ramu\nDelivery')));
    }
    expect(bill.totalPaise, 9125);
  });
}
