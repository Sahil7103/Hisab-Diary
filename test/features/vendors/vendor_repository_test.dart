import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/core/utils/date_keys.dart';
import 'package:hisab_diary/features/vendors/vendor_repository.dart';
import 'package:hisab_diary/features/vendors/vendor_type.dart';
import 'package:hisab_diary/features/pro/vendor_limits.dart';

void main() {
  late AppDatabase database;
  late VendorRepository repository;
  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = VendorRepository(database);
  });
  tearDown(() => database.close());

  test('all six types persist their defaults and matching initial month rates', () async {
    await database.saveSetting(proEntitlementKey, 'true');
    expect(VendorType.values.map((type) => type.defaultRate), [60, 8, 0, 80, 0, 0]);
    for (final type in VendorType.values) {
      final before = diaryDate(DateTime.now());
      final id = await repository.create(type: type, name: '  Ramu  ',
        quantity: type.defaultQuantity, rate: type.defaultRate, scheduleDays: 127);
      final after = diaryDate(DateTime.now());
      final vendor = await (database.select(database.vendors)
        ..where((row) => row.id.equals(id))).getSingle();
      final monthly = await (database.select(database.monthRates)
        ..where((row) => row.vendorId.equals(id))).getSingle();
      expect(vendor.type, type.name);
      expect(vendor.name, 'Ramu');
      expect(vendor.unit, type.unit);
      expect(vendor.defaultQty, 1);
      expect(vendor.archived, isFalse);
      expect(vendor.scheduleDays, 127);
      expect([before, after], contains(vendor.createdAt));
      expect(monthly.month, vendor.createdAt.substring(0, 7));
      expect(monthly.qty, vendor.defaultQty);
      expect(monthly.rate, vendor.rate);
    }
  });

  test('custom fractional quantity and weekdays persist; invalid details write nothing', () async {
    await repository.create(type: VendorType.milk, name: '', quantity: 0.5,
      rate: 65, scheduleDays: 21);
    final vendor = await database.select(database.vendors).getSingle();
    expect(vendor.name, isEmpty);
    expect(vendor.defaultQty, 0.5);
    expect(vendor.scheduleDays, 21);
    for (final invalid in [
      (quantity: 0.0, rate: 60.0, days: 127),
      (quantity: double.nan, rate: 60.0, days: 127),
      (quantity: 1.0, rate: -1.0, days: 127),
      (quantity: 1.0, rate: double.infinity, days: 127),
      (quantity: 1.0, rate: 60.0, days: 0),
      (quantity: 1.0, rate: 60.0, days: 128),
    ]) {
      expect(() => repository.create(type: VendorType.milk, name: '',
        quantity: invalid.quantity, rate: invalid.rate, scheduleDays: invalid.days),
        throwsArgumentError);
    }
    expect(await database.select(database.vendors).get(), hasLength(1));
    expect(await database.select(database.monthRates).get(), hasLength(1));
  });
}
