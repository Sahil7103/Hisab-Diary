import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/month/month_bill.dart';
import 'package:hisab_diary/features/today/today_repository.dart';

void main() {
  Vendor vendor({int schedule = 127, String created = '2026-10-01',
      bool archived = false}) => Vendor(id: 1, type: 'milk', name: '', unit: 'litre',
    defaultQty: 1, rate: 60, scheduleDays: schedule, archived: archived, createdAt: created);
  MonthBill calculate({Vendor? source, Map<String, Attendance> entries = const {},
    bool automatic = true, DateTime? month, DateTime? now, MonthRate? rate}) =>
      calculateMonthBill(vendor: source ?? vendor(), month: month ?? DateTime(2026, 10),
        now: now ?? DateTime(2026, 10, 8, 23), entries: entries,
        countUnmarkedAsCame: automatic, monthRate: rate);

  test('month lengths handle leap years, century rules and year boundaries', () {
    expect(daysInMonth(DateTime(2024, 2)), 29);
    expect(daysInMonth(DateTime(2026, 2)), 28);
    expect(daysInMonth(DateTime(1900, 2)), 28);
    expect(daysInMonth(DateTime(2000, 2)), 29);
    expect(daysInMonth(DateTime(2026, 4)), 30);
    expect(daysInMonth(DateTime(2026, 13)), 31);
    expect(diaryMonth(DateTime(2026, 13)), '2027-01');
  });
  test('calendar offset starts on Monday and preserves Sunday leading blanks', () {
    expect(monthWeekdayOffset(DateTime(2026, 10)), 3);
    expect(monthWeekdayOffset(DateTime(2021, 2)), 0);
    expect(monthWeekdayOffset(DateTime(2020, 3)), 6);
  });
  test('automatic came includes only past days; explicit absence and today win', () {
    final bill = calculate(entries: {'2026-10-04': Attendance.notCame,
      '2026-10-08': Attendance.came, '2026-10-09': Attendance.came});
    expect(bill.cameDays, 7);
    expect(bill.notCameDays, 1);
    expect(bill.automaticDays, 6);
    expect(bill.total, 420);
    expect(bill.days[8], DayAttendance.came);
    expect(bill.days[9], DayAttendance.disabled);
    expect(calculate().days[8], DayAttendance.unmarked);
  });
  test('turning automatic counting off leaves only explicit came days', () {
    final bill = calculate(automatic: false, entries: {
      '2026-10-02': Attendance.came, '2026-10-03': Attendance.notCame});
    expect(bill.cameDays, 1);
    expect(bill.notCameDays, 1);
    expect(bill.automaticDays, 0);
    expect(bill.totalPaise, 6000);
    expect(bill.days[1], DayAttendance.unmarked);
  });
  test('weekday masks restrict automatic came but permit explicit off-schedule came', () {
    final bill = calculate(source: vendor(schedule: 1), now: DateTime(2026, 10, 20),
      entries: {'2026-10-04': Attendance.came, '2026-10-06': Attendance.notCame});
    expect(bill.cameDays, 4);
    expect(bill.automaticDays, 3);
    expect(bill.notCameDays, 1);
    expect(bill.days[5], DayAttendance.automatic);
    expect(bill.days[20], DayAttendance.unmarked);
  });
  test('explicit past entries count before creation; future months remain excluded', () {
    final bill = calculate(source: vendor(created: '2026-10-05', archived: true),
      entries: {'2026-10-02': Attendance.came});
    expect(bill.cameDays, 4);
    expect(bill.days[2], DayAttendance.came);
    expect(bill.days[1], DayAttendance.unmarked);
    expect(calculate(month: DateTime(2026, 9)).cameDays, 0);
    expect(calculate(month: DateTime(2026, 11)).total, 0);
  });
  test('month snapshot quantity and rate override current defaults with paise rounding', () {
    final bill = calculate(automatic: false, entries: {
      '2026-10-01': Attendance.came, '2026-10-02': Attendance.came},
      rate: const MonthRate(vendorId: 1, month: '2026-10', rate: 62.5, qty: 0.5));
    expect(bill.quantity, 0.5);
    expect(bill.rate, 62.5);
    expect(bill.totalPaise, 6250);
    final pennies = calculate(automatic: false, entries: {
      '2026-10-01': Attendance.came, '2026-10-02': Attendance.came,
      '2026-10-03': Attendance.came},
      rate: const MonthRate(vendorId: 1, month: '2026-10', rate: 0.1, qty: 1.5));
    expect(pennies.totalPaise, 45);
    expect(pennies.total, 0.45);
  });
}
