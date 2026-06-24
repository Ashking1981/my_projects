# CodeVerse — Project Notes

## Decisions log

- **Content expansion: 5 levels per non-Python realm**
  - Game Forge, Pixel Studio, Data Delta, and Mind Machine each had only 3
    levels (vs. Python Peaks' 5, ending in a boss). Added a 4th regular level
    and a 5th boss level to each, mirroring Python Peaks' structure exactly:
    `gf-04`/`gf-05` (score & state, then a mini-game boss combining the loop,
    sprites, collisions, and state — badge `mini_game_builder`), `ps-04`/
    `ps-05` (contrast & focus, then a badge-design boss combining color,
    shape, alignment, contrast — badge `badge_designer`), `dd-04`/`dd-05`
    (reading bar charts, then a full survey-analysis boss — badge
    `data_analyst`), `mm-04`/`mm-05` (train/test split, then training a tiny
    classifier — badge `classifier_builder`).
  - All 5 realms now have 25 levels total; `tool/validate_content.dart`
    confirms this. Updated
    `test/data/content_repository_test.dart`'s "loads 3 levels for each
    non-Python realm" test to "loads 5 levels with a boss for each
    non-Python realm" to match.
  - No new challenge types or playground types were needed — every new
    level reuses an existing `Challenge`/playground type already supported
    by the engine.

- **Phase 8 (release polish: icon, splash, signing, store listing)**
  - No designer art exists for this app (Phase 1 explicitly punted on real
    icons/fonts), so the launcher icon/splash logo are generated
    programmatically: `assets/icon/app_icon.png` (solid brand-purple square
    with a white `</>` code-bracket glyph and an accent-orange "spark" dot,
    drawn with Pillow — see the icon for the exact look) for the launcher
    icon, and `assets/icon/splash_logo.png` (same glyph, transparent
    background) for the native splash, so the splash doesn't show a hard
    square edge over the brand-color backdrop.
  - Wired via `flutter_launcher_icons` (generates `android/app/src/main/res/
    mipmap-*/ic_launcher.png`) and `flutter_native_splash` (generates the
    `drawable*/launch_background.xml` + `values*/styles.xml` splash theme),
    both configured directly in `pubspec.yaml`. Both are dev-dependencies
    and only need re-running (`dart run flutter_launcher_icons` / `dart run
    flutter_native_splash:create`) if the source PNGs change — the
    generated output is committed since regenerating requires no Android
    SDK but is still nice to have versioned for review.
  - Fixed a latent mismatch: `AppConstants.packageId` said `com.codeverse.app`
    but the actual Android `applicationId`/`namespace` (set by the original
    `flutter create`) is `com.codeverse.app.codeverse`. Updated the Dart
    constant to match reality rather than touching Gradle/Kotlin package
    paths, since renaming those isn't verifiable without the Android SDK in
    this sandbox. `AndroidManifest.xml`'s `android:label` was also fixed
    from lowercase `codeverse` to `CodeVerse`.
  - Release signing: `android/app/build.gradle` now defines a
    `signingConfigs.release` that reads from `android/key.properties` (a
    gitignored file — see `android/.gitignore`, already covered before this
    phase) when present, and falls back to the debug key otherwise so
    `flutter build apk --release` keeps working in this sandbox (and any
    other environment without a release keystore). `SIGNING.md` documents
    the one-time `keytool`/`key.properties` setup, and
    `android/key.properties.example` shows the expected shape. Both real
    builds (`flutter build appbundle`/`apk --release`) still require the
    Android SDK and must run outside this sandbox per the existing Phase 0
    note.
  - `STORE_LISTING.md` is new: Play Store title/descriptions/category/content
    rating notes drafted from what's actually built (free/PRO split, no
    ads/tracking, Parent Dashboard, local-only storage), plus explicit TODOs
    for the two things that can't be produced here — real screenshots/
    feature graphic (no running Android build in this sandbox to capture
    from) and a publicly-hosted privacy policy URL (Play Console requires a
    URL, not a bundled asset — `assets/legal/privacy_policy.md`'s content is
    ready to publish, just not yet hosted anywhere).

