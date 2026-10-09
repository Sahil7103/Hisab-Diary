import '../../core/services/app_telemetry.dart';
import '../../core/services/diary_usage_analytics.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/utils/date_keys.dart';
import '../../core/utils/billing_amounts.dart';
import 'vendor_type.dart';
import '../pro/vendor_limits.dart';

final vendorRepositoryProvider = Provider<VendorRepository>((ref) =>
    VendorRepository(ref.watch(databaseProvider)));

class VendorRepository {
  VendorRepository(this.database, {DiaryUsageAnalytics? analytics})
      : analytics = analytics ?? DiaryUsageAnalytics(database);
  final DiaryUsageAnalytics analytics;
  final AppDatabase database;

  Future<int> create({required VendorType type, required String name,
    required double quantity, required double rate, required int scheduleDays}) {
    if (!validBillAmounts(quantity, rate) ||
        scheduleDays < 1 || scheduleDays > 127) {
      throw ArgumentError('Invalid vendor details');
    }
    final date = diaryDate(DateTime.now());
    return AppTelemetry.measure('vendor_save', () async {
      final id = await database.transaction(() async {
        await checkVendorCapacity(database);
        final id = await database.into(database.vendors).insert(
          VendorsCompanion.insert(type: type.name, name: Value(name.trim()),
            unit: type.unit, defaultQty: quantity, rate: rate,
            scheduleDays: Value(scheduleDays), createdAt: date),
        );
        await database.into(database.monthRates).insert(
          MonthRatesCompanion.insert(vendorId: id, month: date.substring(0, 7),
            rate: rate, qty: quantity),
        );
        return id;
      });
      await analytics.vendorAdded();
      return id;
    });
  }
  Future<void> changeRate(int vendorId, {required double quantity,
    required double rate}) {
    if (!validBillAmounts(quantity, rate)) {
      throw ArgumentError('Invalid vendor rate');
    }
    final month = diaryDate(DateTime.now()).substring(0, 7);
    return AppTelemetry.measure('vendor_save', () => database.transaction(() async {
      await (database.select(database.vendors)
        ..where((row) => row.id.equals(vendorId))).getSingle();
      await database.into(database.monthRates).insertOnConflictUpdate(
        MonthRatesCompanion.insert(vendorId: vendorId, month: month,
          rate: rate, qty: quantity));
      await (database.update(database.vendors)..where((row) => row.id.equals(vendorId)))
        .write(VendorsCompanion(rate: Value(rate), defaultQty: Value(quantity)));
    }));
  }

  Stream<List<Vendor>> watchAll() => (database.select(database.vendors)
    ..orderBy([(row) => OrderingTerm.asc(row.id)])).watch();

  Future<void> setArchived(int vendorId, bool archived) =>
      database.transaction(() async {
    final vendor = await (database.select(database.vendors)
      ..where((row) => row.id.equals(vendorId))).getSingle();
    if (vendor.archived == archived) return;
    if (!archived) await checkVendorCapacity(database);
    await (database.update(database.vendors)..where((row) => row.id.equals(vendorId)))
      .write(VendorsCompanion(archived: Value(archived)));
  });
}



