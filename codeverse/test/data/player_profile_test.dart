import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:codeverse/data/models/player_profile.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PlayerProfileAdapter());
    }
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('PlayerProfile survives a Hive write/read round-trip', () async {
    final box = await Hive.openBox<PlayerProfile>('test_player_box');
    final profile = PlayerProfile(
      nickname: 'Nova',
      xp: 150,
      level: 3,
      coins: 80,
      streakCount: 5,
      starsByLevelId: {'py-01': 3, 'py-02': 2},
      ownedItemIds: ['hat_red'],
      badgeIds: ['first_function'],
    );

    await box.put('current', profile);
    final loaded = box.get('current')!;

    expect(loaded.nickname, 'Nova');
    expect(loaded.xp, 150);
    expect(loaded.level, 3);
    expect(loaded.coins, 80);
    expect(loaded.streakCount, 5);
    expect(loaded.starsByLevelId, {'py-01': 3, 'py-02': 2});
    expect(loaded.ownedItemIds, ['hat_red']);
    expect(loaded.badgeIds, ['first_function']);
    expect(loaded.isLevelCompleted('py-01'), isTrue);
    expect(loaded.isLevelCompleted('py-99'), isFalse);
  });

  test('defaults to a fresh profile when none stored', () {
    final profile = PlayerProfile();
    expect(profile.xp, 0);
    expect(profile.level, 1);
    expect(profile.starsByLevelId, isEmpty);
  });
}
