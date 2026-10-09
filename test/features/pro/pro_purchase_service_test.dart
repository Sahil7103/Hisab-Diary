import 'dart:async';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:hisab_diary/core/storage/app_database.dart';
import 'package:hisab_diary/features/pro/pro_purchase_service.dart';
import 'package:hisab_diary/features/pro/vendor_limits.dart';

class _Store implements InAppPurchase {
  final updates = StreamController<List<PurchaseDetails>>.broadcast(sync: true);
  final completed = <PurchaseDetails>[];
  bool failCompletion = false;
  bool available = true;
  @override
  Stream<List<PurchaseDetails>> get purchaseStream => updates.stream;
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<void> restorePurchases({String? applicationUserName}) async {}
  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (failCompletion) throw StateError('Completion failed');
    completed.add(purchase);
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late AppDatabase db;
  late _Store store;
  late ProPurchaseService service;
  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    store = _Store();
    service = ProPurchaseService(db, store: store, purchasesEnabled: true)..start();
  });
  tearDown(() async {
    service.dispose();
    await store.updates.close();
    await db.close();
  });
  PurchaseDetails purchase(PurchaseStatus status, {String product = proProductId,
      String receipt = 'store-token'}) => PurchaseDetails(purchaseID: 'order-1',
    productID: product, verificationData: PurchaseVerificationData(
      localVerificationData: 'signed-data', serverVerificationData: receipt, source: 'google_play'),
    transactionDate: '1', status: status)..pendingCompletePurchase = true;
  Future<void> emit(PurchaseDetails purchase, ProStoreStatus status) async {
    final done = Completer<void>();
    void listener() {
      if (service.status == status && !done.isCompleted) done.complete();
    }
    service.addListener(listener);
    store.updates.add([purchase]);
    await done.future.timeout(const Duration(seconds: 5));
    service.removeListener(listener);
  }

  test('free release blocks store operations and preserves entitlement', () async {
    service.dispose();
    service = ProPurchaseService(db, store: store);
    await db.saveSetting(proEntitlementKey, 'true');
    service.start();
    await service.load();
    await service.buy();
    await service.restore();
    expect(store.updates.hasListener, false);
    expect(service.status, ProStoreStatus.idle);
    expect(await vendorLimit(db), proVendorLimit);
  });
  test('pending, canceled and invalid purchases never unlock Pro', () async {
    await emit(purchase(PurchaseStatus.pending), ProStoreStatus.pending);
    expect(await vendorLimit(db), 3);
    await emit(purchase(PurchaseStatus.canceled), ProStoreStatus.canceled);
    expect(await vendorLimit(db), 3);
    await emit(purchase(PurchaseStatus.purchased, receipt: ''), ProStoreStatus.failed);
    expect(await vendorLimit(db), 3);
    expect(store.completed, isEmpty);
  });
  test('purchased and restored Pro persist before completing the transaction', () async {
    await emit(purchase(PurchaseStatus.purchased), ProStoreStatus.ready);
    expect(await vendorLimit(db), 12);
    expect(store.completed, hasLength(1));
    await emit(purchase(PurchaseStatus.restored), ProStoreStatus.restored);
    expect(await vendorLimit(db), 12);
    expect(store.completed, hasLength(2));
  });
  test('unrelated products and offline restore do not alter entitlement', () async {
    store.updates.add([purchase(PurchaseStatus.purchased, product: 'other')]);
    await service.restore();
    expect(await vendorLimit(db), 3);
    await db.saveSetting(proEntitlementKey, 'true');
    store.available = false;
    await service.restore();
    expect(service.status, ProStoreStatus.unavailable);
    expect(await vendorLimit(db), 12);
  });
  test('failed completion reports failure and a replay retries acknowledgment', () async {
    store.failCompletion = true;
    await emit(purchase(PurchaseStatus.purchased), ProStoreStatus.failed);
    expect(store.completed, isEmpty);
    store.failCompletion = false;
    await emit(purchase(PurchaseStatus.purchased), ProStoreStatus.ready);
    expect(store.completed, hasLength(1));
    expect(await vendorLimit(db), 12);
  });
}
