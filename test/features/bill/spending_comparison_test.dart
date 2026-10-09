import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/app/theme/diary_theme.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/bill/all_vendors_bill.dart';
import 'package:hisab_diary/features/bill/spending_comparison.dart';
import 'package:hisab_diary/features/bill/spending_comparison_card.dart';
import 'package:hisab_diary/l10n/app_localizations.dart';
import 'package:hisab_diary/features/month/month_repository.dart';

void main() {
  late AppDatabase db;
  late SpendingComparisonRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = SpendingComparisonRepository(db);
  });
  tearDown(() => db.close());

  Future<int> vendor({double rate = 10, double quantity = 1,
      bool archived = false}) => db.into(db.vendors).insert(VendorsCompanion.insert(
    type: 'milk', unit: 'litre', defaultQty: quantity, rate: rate,
    archived: Value(archived), createdAt: '2019-12-01'));
  Future<void> came(int id, String date) => db.into(db.entries).insert(
    EntriesCompanion.insert(vendorId: id, date: date, status: 'came'));

  test('complete months reuse historical rates, rounded vendor totals and the same active cohort', () async {
    await db.saveSetting('countUnmarkedAsCame', 'false');
    final first = await vendor(rate: 99);
    final second = await vendor(rate: 0.03, quantity: 0.5);
    final archived = await vendor(archived: true);
    for (final id in [first, second, archived]) {
      await came(id, '2019-12-01');
      await came(id, '2020-01-01');
    }
    for (final rate in [
      ('2019-12', 0.03), ('2020-01', 0.05), ('2020-02', 99.0),
    ]) {
      await db.into(db.monthRates).insert(MonthRatesCompanion.insert(
        vendorId: first, month: rate.$1, rate: rate.$2, qty: 0.5));
    }
    await db.into(db.payments).insert(PaymentsCompanion.insert(
      vendorId: first, month: '2020-01', paidAt: '2020-02-01'));

    final comparison = await repository.load(vendorId: null,
      month: DateTime(2020, 1, 12), today: DateTime(2020, 3));
    expect(comparison.monthToDate, isFalse);
    expect(comparison.currentThrough, DateTime(2020, 1, 31));
    expect(comparison.previousThrough, DateTime(2019, 12, 31));
    expect(comparison.current.bills.map((bill) => bill.vendor.id), [first, second]);
    expect(comparison.previous.bills.map((bill) => bill.vendor.id), [first, second]);
    expect(comparison.current.totalPaise, 5);
    expect(comparison.previous.totalPaise, 4);
    expect(comparison.deltaPaise, 1);
    expect(comparison.percentChange, 25);
    for (final bill in [...comparison.current.bills, ...comparison.previous.bills]) {
      final individual = await MonthRepository(db).loadMonth(
        bill.vendor.id, bill.month, DateTime(2020, 3));
      expect(bill.totalPaise, individual.totalPaise);
    }
    expect(await db.select(db.entries).get(), hasLength(6));
    expect(await db.select(db.payments).get(), hasLength(1));
  });

  test('month-to-date clips a leap-month cutoff and uses identical cutoff-day counting', () async {
    final id = await vendor();
    var comparison = await repository.load(vendorId: id,
      month: DateTime(2020, 3), today: DateTime(2020, 3, 31, 23));
    expect(comparison.monthToDate, isTrue);
    expect(comparison.currentThrough, DateTime(2020, 3, 31));
    expect(comparison.previousThrough, DateTime(2020, 2, 29));
    expect(comparison.current.bills.single.cameDays, 30);
    expect(comparison.previous.bills.single.cameDays, 28);
    await came(id, '2020-03-31');
    await came(id, '2020-02-29');
    comparison = await repository.load(vendorId: id,
      month: DateTime(2020, 3), today: DateTime(2020, 3, 31));
    expect(comparison.current.bills.single.cameDays, 31);
    expect(comparison.previous.bills.single.cameDays, 29);
    expect(comparison.current.total, 310);
    expect(comparison.previous.total, 290);
  });

  test('partial period excludes later prior-month marks and never divides by a zero baseline', () async {
    await db.saveSetting('countUnmarkedAsCame', 'false');
    final id = await vendor(rate: 12.25);
    await came(id, '2020-02-20');
    await came(id, '2020-03-02');
    final comparison = await repository.load(vendorId: id,
      month: DateTime(2020, 3), today: DateTime(2020, 3, 10));
    expect(comparison.previousThrough, DateTime(2020, 2, 10));
    expect(comparison.current.totalPaise, 1225);
    expect(comparison.previous.totalPaise, 0);
    expect(comparison.deltaPaise, 1225);
    expect(comparison.percentChange, isNull);
    final empty = await repository.load(vendorId: null,
      month: DateTime(2019, 11), today: DateTime(2020, 3, 10));
    expect(empty.current.totalPaise, 0);
    expect(empty.previous.totalPaise, 0);
    expect(empty.percentChange, isNull);
  });

  test('comparison refreshes when an earlier period attendance mark changes', () async {
    await db.saveSetting('countUnmarkedAsCame', 'false');
    final id = await vendor();
    await came(id, '2020-01-01');
    final iterator = StreamIterator(repository.watch(vendorId: id,
      month: DateTime(2020, 1), today: DateTime(2020, 3)));
    Future<SpendingComparison> next() async {
      expect(await iterator.moveNext().timeout(const Duration(seconds: 5)), isTrue);
      return iterator.current;
    }
    try {
      expect((await next()).percentChange, isNull);
      await came(id, '2019-12-01');
      final updated = await next();
      expect(updated.previous.totalPaise, 1000);
      expect(updated.deltaPaise, 0);
      expect(updated.percentChange, 0);
    } finally {
      await iterator.cancel();
    }
  });

  testWidgets('comparison card fits narrow large-text English and Urdu layouts with zero totals', (tester) async {
    final comparison = SpendingComparison(
      current: AllVendorsBill(month: DateTime(2020, 3), bills: []),
      previous: AllVendorsBill(month: DateTime(2020, 2), bills: []),
      monthToDate: true, currentThrough: DateTime(2020, 3, 10),
      previousThrough: DateTime(2020, 2, 10));
    for (final language in ['en', 'ur']) {
      await tester.pumpWidget(MaterialApp(key: ValueKey(language),
        locale: Locale(language), supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: diaryTheme(language), home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
          child: Scaffold(body: SingleChildScrollView(child: SizedBox(width: 280,
            child: SpendingComparisonCard(comparison: comparison)))))));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final strings = await AppLocalizations.delegate.load(Locale(language));
      expect(find.text(strings.comparisonNoBaseline), findsOneWidget);
      for (final bar in tester.widgetList<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator))) {
        expect(bar.value, 0);
      }
    }
  });
}
