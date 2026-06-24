import 'package:flutter/material.dart';

import '../../ui/ui.dart';

/// Visual QA gallery for every reusable design-system widget.
/// Not part of the shipped player-facing app; reachable at /dev/components.
class ComponentsGalleryScreen extends StatelessWidget {
  const ComponentsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Component Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _Section(
            title: 'PrimaryButton',
            child: Wrap(
              spacing: AppSpacing.sm,
              children: [
                PrimaryButton(label: 'Start Lesson', onPressed: () {}),
                const PrimaryButton(
                  label: 'Locked',
                  icon: Icons.lock_rounded,
                  onPressed: null,
                ),
              ],
            ),
          ),
          _Section(
            title: 'RealmCard',
            child: SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final id in RealmId.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: SizedBox(
                        width: 200,
                        child: RealmCard(
                          realmId: id,
                          title: id.name,
                          subtitle: '3 / 10 levels',
                          progress: 0.3,
                          locked: id == RealmId.mindMachine,
                          onTap: () {},
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const _Section(
            title: 'LevelNode',
            child: Wrap(
              spacing: AppSpacing.md,
              children: [
                LevelNode(
                  label: 'Lvl 1',
                  status: LevelNodeStatus.completed,
                  realmId: RealmId.pythonPeaks,
                  stars: 3,
                ),
                LevelNode(
                  label: 'Lvl 2',
                  status: LevelNodeStatus.unlocked,
                  realmId: RealmId.pythonPeaks,
                ),
                LevelNode(
                  label: 'Lvl 3',
                  status: LevelNodeStatus.locked,
                  realmId: RealmId.pythonPeaks,
                ),
                LevelNode(
                  label: 'Boss',
                  status: LevelNodeStatus.unlocked,
                  realmId: RealmId.pythonPeaks,
                  isBoss: true,
                ),
              ],
            ),
          ),
          const _Section(title: 'StarRating', child: StarRating(stars: 2)),
          const _Section(
            title: 'XpBar',
            child: XpBar(level: 4, currentXp: 60, xpForNextLevel: 100),
          ),
          const _Section(title: 'CoinBadge', child: CoinBadge(amount: 240)),
          const _Section(
            title: 'MascotBubble',
            child: MascotBubble(
              speakerName: 'Pixel',
              message: "Let's build your first function together!",
            ),
          ),
          const _Section(
            title: 'ConceptCard',
            child: ConceptCard(
              title: 'Variables',
              explanation: 'A variable stores a value you can reuse.',
              example: 'score = 10',
            ),
          ),
          _Section(
            title: 'LockOverlay',
            child: SizedBox(
              width: 120,
              height: 80,
              child: Stack(
                children: [
                  Container(color: Colors.blueGrey),
                  const LockOverlay(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}
