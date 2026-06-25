import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../domain/rank_calculator.dart';
import '../../../ui/ui.dart';

/// No accounts or online services exist in this app, so there's no one to
/// rank against — this is the spec's "local-only leaderboard" reimagined
/// as a single-player rank ladder driven by the player's own total XP.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final current = RankCalculator.currentRank(profile.xp);
    final next = RankCalculator.nextRank(profile.xp);
    final progress = RankCalculator.progressToNextRank(profile.xp);

    return Scaffold(
      appBar: AppBar(title: const Text('Rank Ladder')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            elevation: AppElevation.card,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You are a', style: Theme.of(context).textTheme.bodyMedium),
                  Text(current.title,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.brandPrimary),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    next == null
                        ? 'Top rank reached!'
                        : '${profile.xp} / ${next.minXp} XP to ${next.title}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final rank in RankCalculator.ladder)
            ListTile(
              leading: Icon(
                Icons.shield_rounded,
                color: profile.xp >= rank.minXp
                    ? AppColors.brandPrimary
                    : Colors.grey,
              ),
              title: Text(rank.title),
              subtitle: Text('${rank.minXp}+ XP'),
              trailing: rank.title == current.title
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppColors.success)
                  : null,
            ),
        ],
      ),
    );
  }
}
