import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/core/utils/date_keys.dart';
import 'package:hisab_diary/features/vendors/vendor_repository.dart';

void main() {
  late AppDatabase database;
  late VendorRepository repository;
  late String previousMonth;
  late String currentMonth;
  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = VendorRepository(database);
    final now = DateTime.now();
    previousMonth = diaryDate(DateTime(now.year, now.month - 1)).substring(0, 7);
    currentMonth = diaryDate(now).substring(0, 7);
  });
  tearDown(() => database.close());

  Future<int> addVendor(String name) async {
    final id = await database.into(database.vendors).insert(VendorsCompanion.insert(
      type: 'milk', name: Value(name), unit: 'litre', defaultQty: 1, rate: 60,
      createdAt: '$previousMonth-01'));
    await database.into(database.monthRates).insert(MonthRatesCompanion.insert(
      vendorId: id, month: previousMonth, rate: 60, qty: 1));
    await database.into(database.entries).insert(EntriesCompanion.insert(
      vendorId: id, date: '$previousMonth-01', status: 'came'));
    await database.into(database.payments).insert(PaymentsCompanion.insert(
      vendorId: id, month: previousMonth, paidAt: '$previousMonth-28'));
    return id;
  }

  test('vendor edit updates details and current rates, keeping saved history', () async {
    final id = await addVendor('Old name');
    await repository.updateDetails(id, name: '  New name  ',
      quantity: 0.5, rate: 80, scheduleDays: 21);
    final vendor = await database.select(database.vendors).getSingle();
    expect(vendor.id, id);
    expect(vendor.name, 'New name');
    expect(vendor.defaultQty, 0.5);
    expect(vendor.rate, 80);
    expect(vendor.scheduleDays, 21);
    expect(vendor.createdAt, '$previousMonth-01');
    expect(vendor.type, 'milk');
    final rates = await (database.select(database.monthRates)
      ..orderBy([(row) => OrderingTerm.asc(row.month)])).get();
    expect(rates.map((row) => (row.month, row.qty, row.rate)),
      [(previousMonth, 1.0, 60.0), (currentMonth, 0.5, 80.0)]);
    expect((await database.select(database.entries).getSingle()).status, 'came');
    expect((await database.select(database.payments).getSingle()).month, previousMonth);
  });

  test('vendor edit rejects invalid values and rename leaves rate history alone', () async {
    final id = await addVendor('Old name');
    final before = await database.select(database.vendors).getSingle();
    for (final invalid in [
      (quantity: 0.0, rate: 60.0, days: 127),
      (quantity: double.nan, rate: 60.0, days: 127),
      (quantity: 1.0, rate: -1.0, days: 127),
      (quantity: 1.0, rate: double.infinity, days: 127),
      (quantity: 1.0, rate: 60.0, days: 0),
      (quantity: 1.0, rate: 60.0, days: 128),
    ]) {
      expect(() => repository.updateDetails(id, name: 'Invalid',
        quantity: invalid.quantity, rate: invalid.rate, scheduleDays: invalid.days),
        throwsArgumentError);
    }
    expect(await database.select(database.vendors).getSingle(), before);
    await repository.updateDetails(id, name: 'New name', quantity: 1, rate: 60, scheduleDays: 127);
    expect(await database.select(database.monthRates).get(), hasLength(1));
  });

  test('vendor delete removes linked rows and keeps other vendors and settings', () async {
    final deleted = await addVendor('Delete me');
    final retained = await addVendor('Keep me');
    await database.saveSetting('language', 'hi');
    await repository.deleteVendor(deleted);
    expect((await database.select(database.vendors).get()).map((row) => row.id), [retained]);
    expect((await database.select(database.entries).get()).map((row) => row.vendorId), [retained]);
    expect((await database.select(database.monthRates).get()).map((row) => row.vendorId), [retained]);
    expect((await database.select(database.payments).get()).map((row) => row.vendorId), [retained]);
    expect((await database.select(database.settings).getSingle()).value, 'hi');
  });
}
