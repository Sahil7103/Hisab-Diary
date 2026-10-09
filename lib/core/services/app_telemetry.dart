import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

/// Monitoring must never interrupt the offline diary or include diary contents.
class AppTelemetry {
  static bool _enabled = false;
  static bool get enabled => _enabled;
  static Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      debugPrint('Firebase monitoring unavailable (${error.runtimeType}).');
    }
  }

  static Future<void> initialize() async {
    const enabled = bool.fromEnvironment('FIREBASE_TELEMETRY', defaultValue: kReleaseMode);
    await _guard(() => FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled));
    await _guard(() => FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled));
    await _guard(() => FirebasePerformance.instance.setPerformanceCollectionEnabled(enabled));
    _enabled = enabled;
    if (!enabled) return;
    final previousFlutterHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      previousFlutterHandler?.call(details);
      report(details.exception, details.stack ?? StackTrace.current,
        operation: 'flutter_framework', fatal: true);
    };
    final previousPlatformHandler = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      report(error, stack, operation: 'uncaught_async', fatal: true);
      return previousPlatformHandler?.call(error, stack) ?? true;
    };
  }

  static void event(String name) => unawaited(trackEvent(name));

  static Future<void> trackEvent(String name,
      {Map<String, Object>? parameters}) async {
    if (!_enabled) return;
    await _guard(() => FirebaseAnalytics.instance.logEvent(
      name: name, parameters: parameters));
  }

  static void screen(String name) {
    if (!_enabled) return;
    unawaited(_guard(() => FirebaseAnalytics.instance.logScreenView(screenName: name)));
  }

  static void report(Object error, StackTrace stack,
      {required String operation, bool fatal = false}) {
    if (!_enabled) return;
    // SQL and platform exceptions can contain user-entered data: send type only.
    unawaited(_guard(() => FirebaseCrashlytics.instance.recordError(
      error.runtimeType.toString(), stack, reason: operation, fatal: fatal)));
  }

  static Future<T> measure<T>(String operation, Future<T> Function() action) async {
    Trace? trace;
    if (_enabled) {
      await _guard(() async { trace = FirebasePerformance.instance.newTrace(operation); });
    }
    if (trace != null) await _guard(trace!.start);
    try {
      final result = await action();
      event(operation);
      return result;
    } catch (error, stack) {
      report(error, stack, operation: operation);
      rethrow;
    } finally {
      if (trace != null) await _guard(trace!.stop);
    }
  }
}
