import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../ui/ui.dart';

/// Every catalogued badge, greyed out until earned via a level's
/// `reward.badgeId`.
class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final catalog = ref.watch(badgeCatalogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Badges')),
      body: catalog.isEmpty
          ? const Center(child: Text('No badges yet.'))
          : GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.9,
              ),
              itemCount: catalog.length,
              itemBuilder: (context, index) {
                final badge = catalog[index];
                final earned = profile.badgeIds.contains(badge.id);
                return Card(
                  elevation: AppElevation.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: earned
                              ? AppColors.star.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.15),
                          child: Icon(
                            badge.icon,
                            size: 32,
                            color: earned ? AppColors.star : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          badge.name,
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          badge.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
