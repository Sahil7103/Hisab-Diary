import '../../core/storage/app_database.dart';
import '../../core/utils/date_keys.dart';
import '../today/today_repository.dart' show Attendance;

String diaryMonth(DateTime date) => diaryDate(date).substring(0, 7);
int daysInMonth(DateTime month) => DateTime(month.year, month.month + 1, 0).day;
int monthWeekdayOffset(DateTime month) => DateTime(month.year, month.month).weekday - 1;

enum DayAttendance { unmarked, came, notCame, automatic, disabled }

class MonthBill {
  const MonthBill({required this.vendor, required this.month, required this.days,
    required this.cameDays, required this.notCameDays, required this.automaticDays,
    required this.quantity, required this.rate});
  final Vendor vendor;
  final DateTime month;
  final Map<int, DayAttendance> days;
  final int cameDays;
  final int notCameDays;
  final int automaticDays;
  final double quantity;
  final double rate;
  int get totalPaise => (cameDays * quantity * rate * 100).round();
  double get total => totalPaise / 100;
}

MonthBill calculateMonthBill({required Vendor vendor, required DateTime month,
  required Map<String, Attendance> entries, required DateTime now,
  required bool countUnmarkedAsCame, MonthRate? monthRate}) {
  final first = DateTime(month.year, month.month);
  final today = DateTime(now.year, now.month, now.day);
  final days = <int, DayAttendance>{};
  int came = 0;
  int absent = 0;
  int automatic = 0;
  for (int number = 1; number <= daysInMonth(first); number++) {
    final day = DateTime(first.year, first.month, number);
    final date = diaryDate(day);
    if (day.isAfter(today)) {
      days[number] = DayAttendance.disabled;
      continue;
    }
    final entry = entries[date];
    if (entry == Attendance.came) {
      days[number] = DayAttendance.came;
      came++;
    } else if (entry == Attendance.notCame) {
      days[number] = DayAttendance.notCame;
      absent++;
    } else if (countUnmarkedAsCame && day.isBefore(today) &&
        date.compareTo(vendor.createdAt) >= 0 &&
        (vendor.scheduleDays & (1 << (day.weekday - 1))) != 0) {
      days[number] = DayAttendance.automatic;
      came++;
      automatic++;
    } else {
      days[number] = DayAttendance.unmarked;
    }
  }
  return MonthBill(vendor: vendor, month: first, days: Map.unmodifiable(days),
    cameDays: came, notCameDays: absent, automaticDays: automatic,
    quantity: monthRate?.qty ?? vendor.defaultQty,
    rate: monthRate?.rate ?? vendor.rate);
}
