import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../app/app_providers.dart';
import '../../core/utils/date_keys.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/v3_strings.dart';
import '../ledger/diary_ledger_repository.dart';
import '../vendors/vendor_type.dart';
import 'reminder_service.dart';
import 'reminder_time.dart';

final vendorReminderServiceProvider = Provider<VendorReminderService>((ref) {
  final service = VendorReminderService(ref.watch(databaseProvider),
    initializeNotifications: ref.watch(reminderServiceProvider).prepareNotifications);
  ref.onDispose(service.dispose);
  return service;
});

class VendorReminderConfig {
  const VendorReminderConfig({this.deliveryOn = false, this.deliveryTime = '09:00',
    this.paymentOn = false, this.paymentDay = 1, this.paymentTime = '18:00'});
  final bool deliveryOn;
  final String deliveryTime;
  final bool paymentOn;
  final int paymentDay;
  final String paymentTime;
  bool get enabled => deliveryOn || paymentOn;

  VendorReminderConfig copyWith({bool? deliveryOn, String? deliveryTime,
    bool? paymentOn, int? paymentDay, String? paymentTime}) => VendorReminderConfig(
      deliveryOn: deliveryOn ?? this.deliveryOn, deliveryTime: deliveryTime ?? this.deliveryTime,
      paymentOn: paymentOn ?? this.paymentOn, paymentDay: paymentDay ?? this.paymentDay,
      paymentTime: paymentTime ?? this.paymentTime);

  void validate() {
    final clock = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
    if (!clock.hasMatch(deliveryTime) || !clock.hasMatch(paymentTime) ||
        paymentDay < 1 || paymentDay > 28) {
      throw const FormatException('Invalid reminder');
    }
  }

  String encode() {
    validate();
    return jsonEncode({'deliveryOn': deliveryOn, 'deliveryTime': deliveryTime,
      'paymentOn': paymentOn, 'paymentDay': paymentDay, 'paymentTime': paymentTime});
  }

  factory VendorReminderConfig.decode(String? value) {
    if (value == null) return const VendorReminderConfig();
    final decoded = jsonDecode(value);
    if (decoded is! Map<String, dynamic> || decoded['deliveryOn'] is! bool ||
        decoded['deliveryTime'] is! String || decoded['paymentOn'] is! bool ||
        decoded['paymentDay'] is! int || decoded['paymentTime'] is! String) {
      throw const FormatException('Invalid reminder');
    }
    final config = VendorReminderConfig(deliveryOn: decoded['deliveryOn'] as bool,
      deliveryTime: decoded['deliveryTime'] as String, paymentOn: decoded['paymentOn'] as bool,
      paymentDay: decoded['paymentDay'] as int, paymentTime: decoded['paymentTime'] as String);
    config.validate();
    return config;
  }
}

tz.TZDateTime nextVendorPayment(tz.TZDateTime now, int day, int hour, int minute) {
  if (day < 1 || day > 28 || hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    throw ArgumentError('Invalid payment reminder date');
  }
  var next = tz.TZDateTime(now.location, now.year, now.month, day, hour, minute);
  if (!next.isAfter(now)) {
    next = tz.TZDateTime(now.location, now.year, now.month + 1, day, hour, minute);
  }
  return next;
}

List<tz.TZDateTime> vendorDeliveryDates(tz.TZDateTime now, int scheduleDays,
    int hour, int minute, {Set<String> skipped = const {}, String? createdAt}) {
  if (scheduleDays < 1 || scheduleDays > 127 || hour < 0 || hour > 23 ||
      minute < 0 || minute > 59) {
    throw ArgumentError('Invalid delivery reminder');
  }
  final dates = <tz.TZDateTime>[];
  for (var offset = 0; offset < 31; offset++) {
    final date = tz.TZDateTime(now.location, now.year, now.month, now.day + offset, hour, minute);
    final key = diaryDate(date);
    if (date.isAfter(now) && (scheduleDays & (1 << (date.weekday - 1))) != 0 &&
        !skipped.contains(key) && (createdAt == null || key.compareTo(createdAt) >= 0)) {
      dates.add(date);
    }
  }
  return dates;
}

