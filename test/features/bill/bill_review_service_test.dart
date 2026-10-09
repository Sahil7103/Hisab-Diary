import 'dart:async';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/bill/bill_review_service.dart';

class _Review implements InAppReview {
  bool available = true;
  bool fail = false;
  int requests = 0;
  final requested = Completer<void>();
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<void> requestReview() async {
    requests++;
    if (!requested.isCompleted) requested.complete();
    if (fail) throw StateError('Store unavailable');
  }
  @override
  Future<void> openStoreListing({String? appStoreId, String? microsoftStoreId}) async {}
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late _Review review;
  late BillReviewService service;
  setUp(() {
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    db = AppDatabase.forTesting(NativeDatabase.memory());
    review = _Review();
    service = BillReviewService(db, review: review);
  });
  tearDown(() async {
    service.dispose();
    await db.close();
  });

  test('only successful sharing requests a review; attempt survives service restart', () async {
    await service.afterShare(ShareResultStatus.dismissed);
    await service.afterShare(ShareResultStatus.unavailable);
    expect(review.requests, 0);
    await service.afterShare(ShareResultStatus.success);
    expect(review.requests, 1);
    service.dispose();
    service = BillReviewService(db, review: review);
    await service.afterShare(ShareResultStatus.success);
    expect(review.requests, 1);
  });

  test('unavailable review does not consume the one request', () async {
    review.available = false;
    await service.afterShare(ShareResultStatus.success);
    expect(review.requests, 0);
    expect(await db.select(db.settings).get(), isEmpty);
    review.available = true;
    await service.afterShare(ShareResultStatus.success);
    expect(review.requests, 1);
  });

  test('waits until the diary returns to the foreground', () async {
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await service.afterShare(ShareResultStatus.success);
    expect(review.requests, 0);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await review.requested.future.timeout(const Duration(seconds: 5));
    expect(review.requests, 1);
    await service.afterShare(ShareResultStatus.success);
  });

  test('review failure does not fail sharing or repeatedly request', () async {
    review.fail = true;
    await service.afterShare(ShareResultStatus.success);
    await service.afterShare(ShareResultStatus.success);
    expect(review.requests, 1);
  });
}
