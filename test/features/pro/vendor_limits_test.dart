import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/pro/vendor_limits.dart';
import 'package:hisab_diary/features/settings/backup_service.dart';
import 'package:hisab_diary/features/vendors/vendor_repository.dart';
import 'package:hisab_diary/features/vendors/vendor_type.dart';

void main() {
  late AppDatabase db;
  late VendorRepository vendors;
  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    vendors = VendorRepository(db);
  });
  tearDown(() => db.close());
  Future<int> add() => vendors.create(type: VendorType.milk, name: '',
    quantity: 1, rate: 60, scheduleDays: 127);

  test('free release permits concurrent additions beyond the old free limit', () async {
    final ids = await Future.wait([for (var i = 0; i < 5; i++) add()]);
    expect(ids, hasLength(5));
    expect(await db.select(db.monthRates).get(), hasLength(5));
  });

  test('free release has no old Pro vendor limit', () async {
    for (var i = 0; i < 15; i++) { await add(); }
    expect(await db.select(db.vendors).get(), hasLength(15));
    await checkVendorCapacity(db, restoringCount: 100);
  });

  test('reactivation is free and preserves attendance history', () async {
    final id = await add();
    await db.into(db.entries).insert(EntriesCompanion.insert(vendorId: id,
      date: '2026-10-01', status: 'notCame'));
    await vendors.setArchived(id, true);
    for (var i = 0; i < 4; i++) { await add(); }
    await vendors.setArchived(id, false);
    expect((await db.select(db.entries).getSingle()).status, 'notCame');
    expect((await (db.select(db.vendors)..where((row) => row.id.equals(id)))
      .getSingle()).archived, false);
  });

  test('restore is free without importing or changing purchase records', () async {
    final backupService = BackupService(db);
    await db.saveSetting(proEntitlementKey, 'true');
    for (var i = 0; i < 15; i++) { await add(); }
    final backup = DiaryBackup.decode(await backupService.exportBytes());
    expect(backup.settings.containsKey(proEntitlementKey), false);
    await db.saveSetting(proEntitlementKey, 'false');
    await backupService.restore(backup);
    expect(await vendorLimit(db), freeVendorLimit);
    expect(await db.select(db.vendors).get(), hasLength(15));
  });
}
