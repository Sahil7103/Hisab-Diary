import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/services/diary_usage_analytics.dart';
import '../../core/utils/date_keys.dart';
import '../today/today_repository.dart' show Attendance;
import 'month_bill.dart';

final activeVendorsProvider = StreamProvider<List<Vendor>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.vendors)..where((row) => row.archived.equals(false))
    ..orderBy([(row) => OrderingTerm.asc(row.id)])).watch();
});
final monthRepositoryProvider = Provider<MonthRepository>((ref) =>
  MonthRepository(ref.watch(databaseProvider)));
final monthBillProvider = StreamProvider.autoDispose.family<MonthBill,
    ({int vendorId, DateTime month, DateTime today})>((ref, request) {
  return ref.watch(monthRepositoryProvider).watchMonth(
    request.vendorId, request.month, request.today);
});

class MonthRepository {
  MonthRepository(this.database, {DiaryUsageAnalytics? analytics})
      : analytics = analytics ?? DiaryUsageAnalytics(database);
  final DiaryUsageAnalytics analytics;
  final AppDatabase database;

  Stream<MonthBill> watchMonth(int vendorId, DateTime month, DateTime today) {
    final first = DateTime(month.year, month.month);
    return database.customSelect(
      'SELECT 1', readsFrom: {database.vendors, database.entries,
        database.monthRates, database.settings},
    ).watch().asyncMap((_) => loadMonth(vendorId, first, today));
  }

  Future<MonthBill> loadMonth(int vendorId, DateTime month, DateTime today) =>
      database.transaction(() async {
    final vendor = await (database.select(database.vendors)
      ..where((row) => row.id.equals(vendorId))).getSingle();
    final first = DateTime(month.year, month.month);
    final next = DateTime(first.year, first.month + 1);
    final entries = await (database.select(database.entries)..where((row) =>
      row.vendorId.equals(vendorId) & row.date.isBiggerOrEqualValue(diaryDate(first)) &
      row.date.isSmallerThanValue(diaryDate(next)))).get();
    final rate = await (database.select(database.monthRates)..where((row) =>
      row.vendorId.equals(vendorId) & row.month.isSmallerOrEqualValue(diaryMonth(first)))
      ..orderBy([(row) => OrderingTerm.desc(row.month)])..limit(1)).getSingleOrNull();
    final setting = await (database.select(database.settings)
      ..where((row) => row.key.equals('countUnmarkedAsCame'))).getSingleOrNull();
    return calculateMonthBill(vendor: vendor, month: first, now: today,
      monthRate: rate, countUnmarkedAsCame: setting?.value != 'false',
      entries: {for (final entry in entries) entry.date:
        entry.status == 'came' ? Attendance.came : Attendance.notCame});
  });

  Future<void> toggleDay(int vendorId, DateTime day) async {
    final markedCame = await database.transaction(() async {
      final date = diaryDate(day);
      final today = diaryDate(DateTime.now());
      final vendor = await (database.select(database.vendors)
        ..where((row) => row.id.equals(vendorId))).getSingle();
      if (vendor.archived || date.compareTo(today) > 0) {
        return null;
      }
      final entry = await (database.select(database.entries)..where((row) =>
        row.vendorId.equals(vendorId) & row.date.equals(date))).getSingleOrNull();
      final setting = await (database.select(database.settings)
        ..where((row) => row.key.equals('countUnmarkedAsCame'))).getSingleOrNull();
      final automaticallyCame = entry == null && setting?.value != 'false' &&
        date.compareTo(today) < 0 && date.compareTo(vendor.createdAt) >= 0 &&
        (vendor.scheduleDays & (1 << (day.weekday - 1))) != 0;
      final came = entry?.status == 'came' || automaticallyCame;
      await database.into(database.entries).insertOnConflictUpdate(
        EntriesCompanion.insert(vendorId: vendorId, date: date,
          status: came ? 'notCame' : 'came'));
      return !came;
    });
    if (markedCame != null) {
      await analytics.deliveryMarked(
        source: DeliverySource.month, came: markedCame);
    }
  }
}


