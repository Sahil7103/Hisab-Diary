import '../../core/storage/app_database.dart';
import '../../core/utils/date_keys.dart';
import '../today/today_repository.dart' show Attendance;

String diaryMonth(DateTime date) => diaryDate(date).substring(0, 7);
int daysInMonth(DateTime month) => DateTime(month.year, month.month + 1, 0).day;
int monthWeekdayOffset(DateTime month) => DateTime(month.year, month.month).weekday - 1;

enum DayAttendance { unmarked, came, notCame, automatic, disabled, paused }

class MonthBill {
  const MonthBill({required this.vendor, required this.month, required this.days,
    required this.cameDays, required this.notCameDays, required this.automaticDays,
    required this.quantity, required this.rate, this.calculatedTotalPaise,
    this.deliveries = const [], this.purchases = const [], this.itemizedOnly = false});
  final Vendor vendor;
  final DateTime month;
  final Map<int, DayAttendance> days;
  final int cameDays;
  final int notCameDays;
  final int automaticDays;
  final double quantity;
  final double rate;
  final int? calculatedTotalPaise;
  final List<DeliveryCharge> deliveries;
  final List<Purchase> purchases;
  final bool itemizedOnly;
  bool get hasVariableCharges => itemizedOnly || purchases.isNotEmpty ||
    deliveries.any((day) => day.quantity != quantity || day.rate != rate);
  int get totalPaise => calculatedTotalPaise ?? (cameDays * quantity * rate * 100).round();
  double get total => totalPaise / 100;
}

MonthBill calculateMonthBill({required Vendor vendor, required DateTime month,
  required Map<String, Attendance> entries, required DateTime now,
  required bool countUnmarkedAsCame, MonthRate? monthRate,
  List<DailyDetail> dailyDetails = const [], List<RateChange> rateChanges = const [],
  List<VendorPause> pauses = const [], List<Purchase> purchases = const [],
  bool itemizedOnly = false, Map<String,bool> purchaseModes = const {}}) {
  final first = DateTime(month.year, month.month);
  final today = DateTime(now.year, now.month, now.day);
  final days = <int, DayAttendance>{};
  final details = {for (final row in dailyDetails) row.date: row};
  final changes = [...rateChanges]..sort((a,b) => a.effectiveDate.compareTo(b.effectiveDate));
  final deliveries = <DeliveryCharge>[];
  final baselineDate = monthRate == null ? vendor.createdAt : '${monthRate.month}-01';
  var deliveryTotal = 0.0;
  int came = 0;
  int absent = 0;
  int automatic = 0;
  for (int number = 1; number <= daysInMonth(first); number++) {
    final day = DateTime(first.year, first.month, number);
    final date = diaryDate(day);
    var purchasesOnly = itemizedOnly;
    if(purchaseModes.isNotEmpty) {
      purchasesOnly=false;
      for(final key in purchaseModes.keys.toList()..sort()) {
        if(key.compareTo(date)>0) break;
        purchasesOnly=purchaseModes[key]!;
      }
    }
    if (day.isAfter(today) || purchasesOnly) {
      days[number] = DayAttendance.disabled;
      continue;
    }
    final entry = entries[date];
    final paused = pauses.any((row) => row.startDate.compareTo(date) <= 0 &&
      row.endDate.compareTo(date) >= 0);
    if (entry == Attendance.came) {
      days[number] = DayAttendance.came;
      came++;
    } else if (entry == Attendance.notCame) {
      days[number] = DayAttendance.notCame;
      absent++;
    } else if (paused) {
      days[number] = DayAttendance.paused;
    } else if (countUnmarkedAsCame && day.isBefore(today) &&
        date.compareTo(vendor.createdAt) >= 0 &&
        (vendor.scheduleDays & (1 << (day.weekday - 1))) != 0) {
      days[number] = DayAttendance.automatic;
      came++;
      automatic++;
    } else {
      days[number] = DayAttendance.unmarked;
    }
    if (days[number] == DayAttendance.came || days[number] == DayAttendance.automatic) {
      var quantity = monthRate?.qty ?? vendor.defaultQty;
      var rate = monthRate?.rate ?? vendor.rate;
      for (final change in changes) {
        if (change.effectiveDate.compareTo(date) > 0) break;
        if (change.effectiveDate.compareTo(baselineDate) >= 0) {
          quantity = change.quantity;
          rate = change.rate;
        }
      }
      quantity = details[date]?.quantity ?? quantity;
      final previousTotal = deliveryTotal.round();
      deliveryTotal += quantity * rate * 100;
      deliveries.add(DeliveryCharge(date: date, quantity: quantity, rate: rate,
        calculatedTotalPaise: deliveryTotal.round() - previousTotal,
        note: details[date]?.note ?? '', automatic: days[number] == DayAttendance.automatic));
    }
  }
  final validPurchases = purchases.where((row) => row.date.compareTo(diaryDate(first)) >= 0 &&
    row.date.compareTo(diaryDate(DateTime(first.year, first.month + 1))) < 0 &&
    row.date.compareTo(vendor.createdAt) >= 0 && row.date.compareTo(diaryDate(today)) <= 0).toList();
  final total = deliveryTotal.round() + validPurchases.fold<int>(0,
    (amount, row) => amount + (row.quantity * row.unitPricePaise).round());
  return MonthBill(vendor: vendor, month: first, days: Map.unmodifiable(days),
    cameDays: came, notCameDays: absent, automaticDays: automatic,
    quantity: monthRate?.qty ?? vendor.defaultQty,
    rate: monthRate?.rate ?? vendor.rate, calculatedTotalPaise: total,
    deliveries: List.unmodifiable(deliveries), purchases: List.unmodifiable(validPurchases),
    itemizedOnly: itemizedOnly);
}

class DeliveryCharge {
  const DeliveryCharge({required this.date, required this.quantity, required this.rate,
    this.note = '', this.automatic = false, this.calculatedTotalPaise});
  final String date;
  final double quantity;
  final double rate;
  final String note;
  final bool automatic;
  final int? calculatedTotalPaise;
  int get totalPaise => calculatedTotalPaise ?? (quantity * rate * 100).round();
}
