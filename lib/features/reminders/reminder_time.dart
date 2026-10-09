import 'package:timezone/timezone.dart' as tz;

({int hour, int minute}) reminderClock(String? value) {
  final match = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').firstMatch(value ?? '');
  return match == null ? (hour: 20, minute: 0)
    : (hour: int.parse(match[1]!), minute: int.parse(match[2]!));
}

tz.TZDateTime nextReminder(tz.TZDateTime now, int hour, int minute) {
  var next = tz.TZDateTime(now.location, now.year, now.month, now.day, hour, minute);
  if (!next.isAfter(now)) {
    // Construct the next local calendar day, rather than adding 24 hours
    // across a daylight-saving boundary.
    next = tz.TZDateTime(now.location, now.year, now.month, now.day + 1, hour, minute);
  }
  return next;
}
