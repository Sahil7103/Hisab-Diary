import 'dart:async';
import 'dart:convert';
import 'dart:ui' show DartPluginRegistrant;
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../../core/storage/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/v3_strings.dart';
import '../today/today_repository.dart';
import '../vendors/vendor_type.dart';
import 'app_lock_controller.dart';

const diaryWidgetSnapshotKey = 'diary_widget_snapshot';
const activeDiaryDbKey = 'active_diary_db';
const activeHouseholdIdKey = 'active_household_id';
const activeHouseholdNameKey = 'active_household_name';
final _diaryNamePattern = RegExp(r'^hisab_diary(?:_household_[a-z0-9]+)?$');

Future<void> initializeDeviceFeatures() async {
  if (!supportsDeviceFeatures) return;
  try {
    await HomeWidget.registerInteractivityCallback(diaryWidgetBackgroundCallback);
  } catch (error) {
    debugPrint('Diary widget initialization failed (${error.runtimeType}).');
  }
  await AppLockController.instance.initialize();
}

bool validDiaryWidgetAction(Uri? action, Map<String, dynamic>? snapshot, {
  required bool locked, required String? dbName, required String? householdId,
  required String? householdName, required DateTime now,
}) {
  if (locked || action == null || action.scheme != 'hisabdiary' ||
      action.host != 'widget' || dbName == null || !_diaryNamePattern.hasMatch(dbName) ||
      householdId == null || householdId.isEmpty || householdName == null || householdName.isEmpty ||
      action.queryParameters['dbName'] != dbName ||
      action.queryParameters['householdId'] != householdId ||
      action.queryParameters['householdName'] != householdName ||
      action.queryParameters['date'] != diaryDate(now)) { return false; }
  final kind = action.queryParameters['action'];
  if (kind == 'refresh') return true;
  if (!['came', 'absent', 'allCame'].contains(kind) || snapshot == null ||
      snapshot['dbName'] != dbName || snapshot['householdId'] != householdId ||
      snapshot['householdName'] != householdName || snapshot['date'] != diaryDate(now) ||
      snapshot['token'] is! String || (snapshot['token'] as String).isEmpty ||
      snapshot['token'] != action.queryParameters['token']) { return false; }
  if (kind == 'allCame') return true;
  final id = int.tryParse(action.queryParameters['vendorId'] ?? '');
  final rows = snapshot['vendors'];
  return id != null && id > 0 && rows is List &&
      rows.any((row) => row is Map && row['id'] == id);
}

Future<Map<String, dynamic>?> _storedSnapshot() async {
  final raw = await HomeWidget.getWidgetData<String>(diaryWidgetSnapshotKey);
  if (raw == null) return null;
  try {
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  } on FormatException {
    return null;
  }
}

Future<bool> _actionStillValid(Uri? action) async => validDiaryWidgetAction(
  action, await _storedSnapshot(),
  locked: await HomeWidget.getWidgetData<bool>(appLockEnabledKey, defaultValue: true) ?? true,
  dbName: await HomeWidget.getWidgetData<String>(activeDiaryDbKey),
  householdId: await HomeWidget.getWidgetData<String>(activeHouseholdIdKey),
  householdName: await HomeWidget.getWidgetData<String>(activeHouseholdNameKey),
  now: DateTime.now(),
);

@pragma('vm:entry-point')
Future<void> diaryWidgetBackgroundCallback(Uri? action) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  AppDatabase? database;
  try {
    if (!await _actionStillValid(action)) return;
    final dbName = action!.queryParameters['dbName']!;
    final householdId = action.queryParameters['householdId']!;
    final householdName = action.queryParameters['householdName']!;
    database = AppDatabase(name: dbName);
    final day = DateTime.now();
    final repository = TodayRepository(database);
    final vendors = await repository.loadDay(day);
    if (!await _actionStillValid(action)) return;
    final catalog = AppDatabase(name:'hisab_diary_device');
    try {
      final selection = await (catalog.select(catalog.settings)..where((row) =>
        row.key.equals('selectedHousehold'))).getSingleOrNull();
      if ((selection?.value ?? 'home') != householdId) return;
    } finally { await catalog.close(); }
    final kind = action.queryParameters['action'];
    if (kind == 'allCame') {
      await repository.markAllCame(day);
    } else if (kind == 'came' || kind == 'absent') {
      final id = int.parse(action.queryParameters['vendorId']!);
      if (!vendors.any((row) => row.vendor.id == id)) return;
      await repository.mark(id, day,
        kind == 'came' ? Attendance.came : Attendance.notCame);
    }
    if (await HomeWidget.getWidgetData<String>(activeDiaryDbKey) != dbName ||
        await HomeWidget.getWidgetData<String>(activeHouseholdIdKey) != householdId ||
        await HomeWidget.getWidgetData<String>(activeHouseholdNameKey) != householdName) { return; }
    await _writeSnapshot(database, dbName: dbName, householdId: householdId,
      householdName: householdName);
  } catch (error) {
    // Widget errors must never fall back to writing a different diary.
    debugPrint('Diary widget action failed (${error.runtimeType}).');
    try {
      await HomeWidget.saveWidgetData<bool>('diary_widget_error', true);
      await HomeWidget.updateWidget(qualifiedAndroidName: diaryWidgetAndroidName);
    } catch (storageError) {
      debugPrint('Diary widget error display failed (${storageError.runtimeType}).');
    }
  } finally {
    await database?.close();
  }
}

