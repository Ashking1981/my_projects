import '../data/models/level.dart';
import '../data/models/player_profile.dart';

/// Pure functions over [Level]s + [PlayerProfile] that decide what's locked.
/// No widget or storage knowledge — keeps lock rules testable in isolation.
class ProgressCalculator {
  ProgressCalculator._();

  static bool isLevelUnlocked({
    required List<Level> levelsInRealm,
    required int index,
    required PlayerProfile profile,
  }) {
    if (index == 0) return true;
    return profile.isLevelCompleted(levelsInRealm[index - 1].id);
  }

  static bool isRealmCompleted(
    List<Level> levelsInRealm,
    PlayerProfile profile,
  ) {
    if (levelsInRealm.isEmpty) return false;
    return levelsInRealm.every((l) => profile.isLevelCompleted(l.id));
  }

  static double realmProgress(
    List<Level> levelsInRealm,
    PlayerProfile profile,
  ) {
    if (levelsInRealm.isEmpty) return 0;
    final completed =
        levelsInRealm.where((l) => profile.isLevelCompleted(l.id)).length;
    return completed / levelsInRealm.length;
  }
}
