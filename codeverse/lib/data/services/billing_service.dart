/// Abstraction over "can the player unlock PRO right now." Two
/// implementations: [MockBillingService] (debug/no-store fallback) and a
/// real `in_app_purchase`-backed one for release builds.
abstract class BillingService {
  Future<bool> purchasePro();
  Future<bool> restorePurchases();
}
