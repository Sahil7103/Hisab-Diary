import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/app_telemetry.dart';
import '../../core/storage/app_database.dart';

const billReviewRequestedKey = 'billReviewRequested';

class BillReviewService with WidgetsBindingObserver {
  BillReviewService(this.database, {InAppReview? review})
      : _review = review ?? InAppReview.instance {
    WidgetsBinding.instance.addObserver(this);
  }

  final AppDatabase database;
  final InAppReview _review;
  bool _pending = false;
  bool _busy = false;
  bool _disposed = false;

  Future<void> afterShare(ShareResultStatus status) async {
    if (_disposed || status != ShareResultStatus.success) return;
    _pending = true;
    await _requestWhenResumed();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_requestWhenResumed());
  }

  Future<void> _requestWhenResumed() async {
    // Android can return a share result while the receiving app is foregrounded.
    if (_disposed || !_pending || _busy ||
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }
    _busy = true;
    try {
      final previous = await (database.select(database.settings)
        ..where((row) => row.key.equals(billReviewRequestedKey))).getSingleOrNull();
      if (_disposed) return;
      if (previous?.value == 'true' || !await _review.isAvailable()) {
        _pending = false;
        return;
      }
      if (_disposed || WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) return;
      // Persist the attempt, not a rating: Google does not report whether it showed.
      await database.saveSetting(billReviewRequestedKey, 'true');
      _pending = false;
      if (_disposed) return;
      await _review.requestReview();
    } catch (error, stack) {
      _pending = false;
      AppTelemetry.report(error, stack, operation: 'bill_review');
    } finally {
      _busy = false;
    }
  }

  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
  }
}
