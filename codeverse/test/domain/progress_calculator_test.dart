import 'package:flutter_test/flutter_test.dart';

import 'package:codeverse/data/models/challenge.dart';
import 'package:codeverse/data/models/concept_data.dart';
import 'package:codeverse/data/models/level.dart';
import 'package:codeverse/data/models/player_profile.dart';
import 'package:codeverse/data/models/playground_data.dart';
import 'package:codeverse/data/models/reward_data.dart';
import 'package:codeverse/domain/progress_calculator.dart';
import 'package:codeverse/ui/tokens/app_colors.dart';

Level _level(String id, int order) => Level(
      id: id,
      realmId: RealmId.pythonPeaks,
      order: order,
      title: id,
      isBoss: false,
      story: const [],
      concept: const ConceptData(title: 't', explanation: 'e'),
      playground: const PlaygroundData(type: 'p', instructions: 'i'),
      challenge: const MultipleChoiceChallenge(
        prompt: 'p',
        options: ['a', 'b'],
        correctIndex: 0,
      ),
      reward: const RewardData(xp: 10, coins: 5),
    );

void main() {
  final levels = [_level('l1', 1), _level('l2', 2), _level('l3', 3)];

  test('first level is always unlocked', () {
    final profile = PlayerProfile();
    expect(
      ProgressCalculator.isLevelUnlocked(
        levelsInRealm: levels,
        index: 0,
        profile: profile,
      ),
      isTrue,
    );
  });

  test('later level is locked until the previous one is completed', () {
    final profile = PlayerProfile();
    expect(
      ProgressCalculator.isLevelUnlocked(
        levelsInRealm: levels,
        index: 1,
        profile: profile,
      ),
      isFalse,
    );

    profile.starsByLevelId['l1'] = 3;
    expect(
      ProgressCalculator.isLevelUnlocked(
        levelsInRealm: levels,
        index: 1,
        profile: profile,
      ),
      isTrue,
    );
  });

  test('realm is completed only once every level has stars', () {
    final profile = PlayerProfile();
    expect(ProgressCalculator.isRealmCompleted(levels, profile), isFalse);

    for (final level in levels) {
      profile.starsByLevelId[level.id] = 3;
    }
    expect(ProgressCalculator.isRealmCompleted(levels, profile), isTrue);
  });

  test('realm progress is the completed fraction', () {
    final profile = PlayerProfile()..starsByLevelId['l1'] = 1;
    expect(ProgressCalculator.realmProgress(levels, profile), closeTo(1 / 3, 0.001));
  });
}
