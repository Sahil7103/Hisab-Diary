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

  Future<List<TodayVendor>> loadDay(DateTime day) => database.transaction(() async {
    final date = diaryDate(day);
    final vendors = await (database.select(database.vendors)..where((row) => row.archived.equals(false))
      ..orderBy([(row) => OrderingTerm.asc(row.id)])).get();
    final entries = await (database.select(database.entries)..where((row) => row.date.equals(date))).get();
    final statuses = {for (final entry in entries) entry.vendorId: entry.status};
    final pauses = await (database.select(database.vendorPauses)..where((row) =>
      row.startDate.isSmallerOrEqualValue(date) & row.endDate.isBiggerOrEqualValue(date))).get();
    final paused = pauses.map((row) => row.vendorId).toSet();
    final settings = await database.select(database.settings).get();
    final purchaseOnly = {for (final row in settings)
      if (row.key.startsWith('v3PurchasesOnly:') && row.value == 'true')
        int.tryParse(row.key.split(':').last)};
    return [for (final vendor in vendors)
      if (scheduledOn(vendor, day) && !paused.contains(vendor.id) && !purchaseOnly.contains(vendor.id))
        TodayVendor(vendor, switch(statuses[vendor.id]) {
          'came' => Attendance.came, 'notCame' => Attendance.notCame, _ => null})];
  });
  Stream<List<TodayVendor>> watchDay(DateTime day) => database.customSelect('SELECT 1',
    readsFrom: {database.vendors, database.entries, database.vendorPauses, database.settings})
    .watch().asyncMap((_) => loadDay(day));
  Future<bool> _canMark(int vendorId, DateTime day) async {
    if (diaryDate(day).compareTo(diaryDate(DateTime.now())) > 0) return false;
    return (await loadDay(day)).any((row) => row.vendor.id == vendorId);
  }
  Future<void> mark(int vendorId, DateTime day, Attendance status) => database.transaction(() async {
    if (!await _canMark(vendorId, day)) return;
    await database.into(database.entries).insertOnConflictUpdate(EntriesCompanion.insert(
      vendorId: vendorId, date: diaryDate(day), status: status.name));
  });

  Future<void> toggle(int vendorId, DateTime day, Attendance status) async {
    final marked = await database.transaction(() async {
      final vendor = await (database.select(database.vendors)
        ..where((row) => row.id.equals(vendorId))).getSingle();
      if (!scheduledOn(vendor, day) || !await _canMark(vendorId, day)) {
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
      if (diaryDate(day).compareTo(diaryDate(DateTime.now())) > 0) return 0;
      final todayVendors = await loadDay(day);
      for (final todayVendor in todayVendors) {
        final vendor = todayVendor.vendor;
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

