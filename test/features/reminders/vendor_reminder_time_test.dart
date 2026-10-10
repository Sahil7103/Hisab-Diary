import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_diary/features/reminders/vendor_reminder_service.dart';
import 'package:timezone/data/latest.dart' as data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(data.initializeTimeZones);
  test('monthly reminder crosses a year and accepts only days available every month', () {
    final zone = tz.getLocation('Asia/Kolkata');
    final next = nextVendorPayment(tz.TZDateTime(zone, 2026, 12, 28, 18), 28, 18, 0);
    expect((next.year, next.month, next.day, next.hour), (2027, 1, 28, 18));
    expect(() => nextVendorPayment(next, 29, 18, 0), throwsArgumentError);
  });
  test('delivery dates obey weekdays, skipped attendance and local clocks across DST', () {
    final zone = tz.getLocation('America/New_York');
    final dates = vendorDeliveryDates(tz.TZDateTime(zone, 2026, 3, 7, 12), 1 << 6, 9, 0,
      skipped: {'2026-03-08'}, createdAt: '2026-03-01');
    expect(dates.first.day, 15);
    expect(dates.every((date) => date.weekday == DateTime.sunday && date.hour == 9), isTrue);
    final daily = vendorDeliveryDates(tz.TZDateTime(zone, 2026, 3, 7, 9), 127, 9, 0);
    expect(daily.first.day, 8);
    expect(daily.first.difference(tz.TZDateTime(zone, 2026, 3, 7, 9)).inHours, 23);
  });
  test('new config is off and malformed backup settings cannot silently schedule', () {
    expect(VendorReminderConfig.decode(null).enabled, isFalse);
    final config = VendorReminderConfig(deliveryOn: true, paymentOn: true,
      paymentDay: 28, deliveryTime: '23:59');
    expect(VendorReminderConfig.decode(config.encode()).paymentDay, 28);
    expect(() => VendorReminderConfig.decode('{"deliveryOn":true}'), throwsFormatException);
    expect(() => const VendorReminderConfig(paymentDay: 31).encode(), throwsFormatException);
  });
}
