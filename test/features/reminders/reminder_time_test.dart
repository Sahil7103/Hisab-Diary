import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/features/reminders/reminder_time.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(tz_data.initializeTimeZones);
  test('default and valid reminder clocks are safe; malformed settings use 20:00', () {
    expect(reminderClock(null), (hour: 20, minute: 0));
    expect(reminderClock('25:80'), (hour: 20, minute: 0));
    expect(reminderClock('09:15'), (hour: 9, minute: 15));
    expect(reminderClock('23:59'), (hour: 23, minute: 59));
  });
  test('next reminder crosses a month and leap day at the requested local time', () {
    final zone = tz.getLocation('Asia/Kolkata');
    final next = nextReminder(tz.TZDateTime(zone, 2024, 2, 29, 21), 20, 0);
    expect((next.year, next.month, next.day, next.hour), (2024, 3, 1, 20));
    expect(nextReminder(tz.TZDateTime(zone, 2026, 10, 8, 19), 20, 0).day, 8);
  });
  test('daily scheduling keeps wall clock time across daylight saving', () {
    final zone = tz.getLocation('America/New_York');
    final now = tz.TZDateTime(zone, 2026, 3, 7, 20);
    final next = nextReminder(now, 20, 0);
    expect((next.day, next.hour, next.minute), (8, 20, 0));
    expect(next.difference(now).inHours, 23);
  });
}
