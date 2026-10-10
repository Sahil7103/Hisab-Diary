import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/hisab_app.dart';
import 'app/app_providers.dart';
import 'core/services/diary_usage_analytics.dart';
import 'core/services/app_telemetry.dart';
import 'features/pro/pro_purchase_service.dart';
import 'features/reminders/reminder_service.dart';
import 'features/reminders/vendor_reminder_service.dart';
import 'features/device/diary_widget_service.dart';
import 'features/device/app_lock_controller.dart';
import 'features/households/household_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    try {
      await Firebase.initializeApp();
      await AppTelemetry.initialize();
    } on FirebaseException catch (error) {
      debugPrint('Firebase initialization failed (${error.code}).');
    } catch (error) {
      // Firebase must not prevent access to the device-local diary.
      debugPrint('Firebase initialization failed: ${error.runtimeType}.');
    }
  }
  await initializeDeviceFeatures();
  runApp(const ProviderScope(child: _DiaryRuntime()));
}

@pragma('vm:entry-point')
Future<void> reminderTimezoneChanged() => rescheduleAfterTimezoneChange();

class _DiaryRuntime extends ConsumerStatefulWidget {
  const _DiaryRuntime();
  @override
  ConsumerState<_DiaryRuntime> createState() => _DiaryRuntimeState();
}
class _DiaryRuntimeState extends ConsumerState<_DiaryRuntime> {
  String? _initializedDiary;
  String? _householdName;
  DiaryWidgetService? _widget;
  bool? _lockEnabled;
  @override
  void initState() {
    super.initState();
    if (supportsDeviceFeatures) AppLockController.instance.addListener(_privacyChanged);
  }
  void _privacyChanged() {
    final lock = AppLockController.instance;
    if (!lock.loaded || _lockEnabled == lock.enabled || _initializedDiary == null) return;
    _lockEnabled = lock.enabled;
    ref.read(reminderServiceProvider).refresh();
    unawaited(ref.read(vendorReminderServiceProvider).refresh().catchError((Object error, StackTrace stack) {
      AppTelemetry.report(error,stack,operation:'vendor_reminder_privacy');
    }));
    unawaited(_widget?.refresh());
  }
  @override
  void dispose() {
    if (supportsDeviceFeatures) AppLockController.instance.removeListener(_privacyChanged);
    _widget?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final households = ref.watch(householdControllerProvider);
    if (!households.loading && !households.error) {
      final db = ref.watch(databaseProvider);
      final household = households.selected;
      if (_initializedDiary != household.databaseName || _householdName != household.name) {
        _initializedDiary = household.databaseName;
        _householdName = household.name;
        unawaited(DiaryUsageAnalytics(db).initialize());
        ref.watch(proPurchaseServiceProvider).start();
        ref.watch(reminderServiceProvider).start();
        ref.watch(vendorReminderServiceProvider).start();
        _widget?.dispose();
        _widget = DiaryWidgetService(db, dbName: household.databaseName,
          householdId: household.id, householdName: household.name);
        unawaited(_widget!.start());
      } else {
        ref.watch(proPurchaseServiceProvider);
        ref.watch(reminderServiceProvider);
        ref.watch(vendorReminderServiceProvider);
      }
    }
    return const HisabApp();
  }
}
