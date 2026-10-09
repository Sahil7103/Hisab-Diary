import '../../core/services/app_telemetry.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import '../../app/app_providers.dart';
import '../../core/storage/app_database.dart';
import 'vendor_limits.dart';

final proPurchaseServiceProvider = Provider<ProPurchaseService>((ref) {
  final service = ProPurchaseService(ref.watch(databaseProvider));
  ref.onDispose(service.dispose);
  return service;
});

enum ProStoreStatus { idle, loading, ready, unavailable, pending, failed, canceled, restored }

class ProPurchaseService extends ChangeNotifier {
  ProPurchaseService(this.database, {InAppPurchase? store,
    this.purchasesEnabled = proPurchasesEnabled}) : _storeOverride = store;
  final bool purchasesEnabled;
  final AppDatabase database;
  final InAppPurchase? _storeOverride;
  InAppPurchase get _store => _storeOverride ?? InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Future<void> _processing = Future<void>.value();
  bool _disposed = false;
  bool _storeOperation = false;
  ProductDetails? product;
  ProStoreStatus status = ProStoreStatus.idle;
  bool get supported => Platform.isAndroid || _storeOverride != null;
  bool get busy => _storeOperation || status == ProStoreStatus.pending;

  void _update(ProStoreStatus value) {
    if (status != value) AppTelemetry.event('pro_store_${value.name}');
    status = value;
    if (!_disposed) notifyListeners();
  }

  void start() {
    if (!purchasesEnabled) return;
    if (!supported || _subscription != null) return;
    _subscription = _store.purchaseStream.listen((purchases) {
      // Complete batches in order, including purchases replayed on app launch.
      _processing = _processing.then((_) => _handle(purchases)).catchError((Object error, StackTrace stack) {
        AppTelemetry.report(error, stack, operation: 'pro_purchase_processing');
        _update(ProStoreStatus.failed);
      });
    }, onError: (Object error, StackTrace stack) {
      AppTelemetry.report(error, stack, operation: 'pro_purchase_stream');
      _update(ProStoreStatus.failed);
    });
  }

  Future<void> _handle(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != proProductId) continue;
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _update(ProStoreStatus.pending);
        case PurchaseStatus.error:
          _update(ProStoreStatus.failed);
        case PurchaseStatus.canceled:
          _update(ProStoreStatus.canceled);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // The trusted store plugin supplies completed transactions. Keep core
          // entitlement local; never import it from a user-editable backup.
          if (purchase.purchaseID == null || purchase.purchaseID!.isEmpty ||
              purchase.verificationData.serverVerificationData.isEmpty ||
              purchase.verificationData.source != 'google_play') {
            throw StateError('Invalid Play purchase');
          }
          await database.saveSetting(proEntitlementKey, 'true');
          if (purchase.pendingCompletePurchase) await _store.completePurchase(purchase);
          _update(purchase.status == PurchaseStatus.restored
            ? ProStoreStatus.restored : ProStoreStatus.ready);
      }
    }
  }

  Future<void> _refreshOwnership() async {
    if (!Platform.isAndroid) return;
    final response = await _store
      .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>().queryPastPurchases();
    if (response.error != null) throw StateError('Store ownership query failed');
    final purchases = response.pastPurchases.where((purchase) =>
      purchase.productID == proProductId).toList();
    _processing = _processing.then((_) => _handle(purchases)).catchError((Object error, StackTrace stack) {
        AppTelemetry.report(error, stack, operation: 'pro_purchase_processing');
      _update(ProStoreStatus.failed);
    });
    await _processing;
    if (status == ProStoreStatus.failed) throw StateError('Purchase could not be processed');
    if (!purchases.any((purchase) => purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored)) {
      // Reconcile only after a successful store query. Offline failures must
      // preserve the locally cached entitlement and all existing diary data.
      await database.saveSetting(proEntitlementKey, 'false');
    }
  }

  Future<void> load() async {
    if (!purchasesEnabled) return;
    if (busy) return;
    _storeOperation = true;
    _update(ProStoreStatus.loading);
    try {
      if (!supported || !await _store.isAvailable()) {
        _update(ProStoreStatus.unavailable);
        return;
      }
      start();
      await _refreshOwnership();
      final response = await _store.queryProductDetails({proProductId});
      product = response.productDetails.where((item) => item.id == proProductId).firstOrNull;
      _update(response.error == null && product != null
        ? ProStoreStatus.ready : ProStoreStatus.unavailable);
    } catch (error, stack) {
      AppTelemetry.report(error, stack, operation: 'pro_store_operation');
      _update(ProStoreStatus.failed);
    } finally {
      _storeOperation = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> buy() async {
    if (!purchasesEnabled) return;
    if (busy || product == null) return;
    AppTelemetry.event('pro_purchase_started');
    _storeOperation = true;
    _update(ProStoreStatus.pending);
    try {
      final started = await _store.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product!));
      if (!started) _update(ProStoreStatus.failed);
    } catch (error, stack) {
      AppTelemetry.report(error, stack, operation: 'pro_store_operation');
      _update(ProStoreStatus.failed);
    } finally {
      _storeOperation = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> restore() async {
    if (!purchasesEnabled) return;
    if (busy) return;
    _storeOperation = true;
    _update(ProStoreStatus.loading);
    try {
      if (!supported || !await _store.isAvailable()) {
        _update(ProStoreStatus.unavailable);
        return;
      }
      start();
      await _store.restorePurchases();
      // The plugin emits restored purchases before its Android restore call
      // completes. Wait for our database writes before reporting completion.
      await _processing;
      await _refreshOwnership();
      if (status == ProStoreStatus.loading) _update(ProStoreStatus.restored);
    } catch (error, stack) {
      AppTelemetry.report(error, stack, operation: 'pro_store_operation');
      _update(ProStoreStatus.failed);
    } finally {
      _storeOperation = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