class _VendorNotification {
  const _VendorNotification(this.time, this.title, this.body, {this.repeat});
  final tz.TZDateTime time;
  final String title;
  final String body;
  final DateTimeComponents? repeat;
}

class VendorReminderService extends ChangeNotifier with WidgetsBindingObserver {
  VendorReminderService(this.database, {required this.initializeNotifications, this.cancelOnDispose = true});
  final AppDatabase database;
  final Future<void> Function() initializeNotifications;
  final bool cancelOnDispose;
  final _notifications = FlutterLocalNotificationsPlugin();
  // One queue prevents a departing household's cancellation from erasing the next one's reminders.
  static Future<void> _serial = Future<void>.value();
  static const _firstId = 100000;
  static const _lastId = 199999;
  StreamSubscription<dynamic>? _subscription;
  bool _disposed = false;
  bool problem = false;
  bool permissionDenied = false;
  bool get supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  AndroidFlutterLocalNotificationsPlugin? get _android => _notifications
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  Future<void> _enqueue(Future<void> Function() action) {
    final result = _serial.then((_) => action());
    _serial = result.catchError((Object _) {});
    return result;
  }

  void start() {
    if (!supported || _subscription != null || _disposed) return;
    WidgetsBinding.instance.addObserver(this);
    _subscription = database.customSelect('SELECT 1', readsFrom: {
      database.vendors, database.entries, database.monthRates, database.settings,
      database.payments, database.dailyDetails, database.rateChanges,
      database.vendorPauses, database.purchases, database.ledgerPayments,
    }).watch().listen((_) => unawaited(refresh().catchError((Object _) {})),
      onError: (Object _) => _setProblem());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(refresh().catchError((Object _) {}));
  }

  void _setProblem({bool denied = false}) {
    problem = true;
    permissionDenied = denied;
    if (!_disposed) notifyListeners();
  }

  Future<VendorReminderConfig> loadConfig(int vendorId) async {
    final setting = await (database.select(database.settings)
      ..where((row) => row.key.equals('v3Reminder:$vendorId'))).getSingleOrNull();
    return VendorReminderConfig.decode(setting?.value);
  }

  Future<void> saveConfig(int vendorId, VendorReminderConfig config) => _enqueue(() async {
    if (_disposed || !supported) throw ReminderPermissionException();
    config.validate();
    try {
      await initializeNotifications();
      final previous = await loadConfig(vendorId);
      final newlyEnabled = (config.deliveryOn && !previous.deliveryOn) ||
        (config.paymentOn && !previous.paymentOn);
      if (newlyEnabled && await _android?.areNotificationsEnabled() != true &&
          await _android?.requestNotificationsPermission() != true) {
        _setProblem(denied: true);
        throw ReminderPermissionException();
      }
      final vendor = await (database.select(database.vendors)
        ..where((row) => row.id.equals(vendorId))).getSingle();
      if (vendor.archived && config.enabled) throw StateError('Vendor archived');
      await database.saveSetting('v3Reminder:$vendorId', config.encode());
      await _sync();
      if (config.enabled && problem) {
        if (permissionDenied) throw ReminderPermissionException();
        throw StateError('Reminder scheduling failed');
      }
    } catch (error) {
      _setProblem(denied: error is ReminderPermissionException);
      rethrow;
    }
  });

  Future<void> refresh() => _enqueue(() async {
    if (_disposed || !supported) return;
    try {
      await initializeNotifications();
      await _sync();
    } catch (_) {
      _setProblem();
      rethrow;
    }
  });

  Future<void> _cancelOwned() async {
    final pending = await _notifications.pendingNotificationRequests();
    final active = await _notifications.getActiveNotifications();
    final ids = <int>{...pending.map((request) => request.id),
      ...active.map((notification) => notification.id).whereType<int>()};
    for (final id in ids) {
      if (id >= _firstId && id <= _lastId) await _notifications.cancel(id: id);
    }
  }

