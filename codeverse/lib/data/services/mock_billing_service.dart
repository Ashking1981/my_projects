import 'billing_service.dart';

/// Always-succeeds stand-in for the Play Billing flow, used in debug builds
/// and as a fallback when the store isn't available (e.g. this sandbox,
/// which has no Android SDK/Play Services to test real billing against).
/// Never used in a release build — see [EntitlementService].
class MockBillingService implements BillingService {
  @override
  Future<bool> purchasePro() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> restorePurchases() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
