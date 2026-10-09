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
  @override
  void initState() {
    super.initState();
    unawaited(DiaryUsageAnalytics(ref.read(databaseProvider)).initialize());
    ref.read(proPurchaseServiceProvider).start();
    ref.read(reminderServiceProvider).start();
  }
  @override
  Widget build(BuildContext context) => const HisabApp();
}
