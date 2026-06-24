# Signing CodeVerse for release

`android/app/build.gradle` reads release signing config from
`android/key.properties`, which is gitignored and must never be committed.
Without that file, release builds fall back to the debug key so local/CI
builds that don't need to be Play-Store-installable keep working.

## One-time setup

1. Generate a release keystore (do this once, then back the `.jks` file up
   somewhere safe — losing it means you can never update the app on Play
   under the same listing again):

   ```sh
   keytool -genkey -v -keystore ~/codeverse-release.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias codeverse
   ```

2. Create `android/key.properties` (next to this file's sibling
   `android/key.properties.example`) with:

   ```properties
   storePassword=<the keystore password you set above>
   keyPassword=<the key password you set above>
   keyAlias=codeverse
   storeFile=/absolute/path/to/codeverse-release.jks
   ```

3. Build the release artifact:

   ```sh
   flutter build appbundle --release   # for Play Store upload
   flutter build apk --release         # for manual/sideload testing
   ```

   Both require the Android SDK, which this development sandbox doesn't
   have (its egress policy blocks `dl.google.com`/`maven.google.com`) — run
   these locally or in CI, not here.

## Verifying

`flutter build appbundle --release --analyze-size` or
`apksigner verify --print-certs app-release.apk` will confirm the bundle is
signed with the release key, not the debug one.

## Billing

Before the first release build, also flip
`lib/data/providers.dart`'s `billingServiceProvider` from
`MockBillingService()` to `InAppPurchaseBillingService()`, and create the
matching one-time, non-consumable product
(`AppConstants.proProductId` = `codeverse_pro_unlock`) in the Google Play
Console under the app's in-app products. See `PROJECT_NOTES.md` for the
full billing wiring notes.
