import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/core/utils/date_keys.dart';
import 'package:hisab_diary/features/month/month_bill.dart';
import 'package:hisab_diary/features/month/month_repository.dart';
import 'package:hisab_diary/features/vendors/vendor_repository.dart';

void main() {
  late AppDatabase db;
  late MonthRepository repository;
  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = MonthRepository(db);
  });
  tearDown(() => db.close());
  Future<int> addVendor({int schedule = 127, String created = '2020-01-01'}) =>
    db.into(db.vendors).insert(VendorsCompanion.insert(type: 'milk', unit: 'litre',
      defaultQty: 1, rate: 60, scheduleDays: Value(schedule), createdAt: created));

  test('rate changes preserve earlier months and apply to current and later months', () async {
    final now = DateTime.now();
    final current = DateTime(now.year, now.month);
    final previous = DateTime(now.year, now.month - 1);
    final next = DateTime(now.year, now.month + 1);
    final id = await addVendor(created: diaryDate(previous));
    await db.saveSetting('countUnmarkedAsCame', 'false');
    await db.into(db.monthRates).insert(MonthRatesCompanion.insert(
      vendorId: id, month: diaryMonth(previous), rate: 60, qty: 1));
    for (final month in [previous, current, next]) {
      await db.into(db.entries).insert(EntriesCompanion.insert(vendorId: id,
        date: diaryDate(month), status: 'came'));
    }
    await VendorRepository(db).changeRate(id, quantity: 0.5, rate: 80);
    final reference = DateTime(next.year, next.month + 1);
    expect((await repository.loadMonth(id, previous, reference)).total, 60);
    expect((await repository.loadMonth(id, current, reference)).total, 40);
    expect((await repository.loadMonth(id, next, reference)).total, 40);
    expect(await db.select(db.monthRates).get(), hasLength(2));
    await VendorRepository(db).changeRate(id, quantity: 2, rate: 70);
    expect((await repository.loadMonth(id, previous, reference)).total, 60);
    expect((await repository.loadMonth(id, current, reference)).total, 140);
  });

  test('calendar toggle switches automatic came to absent, then explicit came', () async {
    final id = await addVendor();
    final day = DateTime(2020, 1, 2);
    final before = await repository.loadMonth(id, day, DateTime.now());
    expect(before.days[2], DayAttendance.automatic);
    await repository.toggleDay(id, day);
    expect((await repository.loadMonth(id, day, DateTime.now())).days[2], DayAttendance.notCame);
    await repository.toggleDay(id, day);
    expect((await repository.loadMonth(id, day, DateTime.now())).days[2], DayAttendance.came);
    await db.saveSetting('countUnmarkedAsCame', 'false');
    await repository.toggleDay(id, DateTime(2020, 1, 3));
    expect((await repository.loadMonth(id, day, DateTime.now())).days[3], DayAttendance.came);
    expect(await db.select(db.entries).get(), hasLength(2));
  });

  test('past dates before creation update totals; future dates remain blocked', () async {
    final id = await addVendor(schedule: 1, created: '2020-01-02');
    await repository.toggleDay(id, DateTime(2020, 1, 1));
    await repository.toggleDay(id, DateTime.now().add(const Duration(days: 2)));
    expect(await db.select(db.entries).get(), hasLength(1));
    final past = await repository.loadMonth(id, DateTime(2020, 1), DateTime.now());
    expect(past.days[1], DayAttendance.came);
    expect(past.total, greaterThanOrEqualTo(60));
    await repository.toggleDay(id, DateTime(2020, 1, 1));
    final updated = await repository.loadMonth(id, DateTime(2020, 1), DateTime.now());
    expect(updated.days[1], DayAttendance.notCame);
    expect(updated.total, past.total - 60);
    await repository.toggleDay(id, DateTime(2020, 1, 2));
    expect((await (db.select(db.entries)..where((row) => row.date.equals('2020-01-02'))).getSingle()).status, 'came');
    await repository.toggleDay(id, DateTime(2020, 1, 2));
    expect((await (db.select(db.entries)..where((row) => row.date.equals('2020-01-02'))).getSingle()).status, 'notCame');
  });

  test('reading auto-counted months never inserts entries', () async {
    final id = await addVendor();
    final bill = await repository.watchMonth(id, DateTime(2020, 2), DateTime.now()).first;
    expect(bill.cameDays, 29);
    expect(bill.automaticDays, 29);
    expect(await db.select(db.entries).get(), isEmpty);
    await db.saveSetting('countUnmarkedAsCame', 'false');
    expect((await repository.loadMonth(id, DateTime(2020, 2), DateTime.now())).cameDays, 0);
  });
}
