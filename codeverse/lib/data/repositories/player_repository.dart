import 'package:hive/hive.dart';

import '../local/hive_setup.dart';
import '../models/player_profile.dart';

/// Single fixed key since the app supports exactly one local player.
const String _playerKey = 'current';

/// Reads/writes the player's progress in Hive, defaulting to a fresh
/// profile when none exists yet.
class PlayerRepository {
  Box<PlayerProfile> get _box => Hive.box<PlayerProfile>(HiveBoxes.player);

  PlayerProfile load() => _box.get(_playerKey) ?? PlayerProfile();

  Future<void> save(PlayerProfile profile) => _box.put(_playerKey, profile);
}
