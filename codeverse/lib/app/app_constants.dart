/// Single source of truth for app-wide configuration.
/// Change the product name/branding here without touching any other file.
class AppConstants {
  AppConstants._();

  static const String appName = 'CodeVerse';
  static const String appTagline = 'Your journey into tech starts here';
  static const String packageId = 'com.codeverse.app';

  /// Google Play in-app purchase product id for the one-time PRO unlock.
  static const String proProductId = 'codeverse_pro_unlock';

  static const String privacyPolicyAssetPath =
      'assets/legal/privacy_policy.md';
}
