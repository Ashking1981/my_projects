# CodeVerse — Project Notes

## Decisions log

- **Phase 0 (scaffold)**
  - App lives at `/codeverse` in this repo, alongside unrelated notebooks at the repo root.
  - Package id: `com.codeverse.app`. Display name and tagline are centralized in
    `lib/app/app_constants.dart` — change branding there, nowhere else.
  - Flutter SDK pinned to the stable channel version installed in dev (3.24.5 / Dart 3.5.4).
    `lottie` was pinned to `3.1.3` instead of latest because newer `lottie` requires
    Dart SDK `>=3.6.0`, which is ahead of the installed toolchain. Bump both together
    later if the Flutter SDK is upgraded.
  - Gradle wrapper bumped from 8.3 to 8.6 to match the installed JDK 21
    (Gradle 8.3 only supports Java up to 20).
  - Folder structure (feature-first):
    `lib/app` (app shell, router, constants), `lib/ui` (design system: tokens + widgets),
    `lib/data` (models, repositories, local/Hive), `lib/domain` (business logic),
    `lib/features/{onboarding,home,realm,level,shop,profile,paywall,parent}`
    (each split into `presentation/` and `application/`).
  - Build verification in this environment: `flutter analyze` + `flutter test` only.
    `flutter build apk`/`appbundle` requires the Android SDK, and this sandbox's egress
    policy blocks `dl.google.com`/`maven.google.com`, so the Android SDK can't be
    installed here. Run the native build locally or in CI before release.

## How to add content (from Phase 2 onward)

(To be filled in once the content JSON schema and validator exist.)

## How to add a language

(To be filled in once l10n scaffolding exists — default locale is English.)

## How to configure billing & signing

(To be filled in during Phase 6/8 — billing via `EntitlementService` +
`MockBillingService` fallback for debug, real Play Billing via `in_app_purchase`
for release. Signing via `android/key.properties`, never committed.)
