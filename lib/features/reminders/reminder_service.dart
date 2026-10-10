import '../../core/constants/app_languages.dart';
import '../../core/services/app_telemetry.dart';
import '../../core/services/diary_usage_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../../app/app_providers.dart';
import '../../app/diary_navigation.dart';
import '../../core/storage/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../today/today_repository.dart';
import 'reminder_time.dart';
import 'package:home_widget/home_widget.dart';
import '../households/household_controller.dart';
import '../device/app_lock_controller.dart';

const _dailyId = 610;
const _testId = 611;
const _allCameAction = 'all_came';
const _reminderChannel = MethodChannel('hisab_diary/reminders');

final reminderServiceProvider = Provider<ReminderService>((ref) {
  final service = ReminderService(ref.watch(databaseProvider),
    dbName: ref.watch(householdControllerProvider).selected.databaseName);
  ref.onDispose(service.dispose);
  return service;
});

class ReminderPermissionException implements Exception {}

@pragma('vm:entry-point')
void reminderBackgroundAction(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  if (response.actionId != _allCameAction) return;
  if (await _notificationPrivate()) return;
  final name = await HomeWidget.getWidgetData<String>('active_diary_db') ?? 'hisab_diary';
  if (!_validDiaryName(name)) return;
  if (response.payload != null && response.payload != name) return;
  final database = AppDatabase(name: name);
  try {
    try {
      await Firebase.initializeApp();
      await AppTelemetry.initialize();
    } catch (error) {
      debugPrint('Reminder monitoring unavailable (${error.runtimeType}).');
    }
    await TodayRepository(database).markAllCame(DateTime.now(),
      source: DeliverySource.reminder);
  } catch (_) {
    // Report a failed background write when the diary is next opened.
    try {
      await database.saveSetting('reminderActionError', 'true');
    } catch (_) {
      debugPrint('Hisab Diary could not save a reminder action.');
    }
  } finally {
    await database.close();
  }
}

// A native TIMEZONE_CHANGED receiver starts this short-lived engine, including
// when the UI process is closed. Boot rescheduling uses the plugin's receiver.
Future<void> rescheduleAfterTimezoneChange() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final name = await HomeWidget.getWidgetData<String>('active_diary_db') ?? 'hisab_diary';
  if (!_validDiaryName(name)) return;
  final database = AppDatabase(name: name);
  final service = ReminderService(database, dbName: name);
  try {
    final rows = await database.select(database.settings).get();
    await service.sync({for (final row in rows) row.key: row.value});
  } catch (_) {
    debugPrint('Hisab Diary could not reschedule its reminder.');
  } finally {
    service.dispose();
    await database.close();
    await _reminderChannel.invokeMethod<void>('finished');
  }
}

class ReminderService extends ChangeNotifier with WidgetsBindingObserver {
  ReminderService(this.database, {this.dbName = 'hisab_diary'});
  final String dbName;
  final AppDatabase database;
  final _notifications = FlutterLocalNotificationsPlugin();
  StreamSubscription<Map<String, String>>? _settingsSubscription;
  Future<void>? _initialization;
  static Future<void> _work = Future<void>.value();
  Map<String, String> _settings = const {};
  String? _signature;
  bool _disposed = false;
  bool approximate = false;
  bool problem = false;
  bool get supported => defaultTargetPlatform == TargetPlatform.android;
  AndroidFlutterLocalNotificationsPlugin? get _android => _notifications
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  Future<void> prepareNotifications() => _initialize();
  void refresh() => _queueSync(_settings, force: true);

