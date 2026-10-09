import '../../core/services/app_telemetry.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/utils/date_keys.dart';
import '../month/month_bill.dart';

final billRepositoryProvider = Provider<BillRepository>((ref) =>
  BillRepository(ref.watch(databaseProvider)));
final paidMonthProvider = StreamProvider.autoDispose.family<bool,
    ({int vendorId, DateTime month})>((ref, request) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.payments)..where((row) => row.vendorId.equals(request.vendorId) &
    row.month.equals(diaryMonth(request.month)))).watchSingleOrNull().map((row) => row != null);
});

class BillRepository {
  BillRepository(this.database);
  final AppDatabase database;

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

  Future<void> shareMessage(String message) async {
    await AppTelemetry.measure('bill_share', () async {
      final result = await SharePlus.instance.share(ShareParams(text: message));
      AppTelemetry.event('bill_share_${result.status.name}');
    });

  }
}

