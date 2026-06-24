import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../../app/app_constants.dart';
import 'billing_service.dart';

/// Real Play Billing-backed implementation, used in release builds when
/// the store is available. Cannot be exercised in this sandbox (no Android
/// SDK/Play Services here) — see [MockBillingService] for local dev/test.
class InAppPurchaseBillingService implements BillingService {
  final InAppPurchase _iap = InAppPurchase.instance;

  @override
  Future<bool> purchasePro() async {
    if (!await _iap.isAvailable()) return false;

    final response =
        await _iap.queryProductDetails({AppConstants.proProductId});
    if (response.productDetails.isEmpty) return false;

    final completer = Completer<bool>();
    late StreamSubscription<List<PurchaseDetails>> subscription;
    subscription = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.productID != AppConstants.proProductId) continue;
        switch (purchase.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }
            if (!completer.isCompleted) completer.complete(true);
          case PurchaseStatus.error:
          case PurchaseStatus.canceled:
            if (!completer.isCompleted) completer.complete(false);
          case PurchaseStatus.pending:
            break;
        }
      }
    });

    final started = await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: response.productDetails.first),
    );
    if (!started && !completer.isCompleted) completer.complete(false);

    final result = await completer.future;
    await subscription.cancel();
    return result;
  }

  @override
  Future<bool> restorePurchases() async {
    if (!await _iap.isAvailable()) return false;

    final completer = Completer<bool>();
    late StreamSubscription<List<PurchaseDetails>> subscription;
    subscription = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.productID != AppConstants.proProductId) continue;
        if (purchase.status == PurchaseStatus.restored) {
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          if (!completer.isCompleted) completer.complete(true);
        }
      }
    });

    await _iap.restorePurchases();
    // Give the platform a moment to deliver restored purchases; absence of
    // any after this window means there's nothing to restore.
    unawaited(Future.delayed(const Duration(seconds: 3), () {
      if (!completer.isCompleted) completer.complete(false);
    }));

    final result = await completer.future;
    await subscription.cancel();
    return result;
  }
}
