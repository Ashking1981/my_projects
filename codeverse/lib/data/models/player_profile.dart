import 'package:hive/hive.dart';

/// All of a player's persisted progress. Lives in a single Hive box keyed
/// by a fixed id since this app has exactly one local player profile.
class PlayerProfile {
  PlayerProfile({
    this.nickname = '',
    this.avatarId = 'default',
    this.companionSkinId = 'default',
    this.xp = 0,
    this.level = 1,
    this.coins = 0,
    this.streakCount = 0,
    this.lastPlayedAt,
    Map<String, int>? starsByLevelId,
    List<String>? ownedItemIds,
    List<String>? badgeIds,
  })  : starsByLevelId = starsByLevelId ?? {},
        ownedItemIds = ownedItemIds ?? [],
        badgeIds = badgeIds ?? [];

  String nickname;
  String avatarId;
  String companionSkinId;
  int xp;
  int level;
  int coins;
  int streakCount;
  DateTime? lastPlayedAt;

  /// Best star result (1–3) per completed level id.
  final Map<String, int> starsByLevelId;
  final List<String> ownedItemIds;
  final List<String> badgeIds;

  bool isLevelCompleted(String levelId) => starsByLevelId.containsKey(levelId);
}

class PlayerProfileAdapter extends TypeAdapter<PlayerProfile> {
  @override
  final int typeId = 0;

  @override
  PlayerProfile read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };
    return PlayerProfile(
      nickname: fields[0] as String? ?? '',
      avatarId: fields[1] as String? ?? 'default',
      companionSkinId: fields[2] as String? ?? 'default',
      xp: fields[3] as int? ?? 0,
      level: fields[4] as int? ?? 1,
      coins: fields[5] as int? ?? 0,
      streakCount: fields[6] as int? ?? 0,
      lastPlayedAt: fields[7] as DateTime?,
      starsByLevelId:
          (fields[8] as Map?)?.cast<String, int>() ?? <String, int>{},
      ownedItemIds: (fields[9] as List?)?.cast<String>() ?? <String>[],
      badgeIds: (fields[10] as List?)?.cast<String>() ?? <String>[],
    );
  }

  @override
  void write(BinaryWriter writer, PlayerProfile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.nickname)
      ..writeByte(1)
      ..write(obj.avatarId)
      ..writeByte(2)
      ..write(obj.companionSkinId)
      ..writeByte(3)
      ..write(obj.xp)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.coins)
      ..writeByte(6)
      ..write(obj.streakCount)
      ..writeByte(7)
      ..write(obj.lastPlayedAt)
      ..writeByte(8)
      ..write(obj.starsByLevelId)
      ..writeByte(9)
      ..write(obj.ownedItemIds)
      ..writeByte(10)
      ..write(obj.badgeIds);
  }
}
