/// A title tier on the local rank ladder.
class Rank {
  const Rank(this.title, this.minXp);

  final String title;
  final int minXp;
}

/// The app has no accounts or online services, so there is no one to
/// compare against — this is the "local-only leaderboard" from the spec,
/// reimagined as a single-player rank ladder driven entirely by the
/// player's own total XP instead of other players' scores.
class RankCalculator {
  RankCalculator._();

  static const List<Rank> ladder = [
    Rank('Newcomer', 0),
    Rank('Apprentice', 100),
    Rank('Coder', 300),
    Rank('Engineer', 600),
    Rank('Architect', 1000),
    Rank('Legend', 1500),
  ];

  static Rank currentRank(int xp) {
    var result = ladder.first;
    for (final rank in ladder) {
      if (xp >= rank.minXp) result = rank;
    }
    return result;
  }

  /// Null once the player has reached the top of the ladder.
  static Rank? nextRank(int xp) {
    for (final rank in ladder) {
      if (xp < rank.minXp) return rank;
    }
    return null;
  }

  /// 0.0-1.0 progress toward [nextRank]; 1.0 if already at the top rank.
  static double progressToNextRank(int xp) {
    final current = currentRank(xp);
    final next = nextRank(xp);
    if (next == null) return 1.0;
    return (xp - current.minXp) / (next.minXp - current.minXp);
  }
}
