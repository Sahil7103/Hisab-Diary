import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../month/month_bill.dart';
import '../month/month_repository.dart';
import 'all_vendors_bill.dart';
import 'bill_repository.dart';

final spendingComparisonProvider = StreamProvider.autoDispose.family<SpendingComparison,
    ({int? vendorId, DateTime month, DateTime today})>((ref, request) {
  return SpendingComparisonRepository(ref.watch(databaseProvider)).watch(
    vendorId: request.vendorId, month: request.month, today: request.today);
});

class SpendingComparison {
  const SpendingComparison({required this.current, required this.previous,
    required this.monthToDate, required this.currentThrough, required this.previousThrough});

  final AllVendorsBill current;
  final AllVendorsBill previous;
  final bool monthToDate;
  final DateTime currentThrough;
  final DateTime previousThrough;
  int get deltaPaise => current.totalPaise - previous.totalPaise;
  double? get percentChange => previous.totalPaise == 0 ? null
      : deltaPaise / previous.totalPaise * 100;
}

class SpendingComparisonRepository {
  SpendingComparisonRepository(this.database);
  final AppDatabase database;

  Stream<SpendingComparison> watch({required int? vendorId,
      required DateTime month, required DateTime today}) {
    return database.customSelect('SELECT 1', readsFrom: {
      database.vendors, database.entries, database.monthRates, database.settings,
    }).watch().asyncMap((_) => load(vendorId: vendorId, month: month, today: today));
  }

  Future<SpendingComparison> load({required int? vendorId,
      required DateTime month, required DateTime today}) => database.transaction(() async {
    final first = DateTime(month.year, month.month);
    final now = DateTime(today.year, today.month, today.day);
    final currentMonth = DateTime(now.year, now.month);
    if (first.isAfter(currentMonth)) throw ArgumentError('Cannot compare a future month');
    final previousMonth = DateTime(first.year, first.month - 1);
    final partial = first == currentMonth;
    final currentThrough = partial ? now : DateTime(first.year, first.month + 1, 0);
    final previousThrough = partial
      ? DateTime(previousMonth.year, previousMonth.month,
          math.min(now.day, daysInMonth(previousMonth)))
      : DateTime(first.year, first.month, 0);
    final current = await _bill(vendorId, first, now);
    // Keep the cutoff day's automatic-count rule identical in both periods.
    final previous = await _bill(vendorId, previousMonth, partial ? previousThrough : now);
    return SpendingComparison(current: current, previous: previous,
      monthToDate: partial, currentThrough: currentThrough, previousThrough: previousThrough);
  });

  Future<AllVendorsBill> _bill(int? vendorId, DateTime month, DateTime cutoff) async {
    if (vendorId == null) return BillRepository(database).loadAllBills(month, cutoff);
    final bill = await MonthRepository(database).loadMonth(vendorId, month, cutoff);
    return AllVendorsBill(month: month, bills: [bill]);
  }
}