  Future<void> _initialize() async {
    try {
      await (_initialization ??= _initializePlugin());
    } catch (_) {
      _initialization = null;
      rethrow;
    }
  }
  Future<void> _initializePlugin() async {
    if (!supported) return;
    tz_data.initializeTimeZones();
    await _notifications.initialize(settings: const InitializationSettings(
      android: AndroidInitializationSettings('ic_notification')),
      onDidReceiveNotificationResponse: (response) => unawaited(_foregroundAction(response)),
      onDidReceiveBackgroundNotificationResponse: reminderBackgroundAction);
    final launch = await _notifications.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true && launch?.notificationResponse != null) {
      await _foregroundAction(launch!.notificationResponse!);
    }
  }

  Future<void> _foregroundAction(NotificationResponse response) async {
    if (response.actionId == _allCameAction && !await _notificationPrivate() &&
        (response.payload == null || response.payload == dbName) && !_disposed) {
      try {
        await TodayRepository(database).markAllCame(DateTime.now(),
          source: DeliverySource.reminder);
      } catch (_) {
        try {
          await database.saveSetting('reminderActionError', 'true');
        } catch (_) {
          debugPrint('Hisab Diary could not save a reminder action.');
        }
        problem = true;
        if (!_disposed) notifyListeners();
      }
    }
    openToday();
  }

  void start() {
    if (!supported || _settingsSubscription != null) return;
    WidgetsBinding.instance.addObserver(this);
    _settingsSubscription = database.watchSettings().listen((values) {
      _settings = values;
      _queueSync(values);
    }, onError: (Object _) {
      problem = true;
      if (!_disposed) notifyListeners();
    });
  }

  void _queueSync(Map<String, String> values, {bool force = false}) {
    final signature = '${values['reminderOn']}|${values['reminderTime']}|${values['language']}';
    if (!force && signature == _signature) return;
    _signature = signature;
    _work = _work.then((_) => sync(values)).catchError((Object error, StackTrace stack) {
      AppTelemetry.report(error, stack, operation: 'reminder_schedule');
      _signature = null;
      problem = true;
      if (!_disposed) notifyListeners();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _queueSync(_settings, force: true);
  }

  Future<AppLocalizations> _strings(Map<String, String> values) =>
    AppLocalizations.delegate.load(Locale(
      supportedLanguageCodes.contains(values['language']) ? values['language']! : 'hi'));

  NotificationDetails _details(AppLocalizations strings, {required int expiresAfter, bool private = false}) =>
    NotificationDetails(android: AndroidNotificationDetails(
      'daily_diary', strings.eveningReminder, importance: Importance.high,
      priority: Priority.high, icon: 'ic_notification', timeoutAfter: expiresAfter,
      actions: [
        if (!private) AndroidNotificationAction(_allCameAction, strings.reminderAllCame,
          cancelNotification: true),
        AndroidNotificationAction('view_today', strings.reminderView,
          showsUserInterface: true, cancelNotification: true),
      ]));

  // This method never requests permission: restore, startup, reboot and timezone
  // changes may reschedule only with permissions the user already granted.
  Future<void> sync(Map<String, String> values) async {
    if (!supported || _disposed) return;
    await _initialize();
    if (_disposed) return;
    if (values['reminderOn'] != 'true') {
      await _notifications.cancel(id: _dailyId);
      await _notifications.cancel(id: _testId);
      problem = false;
      if (!_disposed) notifyListeners();
      return;
    }
    if (await _android?.areNotificationsEnabled() != true) {
      await _notifications.cancel(id: _dailyId);
      problem = true;
      if (!_disposed) notifyListeners();
      return;
    }
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    final clock = reminderClock(values['reminderTime']);
    final strings = await _strings(values);
    approximate = await _android?.canScheduleExactNotifications() != true;
    final private = await _notificationPrivate();
    if (_disposed) return;
    await _notifications.zonedSchedule(id: _dailyId, title: strings.appName,
      body: strings.reminderQuestion, payload: dbName,
      scheduledDate: nextReminder(tz.TZDateTime.now(tz.local), clock.hour, clock.minute),
      notificationDetails: _details(strings, private: private,
        expiresAfter: ((24 * 60) - clock.hour * 60 - clock.minute) * 60000),
      androidScheduleMode: approximate ? AndroidScheduleMode.inexactAllowWhileIdle
        : AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time);
    problem = false;
    if (!_disposed) notifyListeners();
  }

  Future<void> setEnabled(bool enabled) async {
    if (!supported) throw ReminderPermissionException();
    await _initialize();
    if (enabled) {
      if (await _android?.areNotificationsEnabled() != true &&
          await _android?.requestNotificationsPermission() != true) {
        throw ReminderPermissionException();
      }
      // Denial still permits a less precise reminder; explain it in Settings.
      if (await _android?.canScheduleExactNotifications() != true) {
        await _android?.requestExactAlarmsPermission();
      }
    }
    await _work;
    final values = {..._settings, 'reminderOn': enabled.toString()};
    await sync(values);
    if (enabled && problem) throw ReminderPermissionException();
    try {
      await database.saveSetting('reminderOn', enabled.toString());
      _settings = values;
    } catch (_) {
      await sync(_settings);
      rethrow;
    }
  }

  Future<void> setTime(TimeOfDay time) async {
    final value = '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';
    await _work;
    final values = {..._settings, 'reminderTime': value};
    await sync(values);
    try {
      await database.saveSetting('reminderTime', value);
      _settings = values;
    } catch (_) {
      await sync(_settings);
      rethrow;
    }
  }

  Future<void> testReminder() async {
    await _initialize();
    await _work;
    if (_settings['reminderOn'] != 'true' ||
        await _android?.areNotificationsEnabled() != true) {
      throw ReminderPermissionException();
    }
    await _initialize();
    final strings = await _strings(_settings);
    final private = await _notificationPrivate();
    await _notifications.show(id: _testId, title: strings.appName, payload: dbName,
      body: strings.reminderQuestion,
      notificationDetails: _details(strings, private: private, expiresAfter: 5 * 60000));
  }

  Future<void> openBatterySettings() => _reminderChannel.invokeMethod<void>('batterySettings');

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_settingsSubscription?.cancel());
    super.dispose();
  }
}

bool _validDiaryName(String name) => RegExp(r'^hisab_diary(?:_household_[a-z0-9]+)?$').hasMatch(name);
Future<bool> _notificationPrivate() async {
  if (!supportsDeviceFeatures) return false;
  try {
    return await HomeWidget.getWidgetData<bool>(appLockEnabledKey, defaultValue: true) ?? true;
  } catch (_) { return true; }
}
