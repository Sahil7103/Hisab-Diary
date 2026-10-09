import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/services/diary_usage_analytics.dart';
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
  TodayRepository(this.database, {DiaryUsageAnalytics? analytics})
      : analytics = analytics ?? DiaryUsageAnalytics(database);
  final DiaryUsageAnalytics analytics;
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

  Future<void> toggle(int vendorId, DateTime day, Attendance status) async {
    final marked = await database.transaction(() async {
      final vendor = await (database.select(database.vendors)
        ..where((row) => row.id.equals(vendorId))).getSingle();
      if (!scheduledOn(vendor, day)) {
        return false;
      }
      final date = diaryDate(day);
      final query = database.select(database.entries)..where((row) =>
        row.vendorId.equals(vendorId) & row.date.equals(date));
      final entry = await query.getSingleOrNull();
      if (entry?.status == status.name) {
        await (database.delete(database.entries)..where((row) =>
          row.vendorId.equals(vendorId) & row.date.equals(date))).go();
        return false;
      } else {
        await database.into(database.entries).insertOnConflictUpdate(
          EntriesCompanion.insert(vendorId: vendorId, date: date,
            status: status.name),
        );
      }
      return true;
    });
    if (marked) {
      await analytics.deliveryMarked(
        source: DeliverySource.today, came: status == Attendance.came);
    }
  }

  Future<void> markAllCame(DateTime day,
      {DeliverySource source = DeliverySource.today}) async {
    final marked = await database.transaction(() async {
      final existing = await (database.select(database.entries)
        ..where((row) => row.date.equals(diaryDate(day)))).get();
      final markedIds = existing.map((entry) => entry.vendorId).toSet();
      var count = 0;
      final vendors = await (database.select(database.vendors)
        ..where((row) => row.archived.equals(false))).get();
      for (final vendor in vendors.where((vendor) => scheduledOn(vendor, day))) {
        if (markedIds.contains(vendor.id)) {
          continue;
        }
        await database.into(database.entries).insert(
          EntriesCompanion.insert(vendorId: vendor.id, date: diaryDate(day),
            status: Attendance.came.name),
          mode: InsertMode.insertOrIgnore,
        );
        count++;
      }
      return count;
    });
    if (marked > 0) {
      await analytics.deliveryMarked(
        source: source, came: true, count: marked, bulk: true);
    }
  }
}