- **Phase 7 (compliance pass: Parent Dashboard, privacy policy, dyslexia font)**
  - `PlayerProfile` gained `dyslexiaFontEnabled` (default `false`), persisted
    at the next free Hive index (11) per the adapter's append-only
    convention — `PlayerProfileAdapter`'s field count bumped from 11 to 12.
    `PlayerProfileNotifier.setDyslexiaFont(bool)` follows the same
    mutate-in-place + persist pattern as every other profile mutation.
  - `lib/app/app.dart`'s `CodeVerseApp` is now a `ConsumerWidget`: it watches
    `playerProfileProvider` and passes `AppFontFamilies.dyslexiaFriendly` as
    `fontFamilyOverride` into `AppTheme.light/dark` when the toggle is on —
    wiring that Phase 1's `fontFamilyOverride` param was already built for.
    Still falls back to the platform font since no `OpenDyslexic` `.ttf` is
    bundled yet (same caveat as Phase 1's other font tokens).
  - `assets/legal/privacy_policy.md` is new bundled content (declared under
    `flutter.assets` in `pubspec.yaml`), loaded at runtime by the new
    `PrivacyPolicyScreen` (`lib/features/parent/presentation/`) via
    `rootBundle.loadString` — same "content is data" approach as the realm
    JSON, so the policy text can be edited without a Dart change.
  - `ParentDashboardScreen` (`lib/features/parent/presentation/`) is the
    Phase 7 deliverable the spec's Parent Dashboard requirement asked for:
    child nickname/level/XP/streak, a per-realm progress list (reusing
    `ProgressCalculator.realmProgress`), PRO entitlement status with an
    upgrade shortcut to `/paywall`, the dyslexia-font `SwitchListTile`, and a
    link to `PrivacyPolicyScreen`. New `/parent-dashboard` route. Entry point
    is a tile on `ProfileScreen` that calls `requireParentalGate(context)`
    before pushing the route — the dashboard itself assumes the gate has
    already been passed and does no gating of its own, keeping the gate
    check in exactly one place (the call site) rather than duplicated.
  - Zero-personal-data audit (documented here rather than a separate file):
    confirmed via the full `pubspec.yaml` dependency list that no ads,
    analytics, or tracking SDKs exist anywhere in the project; the only
    free-text field anywhere in the app is the local nickname, stored only
    in the on-device Hive box; the only network traffic the app can ever
    generate is Google Play Billing's own purchase/restore calls inside
    `InAppPurchaseBillingService`. No code changes were needed to satisfy
    this — it's a statement about what's *absent*, which the privacy policy
    text now states explicitly for parents/reviewers.

- **Phase 6 (entitlement + paywall + parental gate)**
  - FREE/PRO split (`lib/domain/content_access.dart`, `ContentAccess`): the
    Python Peaks realm is free forever; the other four Realms
    (`requiresPro`) need the PRO unlock. A pure, storage-free rule, same
    style as `ProgressCalculator`.
  - `lib/data/services/billing_service.dart` defines the `BillingService`
    interface (`purchasePro`/`restorePurchases`). `MockBillingService`
    always succeeds after a short delay and is what `billingServiceProvider`
    wires up for now — this sandbox has no Android SDK/Play Services, so
    the real `InAppPurchaseBillingService` (wraps `in_app_purchase`'s
    `queryProductDetails`/`buyNonConsumable`/`purchaseStream` for
    `AppConstants.proProductId`) exists but is untested here. Swapping to it
    for a signed release build is a one-line change in `providers.dart`.
  - `EntitlementNotifier`/`entitlementProvider` follow the same
    mutate-in-place + persist pattern as `PlayerProfileNotifier`:
    `purchasePro()`/`restorePurchases()` call the `BillingService`, then set
    `Entitlement.isPro` and persist via `EntitlementRepository` on success.
    This is the only place in the app that should ever read/write PRO
    status.
  - `ParentalGateScreen` (`lib/features/parent/presentation/`) is a simple
    "what's A+B" arithmetic check with 4 shuffled choices (one correct, 3
    off by a fixed offset) — enough friction for a 10-16-year-old, trivial
    for an adult. `requireParentalGate(context)` (`lib/features/parent/
    application/parental_gate.dart`) pushes it and resolves to whether it
    was passed; `PaywallScreen` calls it before every purchase/restore
    attempt per the no-online/child-safety requirements. The full Parent
    Dashboard (also gated by this same check) is still Phase 7 — this phase
    only needed the gate itself for purchases.
  - `PaywallScreen` (`lib/features/paywall/presentation/`) is the only
    place `purchasePro`/`restorePurchases` are called from. New `/paywall`
    route.
  - Gating is enforced in two places: `UniverseMapScreen` routes a tap on a
    PRO-locked-but-progression-unlocked `RealmCard` to `/paywall` instead of
    the realm (with a small "PRO" badge overlay so it doesn't look broken),
    and `RealmMapScreen` re-checks the same rule on build and bounces to
    `/paywall` via `context.go` if reached directly — defense-in-depth for
    a future deep link, since today the only way in is through the map's
    tap handler.

- **Phase 5 (gamification: shop, badges, rank ladder, streaks)**
  - `lib/data/models/shop_item.dart` + `lib/data/repositories/shop_repository.dart`
    hold a fixed, hardcoded Dart cosmetics catalog (5 avatars, 4 companion
    skins) — unlike Level content this is product catalog, not educational
    content, so it doesn't need to live in JSON. No art assets exist yet, so
    each item renders as a colored circle + Material icon instead of an
    image.
  - `PlayerProfileNotifier` gained `purchaseItem` (deduct coins, add to
    `ownedItemIds`, auto-equip, no-op if unaffordable or already owned),
    `equipItem` (only if owned), and `equipDefault` (reset a slot to the
    free `default` look) — same mutate-in-place + persist pattern as
    `completeLevel`.
  - `lib/data/models/badge_definition.dart` + `lib/data/repositories/
    badge_repository.dart`: a small static catalog mapping badge ids (from
    level `reward.badgeId`, currently only `first_function`) to a
    name/description/icon. `BadgeRepository.definitionFor` falls back to a
    generic "Achievement" look for any uncatalogued id so future content
    can introduce new badge ids without an app update first.
  - The spec's "local-only leaderboard" has no online accounts to rank
    against in this app, so `lib/domain/rank_calculator.dart`
    (`RankCalculator`) reinterprets it as a single-player rank ladder
    (Newcomer → Apprentice → Coder → Engineer → Architect → Legend) driven
    purely by the player's own total XP. Pure functions, no storage
    dependency, same style as `ProgressCalculator`.
  - New screens: `ShopScreen` (tabbed Avatars/Companions grid),
    `BadgesScreen`, `LeaderboardScreen` (rank ladder), and a `ProfileScreen`
    hub linking to all three plus streak/XP display — all under
    `lib/features/{shop,profile}/presentation/`. Routes added: `/profile`,
    `/shop`, `/badges`, `/leaderboard`. `UniverseMapScreen`'s app bar gained
    a `StreakBadge` and a profile icon button.
  - New design-system widget `StreakBadge` (`lib/ui/widgets/streak_badge.dart`),
    styled like the existing `CoinBadge`.

- **Phase 4 (interactive Playgrounds + animation polish)**
  - `lib/features/level/presentation/playground_widget.dart` replaces the
    Phase 3 read-only Playground placeholder with a real, hands-on widget
    per `PlaygroundData.type`. All 13 types used across the 17 authored
    levels have a genuine interaction (tap/drag/slider/text input), driven
    entirely by the JSON `config` map — no changes to the `Level`/
    `PlaygroundData` models were needed, consistent with "content is data."
    Playgrounds are exploratory only; nothing here is graded (the Challenge
    step still owns correctness).
  - Each playground variant is a small private `StatefulWidget` inside that
    one file rather than its own file per type — 13 tiny widgets sharing a
    `_PlaygroundScaffold` helper for the instructions-then-content layout.
    Revisit if any one variant grows complex enough to need its own
    Riverpod state or asset loading.
  - Animation polish uses `flutter_animate` only (fade/slide on every
    Level-Player step transition, an elastic scale + shake + staggered
    fade-in on the Reward step's trophy/XP/coin row). No Lottie files are
    bundled yet — `lottie` stays a pinned dependency for Phase 7-era
    mascot/celebration assets once real `.json` animations are sourced;
    until then `flutter_animate`'s procedural animations cover the "feel
    alive" requirement without needing new binary assets.
  - `LevelPlayerScreen` wraps each step's content in `KeyedSubtree(key:
    ValueKey(_step))` so `flutter_animate`'s `.animate()` re-triggers on
    every step change instead of only once.

- **Phase 3 (navigation & core screens)**
  - go_router routes: `/` (root), `/realm/:realmId`, `/level/:levelId`,
    `/dev/components`. No router-level redirect logic — `/` always builds
    `HomeScreen`, which itself watches `playerProfileProvider` and renders
    `OnboardingScreen` while `nickname` is empty, or `UniverseMapScreen`
    once it isn't. Keeps the auth-less, login-less onboarding gate simple
    without GoRouter's `refreshListenable` plumbing.
  - State management: `lib/data/providers.dart` holds every Riverpod
    provider for now (content repo, player repo, entitlement repo,
    `realmsProvider`, `allLevelsProvider`, `levelsForRealmProvider` family,
    and `playerProfileProvider`/`PlayerProfileNotifier`). Split into
    per-feature provider files once this gets crowded.
  - `PlayerProfileNotifier` mutates the existing `PlayerProfile` instance in
    place (it's already mutable for Hive) and reassigns `state = state` to
    notify listeners, then persists via `PlayerRepository.save`. Avoids
    introducing a parallel immutable/copyWith model just for Riverpod.
  - Lock/progress rules live in `lib/domain/progress_calculator.dart`
    (`ProgressCalculator`), pure functions over `List<Level>` +
    `PlayerProfile` with no widget or storage dependency: a level unlocks
    once the previous level in its realm has stars; a realm unlocks once
    the previous realm's levels are all completed. Same rules drive both
    `UniverseMapScreen` (Realm-level lock/progress) and `RealmMapScreen`
    (Level-node lock/star state).
  - `LevelPlayerScreen` runs the fixed core loop as a local 5-step state
    machine (`_LevelStep`): Story (paged through `level.story`) → Concept →
    Playground (read-only instructions placeholder — interactive playground
    widgets are a later phase) → Challenge → Reward. On a correct Challenge
    submission it calls `PlayerProfileNotifier.completeLevel` (stars/xp/
    coins/streak/badge) before showing the Reward step.
  - `ChallengeAnswerWidget` (`lib/features/level/presentation/`) renders the
    right input per `Challenge` subtype via a sealed `switch`: radio list
    for `multiple_choice`, a text field for `fill_blank`, tap-to-build chip
    lists for `drag_to_order`/`block_code` (shuffled with a fixed seed so
    layout is deterministic in tests), and per-key dropdowns for
    `match_pairs`. It reports the in-progress response shape each
    `Challenge.isCorrect` expects via an `onChanged` callback — grading
    stays entirely in the data layer.
  - Star score on submit: 3 stars on a first-try correct answer, 2 if the
    player got it wrong at least once first. No XP/coin penalty for retries.

- **Phase 2 (data layer)**
  - Content is data, not code: `assets/content/realms.json` (5 realms) plus one
    JSON file per realm (`levels_python_peaks.json` etc). `ContentRepository`
    loads them via `rootBundle.loadString` and parses into typed models
    (`Realm`, `Level`, `StoryPanelData`, `ConceptData`, `PlaygroundData`,
    `RewardData`, `Challenge`). Adding a level = add/edit JSON only, as long
    as the realm's file is already listed in
    `ContentRepository._levelAssetPaths` and `assets/content/` stays declared
    under `flutter.assets` in `pubspec.yaml`.
  - `Challenge` is a `sealed class` with 5 subtypes (`multiple_choice`,
    `drag_to_order`, `fill_blank`, `match_pairs`, `block_code`), dispatched by
    `Challenge.fromJson` on a `type` string. Each subtype owns its own
    `isCorrect(Object? response)` grading logic — no central grading switch.
  - `tool/validate_content.dart` is a standalone, zero-Flutter-dependency Dart
    script (`dart run tool/validate_content.dart`) that checks realm ids,
    required keys per level/challenge type, contiguous per-realm level
    ordering starting at 1, and duplicate level ids. Run it after editing any
    content JSON — CI should run it too once CI exists.
  - `fromJson`/`toJson` and the Hive `TypeAdapter`s (`PlayerProfileAdapter`
    typeId 0, `EntitlementAdapter` typeId 1) are hand-written, not generated by
    `build_runner`/`hive_generator`/`json_serializable`, even though those
    packages are pinned as dev dependencies — keeps the data layer
    dependency-free at build time and makes the byte-indexed adapter fields
    easy to reason about for future schema evolution (always append new
    fields at the next free index, never reuse or reorder existing indices).
  - `setUpHive()` (`lib/data/local/hive_setup.dart`) registers both adapters
    and opens both boxes (`player_profile_box`, `entitlement_box`); it's
    called once from `main()` before `runApp`.
  - Hive-based tests must guard adapter registration with
    `if (!Hive.isAdapterRegistered(id))` before calling `registerAdapter`,
    since `setUp`/`tearDown` re-run per test in the same process and Hive
    throws if an adapter for that typeId is already registered.

- **Phase 1 (design system)**
  - Tokens in `lib/ui/tokens/`: `AppColors` (+ `RealmPalette`/`RealmId` enum for
    per-Realm gradients, shared by data models from Phase 2 on), `AppSpacing`/
    `AppRadii`/`AppElevation`, `AppTextStyles`/`AppFontFamilies`.
  - `AppFontFamilies.display`/`body`/`dyslexiaFriendly` declare font family
    names (Baloo2/Inter/OpenDyslexic) but no `.ttf` files are bundled yet —
    Flutter silently falls back to the platform font until real font assets
    are added under `assets/fonts/` and registered in `pubspec.yaml`. The
    dyslexia-friendly toggle (Phase 7) will pass `fontFamilyOverride` into
    `AppTheme.light/dark`.
  - `lib/ui/theme/app_theme.dart` builds light/dark `ThemeData` from tokens
    only — no inline colors/sizes.
  - Widget library in `lib/ui/widgets/`: PrimaryButton, RealmCard, LevelNode,
    XPBar (as `XpBar`), CoinBadge, StarRating, StoryPanel, ConceptCard,
    ChallengeShell, LockOverlay, MascotBubble. Exported via `lib/ui/ui.dart`.
  - `withValues(alpha:)` (Flutter 3.27+) isn't available on the installed
    3.24.5 SDK — used `withOpacity` instead. Revisit if the SDK is upgraded.
  - Visual QA gallery at `/dev/components`
    (`lib/features/dev/components_gallery_screen.dart`), with a smoke test
    that scrolls through and asserts every section renders.

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

1. Pick the realm and open (or create) `assets/content/levels_<realm>.json`.
2. Append a level object with: `id` (unique, `<realmPrefix>-NN`), `realmId`
   (must be one of `pythonPeaks`/`gameForge`/`pixelStudio`/`dataDelta`/
   `mindMachine`), `order` (contiguous per realm, starting at 1), `title`,
   `isBoss`, `story` (list of `{speaker, message}`), `concept`
   (`{title, explanation, example?}`), `playground`
   (`{type, instructions, config?}`), `challenge` (`{type, prompt, ...}` —
   shape depends on `type`), `reward` (`{xp, coins, badgeId?}`).
3. If it's a brand-new realm file, add its path to
   `ContentRepository._levelAssetPaths` in
   `lib/data/repositories/content_repository.dart`.
4. Run `dart run tool/validate_content.dart` from `codeverse/` and fix any
   reported errors.
5. Run `flutter test` — `test/data/content_repository_test.dart` checks
   per-realm level counts and ordering.

## How to add a language

(To be filled in once l10n scaffolding exists — default locale is English.)

## How to configure billing & signing

Billing (done in Phase 6): `lib/data/providers.dart`'s `billingServiceProvider`
currently returns `MockBillingService()`. Before a real release build, change
it to `InAppPurchaseBillingService()` and create the one-time, non-consumable
product `AppConstants.proProductId` (`codeverse_pro_unlock`) in the Google
Play Console. No other code changes needed — `EntitlementNotifier` only talks
to the `BillingService` interface.

Signing (Phase 8): via `android/key.properties`, never committed.
