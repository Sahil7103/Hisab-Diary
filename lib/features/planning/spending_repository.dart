import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import '../../core/utils/billing_amounts.dart';
import '../bill/all_vendors_bill.dart';
import '../bill/bill_repository.dart';
import '../month/month_bill.dart';
import '../vendors/vendor_type.dart';

final spendingRepositoryProvider = Provider<SpendingRepository>((ref) =>
  SpendingRepository(ref.watch(databaseProvider), ref.watch(billRepositoryProvider)));

final spendingHistoryProvider = StreamProvider.autoDispose.family<SpendingHistory,
    ({int months, DateTime today})>((ref, request) =>
  ref.watch(spendingRepositoryProvider).watch(months: request.months, today: request.today));

class SpendingHistory {
  SpendingHistory({required this.months, required this.budgets});
  final List<AllVendorsBill> months;
  final Map<String, int> budgets;
  int? budget(DateTime month, VendorType? type) => budgets[budgetKey(month, type)];
}

String budgetKey(DateTime month, VendorType? type) =>
  'v3Budget:${diaryMonth(month)}:${type?.name ?? 'all'}';

Map<VendorType, int> categorySpending(AllVendorsBill month) {
  final amounts = <VendorType, int>{};
  for (final bill in month.bills) {
    final type = VendorType.values.firstWhere((type) => type.name == bill.vendor.type,
      orElse: () => VendorType.other);
    amounts[type] = (amounts[type] ?? 0) + bill.totalPaise;
  }
  return amounts;
}

int? parseBudgetPaise(String value) {
  const digits = '٠١٢٣٤٥٦٧٨٩۰۱۲۳۴۵۶۷۸۹०१२३४५६७८९';
  final normalized = value.trim().split('').map((character) {
    final index = digits.indexOf(character);
    return index < 0 ? character : (index % 10).toString();
  }).join().replaceAll('٫', '.');
  if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(normalized)) return null;
  final parts = normalized.split('.');
  final rupees = int.tryParse(parts.first);
  if (rupees == null || rupees > maxExactPaise ~/ 100) return null;
  final paise = rupees * 100 + int.parse(parts.length == 1 ? '0' : parts[1].padRight(2, '0'));
  return paise > 0 && paise <= maxExactPaise ? paise : null;
}

class SpendingRepository {
  SpendingRepository(this.database, this.bills);
  final AppDatabase database;
  final BillRepository bills;

  Stream<SpendingHistory> watch({required int months, required DateTime today}) =>
    database.customSelect('SELECT 1', readsFrom: {
      database.vendors, database.entries, database.monthRates, database.settings,
      database.dailyDetails, database.rateChanges, database.vendorPauses,
      database.purchases,
    }).watch().asyncMap((_) => load(months: months, today: today));

  Future<SpendingHistory> load({required int months, required DateTime today}) =>
      database.transaction(() async {
    if (months != 6 && months != 12) throw ArgumentError('Use 6 or 12 months');
    final now = DateTime(today.year, today.month, today.day);
    final history = <AllVendorsBill>[];
    for (var offset = months - 1; offset >= 0; offset--) {
      final month = DateTime(now.year, now.month - offset);
      history.add(await bills.loadAllBills(month, now));
    }
    final settings = await database.select(database.settings).get();
    final budgets = <String, int>{};
    for (final setting in settings) {
      if (!setting.key.startsWith('v3Budget:')) continue;
      final amount = int.tryParse(setting.value);
      if (amount != null && amount > 0 && amount <= maxExactPaise) {
        budgets[setting.key] = amount;
      }
    }
    return SpendingHistory(months: List.unmodifiable(history), budgets: Map.unmodifiable(budgets));
  });

  Future<void> setBudget(DateTime month, VendorType? type, int? paise) async {
    if (paise != null && (paise <= 0 || paise > maxExactPaise)) {
      throw ArgumentError('Invalid budget');
    }
    final key = budgetKey(month, type);
    if (paise == null) {
      await (database.delete(database.settings)..where((row) => row.key.equals(key))).go();
    } else {
      await database.saveSetting(key, paise.toString());
    }
  }
}
