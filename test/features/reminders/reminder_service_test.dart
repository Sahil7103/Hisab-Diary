import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/reminders/reminder_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  const timezone = MethodChannel('flutter_timezone');
  late AppDatabase db;
  late ReminderService service;
  final calls = <MethodCall>[];
  bool allowed = true;
  bool failInitialization = false;
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    calls.clear(); allowed = true; failInitialization = false;
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = ReminderService(db);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        if (call.method == 'initialize' && failInitialization) {
          throw PlatformException(code: 'initialization_failed');
        }
        return switch (call.method) {
          'initialize' => true,
          'getNotificationAppLaunchDetails' => {'notificationLaunchedApp': false},
          'areNotificationsEnabled' || 'requestNotificationsPermission' => allowed,
          'canScheduleExactNotifications' || 'requestExactAlarmsPermission' => false,
          _ => null,
        };
      });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(timezone, (_) async => 'Asia/Kolkata');
  });
  tearDown(() async {
    service.dispose(); await db.close();
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(timezone, null);
  });

  test('startup and restore never prompt; explicit enabling requests permission and schedules actions', () async {
    await service.sync({'reminderOn': 'false'});
    await service.sync({'reminderOn': 'true', 'language': 'hi', 'reminderTime': '20:15'});
    expect(calls.any((call) => call.method.startsWith('request')), false);
    final schedule = calls.lastWhere((call) => call.method == 'zonedSchedule').arguments as Map;
    expect(schedule['body'], 'आज सब आया?');
    final actions = (schedule['platformSpecifics'] as Map)['actions'] as List;
    expect(actions.map((action) => (action as Map)['title']), ['हाँ, सब आया', 'देखिए']);
    expect(service.approximate, true);
    await service.setEnabled(true);
    expect(calls.any((call) => call.method == 'requestNotificationsPermission'), false);
    expect(calls.any((call) => call.method == 'requestExactAlarmsPermission'), true);
    expect((await db.select(db.settings).getSingle()).value, 'true');
  });

  test('enable then change time and test uses latest settings without waiting for stream', () async {
    await service.setEnabled(true);
    await service.setTime(const TimeOfDay(hour: 18, minute: 30));
    final schedule = calls.lastWhere((call) => call.method == 'zonedSchedule').arguments as Map;
    expect(schedule['scheduledDateTime'], contains('18:30'));
    await service.testReminder();
    expect(calls.any((call) => call.method == 'show'), true);
    await service.setEnabled(false);
    await expectLater(service.testReminder(), throwsA(isA<ReminderPermissionException>()));
  });
  test('device timezone alias Asia/Calcutta schedules successfully', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(timezone, (_) async => 'Asia/Calcutta');
    await service.setEnabled(true);
    final schedule = calls.lastWhere((call) => call.method == 'zonedSchedule').arguments as Map;
    expect(schedule['timeZoneName'], 'Asia/Calcutta');
    expect((await db.select(db.settings).getSingle()).value, 'true');
  });

  test('initialization failure can be retried', () async {
    failInitialization = true;
    await expectLater(service.setEnabled(true), throwsA(isA<PlatformException>()));
    failInitialization = false;
    await service.setEnabled(true);
    expect(calls.where((call) => call.method == 'initialize'), hasLength(2));
    expect(calls.any((call) => call.method == 'zonedSchedule'), true);
  });

  test('denied notification permission does not enable reminders or request an alarm', () async {
    allowed = false;
    await expectLater(service.setEnabled(true), throwsA(isA<ReminderPermissionException>()));
    expect(calls.any((call) => call.method == 'requestExactAlarmsPermission'), false);
    expect(calls.any((call) => call.method == 'zonedSchedule'), false);
    expect(await db.select(db.settings).get(), isEmpty);
  });
}

