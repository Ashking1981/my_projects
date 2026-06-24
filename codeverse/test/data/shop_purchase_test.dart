import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:codeverse/data/local/hive_setup.dart';
import 'package:codeverse/data/models/player_profile.dart';
import 'package:codeverse/data/models/shop_item.dart';
import 'package:codeverse/data/providers.dart';
import 'package:codeverse/data/repositories/player_repository.dart';

const _avatar = ShopItem(
  id: 'avatar_comet',
  name: 'Comet',
  category: ShopItemCategory.avatar,
  cost: 50,
  color: Color(0xFF000000),
  icon: Icons.rocket_launch_rounded,
);

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PlayerProfileAdapter());
    }
    await Hive.openBox<PlayerProfile>(HiveBoxes.player);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('purchaseItem fails when the player cannot afford it', () async {
    final notifier = PlayerProfileNotifier(PlayerRepository());
    final bought = await notifier.purchaseItem(_avatar);

    expect(bought, isFalse);
    expect(notifier.state.coins, 0);
    expect(notifier.state.ownedItemIds, isEmpty);
  });

  test('purchaseItem deducts coins, owns, and equips the item', () async {
    final notifier = PlayerProfileNotifier(PlayerRepository());
    notifier.state.coins = 100;

    final bought = await notifier.purchaseItem(_avatar);

    expect(bought, isTrue);
    expect(notifier.state.coins, 50);
    expect(notifier.state.ownedItemIds, contains('avatar_comet'));
    expect(notifier.state.avatarId, 'avatar_comet');
  });

  test('purchaseItem refuses to charge twice for an owned item', () async {
    final notifier = PlayerProfileNotifier(PlayerRepository());
    notifier.state.coins = 100;
    await notifier.purchaseItem(_avatar);

    final boughtAgain = await notifier.purchaseItem(_avatar);

    expect(boughtAgain, isFalse);
    expect(notifier.state.coins, 50);
  });

  test('equipDefault resets the avatar slot to default', () async {
    final notifier = PlayerProfileNotifier(PlayerRepository());
    notifier.state.coins = 100;
    await notifier.purchaseItem(_avatar);

    await notifier.equipDefault(ShopItemCategory.avatar);

    expect(notifier.state.avatarId, 'default');
  });
}
