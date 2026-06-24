import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers.dart';
import '../../../domain/rank_calculator.dart';
import '../../../ui/ui.dart';
import '../../parent/application/parental_gate.dart';

/// Hub for everything gamification-related that isn't part of the core
/// learning loop: streak, rank, and links to Badges/Shop.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final rank = RankCalculator.currentRank(profile.xp);

    return Scaffold(
      appBar: AppBar(title: Text(profile.nickname)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CoinBadge(amount: profile.coins),
              StreakBadge(streakCount: profile.streakCount),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: XpBar(
              level: profile.level,
              currentXp: profile.xp % 100,
              xpForNextLevel: 100,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shield_rounded,
                color: AppColors.brandPrimary),
            title: const Text('Rank Ladder'),
            subtitle: Text(rank.title),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/leaderboard'),
          ),
          ListTile(
            leading:
                const Icon(Icons.military_tech_rounded, color: AppColors.star),
            title: const Text('Badges'),
            subtitle: Text('${profile.badgeIds.length} earned'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/badges'),
          ),
          ListTile(
            leading:
                const Icon(Icons.storefront_rounded, color: AppColors.coin),
            title: const Text('Shop'),
            subtitle: const Text('Spend coins on cosmetics'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/shop'),
          ),
          ListTile(
            leading:
                const Icon(Icons.family_restroom_rounded, color: AppColors.brandSecondary),
            title: const Text('Parent Dashboard'),
            subtitle: const Text('Progress, PRO status, accessibility'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () async {
              if (await requireParentalGate(context)) {
                if (context.mounted) context.push('/parent-dashboard');
              }
            },
          ),
        ],
      ),
    );
  }
}
