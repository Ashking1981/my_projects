import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_constants.dart';
import '../../../data/providers.dart';
import '../../../domain/progress_calculator.dart';
import '../../../ui/ui.dart';

/// The top-level map: one [RealmCard] per Realm, in story order. A Realm is
/// locked until the previous one is fully completed.
class UniverseMapScreen extends ConsumerWidget {
  const UniverseMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final realmsAsync = ref.watch(realmsProvider);
    final levelsAsync = ref.watch(allLevelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Center(child: StreakBadge(streakCount: profile.streakCount)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Center(child: CoinBadge(amount: profile.coins)),
          ),
          IconButton(
            icon: const Icon(Icons.person_rounded),
            tooltip: 'Profile',
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: realmsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load realms: $err')),
        data: (realms) => levelsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) =>
              Center(child: Text('Failed to load levels: $err')),
          data: (allLevels) {
            final levelsByRealm = {
              for (final realm in realms)
                realm.id: allLevels.where((l) => l.realmId == realm.id).toList(),
            };

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: XpBar(
                    level: profile.level,
                    currentXp: profile.xp % 100,
                    xpForNextLevel: 100,
                  ),
                ),
                for (var i = 0; i < realms.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: RealmCard(
                      realmId: realms[i].id,
                      title: realms[i].name,
                      subtitle: realms[i].description,
                      progress: ProgressCalculator.realmProgress(
                        levelsByRealm[realms[i].id] ?? const [],
                        profile,
                      ),
                      locked: i > 0 &&
                          !ProgressCalculator.isRealmCompleted(
                            levelsByRealm[realms[i - 1].id] ?? const [],
                            profile,
                          ),
                      onTap: () => context.push('/realm/${realms[i].id.name}'),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
