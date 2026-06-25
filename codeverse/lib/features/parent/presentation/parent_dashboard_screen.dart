import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers.dart';
import '../../../domain/progress_calculator.dart';
import '../../../ui/ui.dart';
import 'privacy_policy_screen.dart';

/// Parent-facing overview: child's progress, PRO status, the
/// dyslexia-friendly font toggle, and a link to the privacy policy.
/// Entry is gated by [requireParentalGate] at the call site (the
/// `ProfileScreen` tile), not here, so this screen itself stays simple.
class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final entitlement = ref.watch(entitlementProvider);
    final realmsAsync = ref.watch(realmsProvider);
    final levelsAsync = ref.watch(allLevelsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Player', style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            leading: const Icon(Icons.person_rounded),
            title: Text(profile.nickname),
            subtitle: Text(
              'Level ${profile.level} · ${profile.xp} XP · '
              '${profile.streakCount}-day streak',
            ),
          ),
          const Divider(),
          Text('Progress', style: Theme.of(context).textTheme.titleMedium),
          realmsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Failed to load realms: $err'),
            data: (realms) => levelsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Failed to load levels: $err'),
              data: (allLevels) => Column(
                children: [
                  for (final realm in realms)
                    ListTile(
                      title: Text(realm.name),
                      subtitle: LinearProgressIndicator(
                        value: ProgressCalculator.realmProgress(
                          allLevels
                              .where((l) => l.realmId == realm.id)
                              .toList(),
                          profile,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Divider(),
          Text('PRO status', style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            leading: Icon(
              entitlement.isPro ? Icons.verified_rounded : Icons.lock_rounded,
              color: entitlement.isPro ? AppColors.success : Colors.grey,
            ),
            title: Text(entitlement.isPro ? 'PRO unlocked' : 'Free plan'),
            trailing: entitlement.isPro
                ? null
                : TextButton(
                    onPressed: () => context.push('/paywall'),
                    child: const Text('Upgrade'),
                  ),
          ),
          const Divider(),
          Text('Accessibility', style: Theme.of(context).textTheme.titleMedium),
          SwitchListTile(
            title: const Text('Dyslexia-friendly font'),
            subtitle: const Text('Switches body text to an easier-to-read font'),
            value: profile.dyslexiaFontEnabled,
            onChanged: (value) {
              ref.read(playerProfileProvider.notifier).setDyslexiaFont(value);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_rounded),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
