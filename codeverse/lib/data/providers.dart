import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/badge_definition.dart';
import 'models/level.dart';
import 'models/player_profile.dart';
import 'models/realm.dart';
import 'models/shop_item.dart';
import 'repositories/badge_repository.dart';
import 'repositories/content_repository.dart';
import 'repositories/entitlement_repository.dart';
import 'repositories/player_repository.dart';
import 'repositories/shop_repository.dart';
import '../ui/tokens/app_colors.dart';

final contentRepositoryProvider = Provider<ContentRepository>(
  (ref) => ContentRepository(),
);

final playerRepositoryProvider = Provider<PlayerRepository>(
  (ref) => PlayerRepository(),
);

final entitlementRepositoryProvider = Provider<EntitlementRepository>(
  (ref) => EntitlementRepository(),
);

final shopRepositoryProvider = Provider<ShopRepository>(
  (ref) => ShopRepository(),
);

final badgeRepositoryProvider = Provider<BadgeRepository>(
  (ref) => BadgeRepository(),
);

final shopItemsProvider = Provider<List<ShopItem>>(
  (ref) => ref.read(shopRepositoryProvider).loadItems(),
);

final badgeCatalogProvider = Provider<List<BadgeDefinition>>(
  (ref) => ref.read(badgeRepositoryProvider).loadCatalog(),
);

final realmsProvider = FutureProvider<List<Realm>>((ref) {
  return ref.read(contentRepositoryProvider).loadRealms();
});

final allLevelsProvider = FutureProvider<List<Level>>((ref) {
  return ref.read(contentRepositoryProvider).loadLevels();
});

final levelsForRealmProvider =
    FutureProvider.family<List<Level>, RealmId>((ref, realmId) {
  return ref.read(contentRepositoryProvider).loadLevelsForRealm(realmId);
});

/// Mutates the (mutable, Hive-backed) [PlayerProfile] in place and reassigns
/// [state] to the same instance to notify listeners, then persists it.
/// Simpler than copyWith plumbing since the model already has to support
/// in-place mutation for Hive round-tripping.
class PlayerProfileNotifier extends StateNotifier<PlayerProfile> {
  PlayerProfileNotifier(this._repository) : super(_repository.load());

  final PlayerRepository _repository;

  Future<void> _persist() => _repository.save(state);

  Future<void> setNickname(String nickname) async {
    state.nickname = nickname;
    state = state;
    await _persist();
  }

  /// Records a level result. [stars] only improves the stored best; XP,
  /// coins, and streak always accrue.
  Future<void> completeLevel({
    required String levelId,
    required int stars,
    required int xpReward,
    required int coinsReward,
    String? badgeId,
  }) async {
    final bestStars = state.starsByLevelId[levelId] ?? 0;
    if (stars > bestStars) {
      state.starsByLevelId[levelId] = stars;
    }
    state.xp += xpReward;
    state.coins += coinsReward;
    state.streakCount += 1;
    state.lastPlayedAt = DateTime.now();
    if (badgeId != null && !state.badgeIds.contains(badgeId)) {
      state.badgeIds.add(badgeId);
    }
    state.level = 1 + state.xp ~/ 100;
    state = state;
    await _persist();
  }

  /// Buys a cosmetic if not already owned and affordable, then equips it.
  /// Returns false (no-op) if the player can't afford it or already owns it.
  Future<bool> purchaseItem(ShopItem item) async {
    if (state.ownedItemIds.contains(item.id) || state.coins < item.cost) {
      return false;
    }
    state.coins -= item.cost;
    state.ownedItemIds.add(item.id);
    _equip(item);
    state = state;
    await _persist();
    return true;
  }

  /// Equips an already-owned cosmetic, or the always-owned `default` look.
  Future<void> equipItem(ShopItem item) async {
    if (!state.ownedItemIds.contains(item.id)) return;
    _equip(item);
    state = state;
    await _persist();
  }

  /// Resets a slot back to the free `default` look.
  Future<void> equipDefault(ShopItemCategory category) async {
    switch (category) {
      case ShopItemCategory.avatar:
        state.avatarId = 'default';
      case ShopItemCategory.companion:
        state.companionSkinId = 'default';
    }
    state = state;
    await _persist();
  }

  void _equip(ShopItem item) {
    switch (item.category) {
      case ShopItemCategory.avatar:
        state.avatarId = item.id;
      case ShopItemCategory.companion:
        state.companionSkinId = item.id;
    }
  }
}

final playerProfileProvider =
    StateNotifierProvider<PlayerProfileNotifier, PlayerProfile>((ref) {
  return PlayerProfileNotifier(ref.read(playerRepositoryProvider));
});