  Future<void> _sync() async {
    if (_disposed) return;
    final rows = await database.select(database.settings).get();
    final settings = {for (final row in rows) row.key: row.value};
    final vendors = await (database.select(database.vendors)
      ..where((row) => row.archived.equals(false))).get();
    final enabled = <int, VendorReminderConfig>{};
    for (final vendor in vendors) {
      final config = VendorReminderConfig.decode(settings['v3Reminder:${vendor.id}']);
      if (config.enabled) enabled[vendor.id] = config;
    }
    if (_disposed) return;
    if (enabled.isEmpty) {
      await _cancelOwned();
      problem = false;
      permissionDenied = false;
      if (!_disposed) notifyListeners();
      return;
    }
    if (await _android?.areNotificationsEnabled() != true) {
      await _cancelOwned();
      _setProblem(denied: true);
      return;
    }
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    final now = tz.TZDateTime.now(tz.local);
    final strings = await AppLocalizations.delegate.load(Locale(settings['language'] ?? 'hi'));
    String text(String key) => v3String(strings.localeName, key);
    var private = true;
    try {
      private = await HomeWidget.getWidgetData<bool>('app_lock_enabled', defaultValue: true) ?? true;
    } catch (_) {
      // A failed device preference read must not reveal household details.
      private = true;
    }
    final entries = await database.select(database.entries).get();
    final pauses = await database.select(database.vendorPauses).get();
    final plan = <_VendorNotification>[];
    for (final vendor in vendors) {
      final config = enabled[vendor.id];
      if (config == null) continue;
      final name = vendor.name.trim().isEmpty ? vendorTypeLabel(strings, vendor.type) : vendor.name;
      final title = private ? strings.appName : name;
      if (config.deliveryOn && settings['v3PurchasesOnly:${vendor.id}'] != 'true') {
        final skipped = {for (final entry in entries.where((entry) => entry.vendorId == vendor.id)) entry.date};
        for (var offset = 0; offset < 31; offset++) {
          final key = diaryDate(DateTime(now.year, now.month, now.day + offset));
          if (pauses.any((pause) => pause.vendorId == vendor.id &&
              key.compareTo(pause.startDate) >= 0 && key.compareTo(pause.endDate) <= 0)) {
            skipped.add(key);
          }
        }
        final clock = reminderClock(config.deliveryTime);
        // shortcut: schedules 31 days ahead; opening the diary refreshes the window.
        for (final time in vendorDeliveryDates(now, vendor.scheduleDays, clock.hour, clock.minute,
            skipped: skipped, createdAt: vendor.createdAt)) {
          plan.add(_VendorNotification(time, title,
            text(private ? 'reminderPrivate' : 'deliveryReminderBody')));
        }
      }
      if (config.paymentOn) {
        final balance = await DiaryLedgerRepository(database).balanceForMonth(vendor.id,
          DateTime(now.year, now.month));
        final clock = reminderClock(config.paymentTime);
        final amount = NumberFormat.currency(locale: strings.localeName, symbol: '₹',
          decimalDigits: balance.duePaise % 100 == 0 ? 0 : 2).format(balance.duePaise / 100);
        final body = private ? text('reminderPrivate') :
          '${text('paymentReminderBody')}\n${text('reminderSnapshot')}: $amount (${DateFormat.yMd(strings.localeName).format(now)}).';
        plan.add(_VendorNotification(nextVendorPayment(now, config.paymentDay, clock.hour, clock.minute),
          title, body, repeat: DateTimeComponents.dayOfMonthAndTime));
      }
    }
    if (_disposed) return;
    if (plan.length > _lastId - _firstId + 1) throw StateError('Too many reminders');
    await _cancelOwned();
    final details = NotificationDetails(android: AndroidNotificationDetails(
      'vendor_diary', text('vendorReminders'), importance: Importance.defaultImportance,
      priority: Priority.defaultPriority, icon: 'ic_notification',
      visibility: NotificationVisibility.private));
    for (var index = 0; index < plan.length; index++) {
      if (_disposed) return;
      final notification = plan[index];
      await _notifications.zonedSchedule(id: _firstId + index,
        title: notification.title, body: notification.body, scheduledDate: notification.time,
        notificationDetails: details, androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: notification.repeat, payload: 'vendor_reminder');
    }
    problem = false;
    permissionDenied = false;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    if (supported && cancelOnDispose) {
      unawaited(_enqueue(_cancelOwned).catchError((Object _) {
        debugPrint('Vendor reminders could not be cleared.');
      }));
    }
    super.dispose();
  }
}