Future<void> _writeSnapshot(AppDatabase database, {required String dbName,
  required String householdId, required String householdName,
  bool Function()? isCurrent}) async {
  final day = DateTime.now();
  final rows = await TodayRepository(database).loadDay(day);
  final settings = await database.select(database.settings).get();
  final language = settings.where((row) => row.key == 'language')
      .map((row) => row.value).firstOrNull ?? 'hi';
  final strings = await AppLocalizations.delegate.load(Locale(language));
  final labels = {for (final key in const [
    'widgetTitle', 'widgetOpenDiary', 'widgetAllCame', 'widgetCame',
    'widgetAbsent', 'widgetUnmarked', 'widgetNoDeliveries', 'widgetMoreVendors',
    'widgetLocked', 'widgetRefresh', 'widgetError',
  ]) key: v3String(language, key)};
  final snapshot = jsonEncode({
    'dbName': dbName, 'householdId': householdId, 'householdName': householdName,
    'date': diaryDate(day), 'token': DateTime.now().microsecondsSinceEpoch.toString(),
    'labels': labels,
    'vendors': [for (final row in rows) {
      'id': row.vendor.id,
      'name': row.vendor.name.trim().isNotEmpty ? row.vendor.name
          : vendorTypeLabel(strings, row.vendor.type),
      'status': row.status?.name,
    }],
  });
  if (isCurrent != null && !isCurrent()) return;
  if (await HomeWidget.getWidgetData<String>(activeDiaryDbKey) != dbName ||
      await HomeWidget.getWidgetData<String>(activeHouseholdIdKey) != householdId ||
      await HomeWidget.getWidgetData<String>(activeHouseholdNameKey) != householdName) { return; }
  if (isCurrent != null && !isCurrent()) return;
  if (await HomeWidget.saveWidgetData<String>(diaryWidgetSnapshotKey, snapshot) != true) {
    throw StateError('Widget snapshot could not be saved');
  }
  await HomeWidget.saveWidgetData<bool>('diary_widget_error', false);
  await HomeWidget.updateWidget(qualifiedAndroidName: diaryWidgetAndroidName);
}

class DiaryWidgetService with WidgetsBindingObserver {
  DiaryWidgetService(this.database, {required this.dbName,
    required this.householdId, required this.householdName});
  final AppDatabase database;
  final String dbName;
  final String householdId;
  final String householdName;
  StreamSubscription<List<TodayVendor>>? _subscription;
  StreamSubscription<Map<String, String>>? _settingsSubscription;
  Timer? _midnight;
  bool _disposed = false;
  static Future<void> _pending = Future.value();

  Future<void> start() async {
    if (!supportsDeviceFeatures || _disposed) return;
    if (!_diaryNamePattern.hasMatch(dbName)) throw ArgumentError('Invalid diary name');
    WidgetsBinding.instance.addObserver(this);
    _pending = _pending.catchError((Object error) => _error(error)).then((_) async {
      if (_disposed) return;
      for (final entry in {activeDiaryDbKey: dbName, activeHouseholdIdKey: householdId,
          activeHouseholdNameKey: householdName}.entries) {
        if (await HomeWidget.saveWidgetData<String>(entry.key, entry.value) != true) {
          throw StateError('Widget diary selection could not be saved');
        }
      }
    });
    try {
      await _pending;
      if (_disposed) return;
      _watchDay();
      _settingsSubscription = database.watchSettings().listen((_) => unawaited(refresh()),
        onError: _error);
    } catch (error) {
      _error(error);
    }
  }

  void _watchDay() {
    unawaited(_subscription?.cancel());
    final now = DateTime.now();
    _subscription = TodayRepository(database).watchDay(now).listen(
      (_) => unawaited(refresh()), onError: _error);
    _midnight?.cancel();
    _midnight = Timer(DateTime(now.year, now.month, now.day + 1).difference(now), () {
      if (!_disposed) _watchDay();
    });
  }

  void _error(Object error) {
    debugPrint('Diary widget refresh failed (${error.runtimeType}).');
  }

  Future<void> refresh() async {
    if (!supportsDeviceFeatures || _disposed) return;
    _pending = _pending.catchError((Object error) => _error(error)).then((_) async {
      if (_disposed) return;
      await _writeSnapshot(database, dbName: dbName, householdId: householdId,
        householdName: householdName, isCurrent: () => !_disposed);
    });
    try { await _pending; } catch (error) { _error(error); }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_disposed) _watchDay();
  }

  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    unawaited(_settingsSubscription?.cancel());
    _midnight?.cancel();
  }
}
