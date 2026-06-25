import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/level.dart';
import '../../../data/providers.dart';
import '../../../ui/ui.dart';
import 'challenge_answer_widget.dart';
import 'playground_widget.dart';

enum _LevelStep { story, concept, playground, challenge, reward }

/// The fixed core learning loop for one Level:
/// Story Scene -> Concept Card -> Playground -> Challenge -> Reward.
class LevelPlayerScreen extends ConsumerStatefulWidget {
  const LevelPlayerScreen({super.key, required this.levelId});

  final String levelId;

  @override
  ConsumerState<LevelPlayerScreen> createState() => _LevelPlayerScreenState();
}

class _LevelPlayerScreenState extends ConsumerState<LevelPlayerScreen> {
  _LevelStep _step = _LevelStep.story;
  int _storyPanelIndex = 0;
  Object? _challengeResponse;
  bool _challengeFailedOnce = false;

  @override
  Widget build(BuildContext context) {
    final levelsAsync = ref.watch(allLevelsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Level')),
      body: levelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load level: $err')),
        data: (allLevels) {
          Level? level;
          for (final candidate in allLevels) {
            if (candidate.id == widget.levelId) {
              level = candidate;
              break;
            }
          }
          if (level == null) {
            return const Center(child: Text('Level not found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: KeyedSubtree(
              key: ValueKey(_step),
              child: switch (_step) {
                    _LevelStep.story => _buildStory(level),
                    _LevelStep.concept => _buildConcept(level),
                    _LevelStep.playground => _buildPlayground(level),
                    _LevelStep.challenge => _buildChallenge(level),
                    _LevelStep.reward => _buildReward(level),
                  }
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 250))
                  .slideY(begin: 0.05, end: 0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStory(Level level) {
    final panel = level.story[_storyPanelIndex];
    final isLastPanel = _storyPanelIndex == level.story.length - 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: StoryPanel(
            speakerName: panel.speaker,
            message: panel.message,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: isLastPanel ? 'Continue' : 'Next',
          onPressed: () {
            setState(() {
              if (isLastPanel) {
                _step = _LevelStep.concept;
              } else {
                _storyPanelIndex++;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildConcept(Level level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ConceptCard(
            title: level.concept.title,
            explanation: level.concept.explanation,
            example: level.concept.example,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: 'Try it out',
          onPressed: () => setState(() => _step = _LevelStep.playground),
        ),
      ],
    );
  }

  Widget _buildPlayground(Level level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Playground', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: PlaygroundWidget(playground: level.playground),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: 'I\'m ready for the challenge',
          onPressed: () => setState(() => _step = _LevelStep.challenge),
        ),
      ],
    );
  }

  Widget _buildChallenge(Level level) {
    return ChallengeShell(
      prompt: level.challenge.prompt,
      isBoss: level.isBoss,
      canSubmit: _challengeResponse != null,
      content: ChallengeAnswerWidget(
        challenge: level.challenge,
        onChanged: (response) =>
            setState(() => _challengeResponse = response),
      ),
      onSubmit: () {
        final correct = level.challenge.isCorrect(_challengeResponse);
        if (correct) {
          final stars = _challengeFailedOnce ? 2 : 3;
          ref.read(playerProfileProvider.notifier).completeLevel(
                levelId: level.id,
                stars: stars,
                xpReward: level.reward.xp,
                coinsReward: level.reward.coins,
                badgeId: level.reward.badgeId,
              );
          setState(() => _step = _LevelStep.reward);
        } else {
          _challengeFailedOnce = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Not quite — try again!')),
          );
        }
      },
    );
  }

  Widget _buildReward(Level level) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 72)
            .animate()
            .scale(
              begin: const Offset(0.4, 0.4),
              end: const Offset(1, 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
            )
            .then()
            .shake(hz: 2, duration: const Duration(milliseconds: 400)),
        const SizedBox(height: AppSpacing.md),
        Text('Level complete!', style: Theme.of(context).textTheme.titleLarge)
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 200)),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CoinBadge(amount: level.reward.coins),
            const SizedBox(width: AppSpacing.sm),
            Text('+${level.reward.xp} XP'),
          ],
        ).animate().fadeIn(delay: const Duration(milliseconds: 350)).slideY(
              begin: 0.2,
              end: 0,
            ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Back to Realm',
          onPressed: () => context.go('/realm/${level.realmId.name}'),
        ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
      ],
    );
  }
}
