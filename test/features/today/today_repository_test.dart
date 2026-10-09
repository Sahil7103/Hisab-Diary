import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/today/today_repository.dart';

void main() {
  late AppDatabase database;
  late TodayRepository repository;
  final day = DateTime(2026, 10, 8);
  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = TodayRepository(database);
  });
  tearDown(() => database.close());

  Future<int> addVendor({int schedule = 127, bool archived = false,
      String createdAt = '2026-01-01'}) => database.into(database.vendors).insert(
    VendorsCompanion.insert(type: 'milk', unit: 'litre', defaultQty: 1,
      rate: 60, scheduleDays: Value(schedule), archived: Value(archived),
      createdAt: createdAt),
  );
  Future<String?> status(int id, DateTime date) async =>
    (await (database.select(database.entries)..where((row) =>
      row.vendorId.equals(id) & row.date.equals(diaryDate(date))))
      .getSingleOrNull())?.status;

  test('same status clears; opposite status replaces without duplicate rows', () async {
    final id = await addVendor();
    await repository.toggle(id, day, Attendance.came);
    expect(await status(id, day), 'came');
    await repository.toggle(id, day, Attendance.came);
    expect(await status(id, day), isNull);
    await repository.toggle(id, day, Attendance.notCame);
    expect(await status(id, day), 'notCame');
    await repository.toggle(id, day, Attendance.came);
    expect(await status(id, day), 'came');
    expect(await database.select(database.entries).get(), hasLength(1));
    await repository.toggle(id, day, Attendance.notCame);
    await repository.toggle(id, day, Attendance.notCame);
    expect(await status(id, day), isNull);
  });

  test('all came marks only eligible unmarked vendors and is idempotent', () async {
    final unmarked = await addVendor();
    final absent = await addVendor();
    final came = await addVendor();
    final offSchedule = await addVendor(schedule: 1);
    final archived = await addVendor(archived: true);
    final notCreated = await addVendor(createdAt: '2026-10-09');
    await repository.toggle(absent, day, Attendance.notCame);
    await repository.toggle(came, day, Attendance.came);
    await repository.markAllCame(day);
    await repository.markAllCame(day);
    expect(await status(unmarked, day), 'came');
    expect(await status(absent, day), 'notCame');
    expect(await status(came, day), 'came');
    for (final id in [offSchedule, archived, notCreated]) {
      expect(await status(id, day), isNull);
    }
    expect(await database.select(database.entries).get(), hasLength(3));
  });

  test('marking leaves other days and vendors unchanged', () async {
    final first = await addVendor();
    final second = await addVendor();
    final previous = DateTime(2026, 9, 30);
    await repository.toggle(first, previous, Attendance.notCame);
    await repository.toggle(second, day, Attendance.notCame);
    await repository.toggle(first, day, Attendance.came);
    expect(await status(first, previous), 'notCame');
    expect(await status(second, day), 'notCame');
    final restored = TodayRepository(database);
    final rows = await restored.watchDay(day).first;
    expect(rows.map((row) => row.status),
      [Attendance.came, Attendance.notCame]);
  });

  test('weekday masks cover Monday and Sunday; inactive vendors cannot be marked', () async {
    final monday = await addVendor(schedule: 1);
    final sunday = await addVendor(schedule: 64);
    final archived = await addVendor(archived: true);
    final mondayDay = DateTime(2026, 10, 5);
    final sundayDay = DateTime(2026, 10, 11);
    expect((await repository.watchDay(mondayDay).first)
      .map((row) => row.vendor.id), [monday]);
    expect((await repository.watchDay(sundayDay).first)
      .map((row) => row.vendor.id), [sunday]);
    await repository.toggle(monday, day, Attendance.came);
    await repository.toggle(archived, day, Attendance.came);
    expect(await database.select(database.entries).get(), isEmpty);
  });
}

