import '../../core/services/app_telemetry.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/utils/date_keys.dart';
import '../month/month_bill.dart';
import '../month/month_repository.dart';
import 'all_vendors_bill.dart';
import 'bill_export_service.dart';
import 'bill_review_service.dart';

final billReviewServiceProvider = Provider<BillReviewService>((ref) {
  final service = BillReviewService(ref.watch(databaseProvider));
  ref.onDispose(service.dispose);
  return service;
});
final billRepositoryProvider = Provider<BillRepository>((ref) =>
  BillRepository(ref.watch(databaseProvider),
    reviewService: ref.watch(billReviewServiceProvider)));
final paidMonthProvider = StreamProvider.autoDispose.family<bool,
    ({int vendorId, DateTime month})>((ref, request) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.payments)..where((row) => row.vendorId.equals(request.vendorId) &
    row.month.equals(diaryMonth(request.month)))).watchSingleOrNull().map((row) => row != null);
});

final allVendorsBillProvider = StreamProvider.autoDispose.family<AllVendorsBill,
    ({DateTime month, DateTime today})>((ref, request) {
  return ref.watch(billRepositoryProvider).watchAllBills(request.month, request.today);
});

class BillRepository {
  BillRepository(this.database, {this.reviewService});
  final AppDatabase database;
  final BillReviewService? reviewService;

  Stream<AllVendorsBill> watchAllBills(DateTime month, DateTime today) {
    return database.customSelect(
      'SELECT 1', readsFrom: {database.vendors, database.entries,
        database.monthRates, database.settings, database.dailyDetails,
        database.rateChanges, database.vendorPauses, database.purchases},
    ).watch().asyncMap((_) => loadAllBills(month, today));
  }

  Future<AllVendorsBill> loadAllBills(DateTime month, DateTime today) =>
      database.transaction(() async {
    final first = DateTime(month.year, month.month);
    final vendors = await (database.select(database.vendors)
      ..where((row) => row.archived.equals(false))
      ..orderBy([(row) => OrderingTerm.asc(row.id)])).get();
    final repository = MonthRepository(database);
    final bills = <MonthBill>[];
    for (final vendor in vendors) {
      bills.add(await repository.loadMonth(vendor.id, first, today));
    }
    return AllVendorsBill(month: first, bills: bills);
  });

  Future<void> markPaid(int vendorId, DateTime month) => AppTelemetry.measure('bill_mark_paid', () => database.transaction(() async {
    if (diaryMonth(month).compareTo(diaryMonth(DateTime.now())) > 0) {
      throw ArgumentError('Cannot pay a future month');
    }
    await (database.select(database.vendors)..where((row) => row.id.equals(vendorId)))
      .getSingle();
    await database.into(database.payments).insert(
      PaymentsCompanion.insert(vendorId: vendorId, month: diaryMonth(month),
        paidAt: diaryDate(DateTime.now())), mode: InsertMode.insertOrIgnore);
  }));

  Future<void> shareMessage(String message) => _share(ShareParams(text: message));

  Future<void> shareExport(BillExportFile file) => _share(ShareParams(
    files: [XFile.fromData(file.bytes, mimeType: file.mimeType)],
    fileNameOverrides: [file.name]));

  Future<void> _share(ShareParams params) async {
    final status = await AppTelemetry.measure('bill_share', () async {
      final result = await SharePlus.instance.share(params);
      AppTelemetry.event('bill_share_${result.status.name}');
      return result.status;
    });
    await reviewService?.afterShare(status);

  }
}

