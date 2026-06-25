import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers.dart';
import '../../../domain/content_access.dart';
import '../../../domain/progress_calculator.dart';
import '../../../ui/ui.dart';

/// A Realm's skill tree: one [LevelNode] per level, in order, each locked
/// until the previous one is completed.
///
/// Also re-checks the PRO gate (in addition to [UniverseMapScreen]'s tap
/// handling) in case this route is ever reached directly, e.g. a future
/// deep link — bounces straight to the paywall rather than rendering
/// content the player hasn't unlocked.
class RealmMapScreen extends ConsumerWidget {
  const RealmMapScreen({super.key, required this.realmId});

  final RealmId realmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final entitlement = ref.watch(entitlementProvider);
    final levelsAsync = ref.watch(levelsForRealmProvider(realmId));
    final palette = RealmPalette.of(realmId);

    if (ContentAccess.isRealmLocked(realmId, isPro: entitlement.isPro)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/paywall');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: palette.accent),
      body: levelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load levels: $err')),
        data: (levels) {
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: levels.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final level = levels[index];
              final unlocked = ProgressCalculator.isLevelUnlocked(
                levelsInRealm: levels,
                index: index,
                profile: profile,
              );
              final completed = profile.isLevelCompleted(level.id);

              return Center(
                child: LevelNode(
                  label: level.title,
                  realmId: realmId,
                  isBoss: level.isBoss,
                  stars: profile.starsByLevelId[level.id] ?? 0,
                  status: !unlocked
                      ? LevelNodeStatus.locked
                      : completed
                          ? LevelNodeStatus.completed
                          : LevelNodeStatus.unlocked,
                  onTap: () => context.push('/level/${level.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
