import '../../core/storage/app_database.dart';

// Device entitlement is deliberately excluded from diary backups.
const proEntitlementKey = 'proPurchased';
const proProductId = 'hisab_diary_pro';
// Current release is free; retain entitlement records for future paid releases.
const proPurchasesEnabled = false;
const freeVendorLimit = 3;
const proVendorLimit = 12;

class VendorLimitException implements Exception {
  const VendorLimitException(this.limit);
  final int limit;
}

Future<int> vendorLimit(AppDatabase database) async {
  final entitlement = await (database.select(database.settings)
    ..where((row) => row.key.equals(proEntitlementKey))).getSingleOrNull();
  return entitlement?.value == 'true' ? proVendorLimit : freeVendorLimit;
}

Future<void> checkVendorCapacity(AppDatabase database, {int? restoringCount}) async {
  if (!proPurchasesEnabled) return;
  final limit = await vendorLimit(database);
  final active = restoringCount ?? (await (database.select(database.vendors)
    ..where((row) => row.archived.equals(false))).get()).length + 1;
  if (active > limit) throw VendorLimitException(limit);
}
