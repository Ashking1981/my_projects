import 'package:flutter_test/flutter_test.dart';

import 'package:codeverse/domain/rank_calculator.dart';

void main() {
  test('starts at Newcomer with 0 XP', () {
    expect(RankCalculator.currentRank(0).title, 'Newcomer');
    expect(RankCalculator.nextRank(0)?.title, 'Apprentice');
  });

  test('promotes once XP crosses a threshold', () {
    expect(RankCalculator.currentRank(99).title, 'Newcomer');
    expect(RankCalculator.currentRank(100).title, 'Apprentice');
  });

  test('caps at the top rank with full progress', () {
    expect(RankCalculator.currentRank(5000).title, 'Legend');
    expect(RankCalculator.nextRank(5000), isNull);
    expect(RankCalculator.progressToNextRank(5000), 1.0);
  });

  test('progress is the fraction between the current and next rank', () {
    // Apprentice starts at 100, Coder at 300 -> halfway is 200.
    expect(RankCalculator.progressToNextRank(200), 0.5);
  });
}
