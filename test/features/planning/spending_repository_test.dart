import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/bill/bill_repository.dart';
import 'package:hisab_diary/features/planning/spending_repository.dart';
import 'package:hisab_diary/features/vendors/vendor_type.dart';

void main() {
  test('budget input uses exact paise and rejects invalid or unsafe amounts', () {
    expect(parseBudgetPaise('1250.50'), 125050);
    expect(parseBudgetPaise('۱۲۵۰٫۵'), 125050);
    expect(parseBudgetPaise('१२.२५'), 1225);
    for (final invalid in ['0', '-1', 'NaN', '1.234', '1e3', '90071992547410', '']) {
      expect(parseBudgetPaise(invalid), isNull, reason: invalid);
    }
  });

  test('history spans calendar years, excludes archived vendors, and isolates month budgets', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.saveSetting('countUnmarkedAsCame', 'false');
    Future<int> vendor(bool archived) => db.into(db.vendors).insert(VendorsCompanion.insert(
      type: 'milk', unit: 'litre', defaultQty: 1, rate: 12.25,
      archived: Value(archived), createdAt: '2025-01-01'));
    final active = await vendor(false);
    final archived = await vendor(true);
    for (final id in [active, archived]) {
      await db.into(db.entries).insert(EntriesCompanion.insert(vendorId: id,
        date: '2026-01-02', status: 'came'));
    }
    final repository = SpendingRepository(db, BillRepository(db));
    await repository.setBudget(DateTime(2026, 1), null, 500000);
    await repository.setBudget(DateTime(2026, 1), VendorType.milk, 100000);
    final result = await repository.load(months: 6, today: DateTime(2026, 1, 10));
    expect(result.months.first.month, DateTime(2025, 8));
    expect(result.months.last.totalPaise, 1225);
    expect(categorySpending(result.months.last), {VendorType.milk: 1225});
    expect(result.budget(DateTime(2026, 1), null), 500000);
    expect(result.budget(DateTime(2025, 12), null), isNull);
    await repository.setBudget(DateTime(2026, 1), VendorType.milk, null);
    expect((await repository.load(months: 12, today: DateTime(2026, 1, 10)))
      .budget(DateTime(2026, 1), VendorType.milk), isNull);
  });
}

