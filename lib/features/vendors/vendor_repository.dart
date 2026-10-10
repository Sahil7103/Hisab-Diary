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
    return AppTelemetry.measure('vendor_save', () => database.transaction(() async {
      await (database.select(database.vendors)
        ..where((row) => row.id.equals(vendorId))).getSingle();
      await _writeRate(vendorId, quantity: quantity, rate: rate);
    }));
  }

  Future<void> updateDetails(int vendorId, {required String name,
    required double quantity, required double rate, required int scheduleDays}) {
    if (!validBillAmounts(quantity, rate) || scheduleDays < 1 || scheduleDays > 127) {
      throw ArgumentError('Invalid vendor details');
    }
    return AppTelemetry.measure('vendor_save', () => database.transaction(() async {
      final vendor = await (database.select(database.vendors)
        ..where((row) => row.id.equals(vendorId))).getSingle();
      if (vendor.defaultQty != quantity || vendor.rate != rate) {
        await _writeRate(vendorId, quantity: quantity, rate: rate);
      }
      await (database.update(database.vendors)..where((row) => row.id.equals(vendorId)))
        .write(VendorsCompanion(name: Value(name.trim()), scheduleDays: Value(scheduleDays)));
    }));
  }

  Future<void> _writeRate(int vendorId, {required double quantity,
    required double rate}) async {
    final date = diaryDate(DateTime.now());
    await database.into(database.rateChanges).insertOnConflictUpdate(
      RateChangesCompanion.insert(vendorId: vendorId, effectiveDate: date, rate: rate, quantity: quantity));
    await (database.update(database.vendors)..where((row) => row.id.equals(vendorId)))
      .write(VendorsCompanion(rate: Value(rate), defaultQty: Value(quantity)));
  }

  Future<void> deleteVendor(int vendorId) => AppTelemetry.measure('vendor_delete',
    () => database.transaction(() async {
      await (database.delete(database.entries)..where((row) => row.vendorId.equals(vendorId))).go();
      await (database.delete(database.payments)..where((row) => row.vendorId.equals(vendorId))).go();
      await (database.delete(database.monthRates)..where((row) => row.vendorId.equals(vendorId))).go();
      await (database.delete(database.settings)..where((row) => row.key.equals('v3PurchasesOnly:$vendorId') |
        row.key.equals('v3Reminder:$vendorId'))).go();
      await (database.delete(database.vendors)..where((row) => row.id.equals(vendorId))).go();
    }));

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



