import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/utils/date_keys.dart';
export '../../core/utils/date_keys.dart' show diaryDate;

enum Attendance { came, notCame }

bool scheduledOn(Vendor vendor, DateTime date) =>
    !vendor.archived && vendor.createdAt.compareTo(diaryDate(date)) <= 0 &&
    (vendor.scheduleDays & (1 << (date.weekday - 1))) != 0;

class TodayVendor {
  const TodayVendor(this.vendor, this.status);
  final Vendor vendor;
  final Attendance? status;
}

final todayRepositoryProvider = Provider<TodayRepository>((ref) =>
    TodayRepository(ref.watch(databaseProvider)));
final todayVendorsProvider = StreamProvider.autoDispose.family<List<TodayVendor>, DateTime>(
  (ref, date) => ref.watch(todayRepositoryProvider).watchDay(date),
);

class TodayRepository {
  TodayRepository(this.database);
  final AppDatabase database;

  Stream<List<TodayVendor>> watchDay(DateTime day) {
    final vendors = database.vendors;
    final entries = database.entries;
    final query = database.select(vendors).join([
      leftOuterJoin(entries, entries.vendorId.equalsExp(vendors.id) &
          entries.date.equals(diaryDate(day))),
    ])..where(vendors.archived.equals(false));
    query.orderBy([OrderingTerm.asc(vendors.id)]);
    return query.watch().map((rows) => [
      for (final row in rows)
        if (scheduledOn(row.readTable(vendors), day))
          TodayVendor(row.readTable(vendors),
            switch (row.readTableOrNull(entries)?.status) {
              'came' => Attendance.came,
              'notCame' => Attendance.notCame,
              _ => null,
            }),
    ]);
  }

  Future<void> toggle(int vendorId, DateTime day, Attendance status) =>
      database.transaction(() async {
        final vendor = await (database.select(database.vendors)
          ..where((row) => row.id.equals(vendorId))).getSingle();
        if (!scheduledOn(vendor, day)) return;
        final date = diaryDate(day);
        final query = database.select(database.entries)..where((row) =>
          row.vendorId.equals(vendorId) & row.date.equals(date));
        final entry = await query.getSingleOrNull();
        if (entry?.status == status.name) {
          await (database.delete(database.entries)..where((row) =>
            row.vendorId.equals(vendorId) & row.date.equals(date))).go();
        } else {
          await database.into(database.entries).insertOnConflictUpdate(
            EntriesCompanion.insert(vendorId: vendorId, date: date,
              status: status.name),
          );
        }
      });

  Future<void> markAllCame(DateTime day) => database.transaction(() async {
    final vendors = await (database.select(database.vendors)
      ..where((row) => row.archived.equals(false))).get();
    for (final vendor in vendors.where((vendor) => scheduledOn(vendor, day))) {
      await database.into(database.entries).insert(
        EntriesCompanion.insert(vendorId: vendor.id, date: diaryDate(day),
          status: Attendance.came.name),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });
}

