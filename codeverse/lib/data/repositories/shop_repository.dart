import 'package:flutter/material.dart';

import '../models/shop_item.dart';

/// Fixed cosmetics catalog. `default` avatar/companion are free and owned
/// from the start (see [PlayerProfile]'s default field values), so they're
/// intentionally not listed here.
class ShopRepository {
  List<ShopItem> loadItems() => _items;

  static const List<ShopItem> _items = [
    ShopItem(
      id: 'avatar_comet',
      name: 'Comet',
      category: ShopItemCategory.avatar,
      cost: 50,
      color: Color(0xFF6C4CF1),
      icon: Icons.rocket_launch_rounded,
    ),
    ShopItem(
      id: 'avatar_pixel',
      name: 'Pixel',
      category: ShopItemCategory.avatar,
      cost: 75,
      color: Color(0xFFAD1457),
      icon: Icons.grid_view_rounded,
    ),
    ShopItem(
      id: 'avatar_byte',
      name: 'Byte',
      category: ShopItemCategory.avatar,
      cost: 100,
      color: Color(0xFF0277BD),
      icon: Icons.memory_rounded,
    ),
    ShopItem(
      id: 'avatar_nova',
      name: 'Nova',
      category: ShopItemCategory.avatar,
      cost: 150,
      color: Color(0xFFE65100),
      icon: Icons.auto_awesome_rounded,
    ),
    ShopItem(
      id: 'avatar_legend',
      name: 'Legend',
      category: ShopItemCategory.avatar,
      cost: 300,
      color: Color(0xFFFFC542),
      icon: Icons.workspace_premium_rounded,
    ),
    ShopItem(
      id: 'companion_spark',
      name: 'Spark',
      category: ShopItemCategory.companion,
      cost: 60,
      color: Color(0xFFFFC107),
      icon: Icons.bolt_rounded,
    ),
    ShopItem(
      id: 'companion_pip',
      name: 'Pip',
      category: ShopItemCategory.companion,
      cost: 90,
      color: Color(0xFF4CAF50),
      icon: Icons.pets_rounded,
    ),
    ShopItem(
      id: 'companion_glitch',
      name: 'Glitch',
      category: ShopItemCategory.companion,
      cost: 120,
      color: Color(0xFF4527A0),
      icon: Icons.blur_on_rounded,
    ),
    ShopItem(
      id: 'companion_orbit',
      name: 'Orbit',
      category: ShopItemCategory.companion,
      cost: 200,
      color: Color(0xFF81C784),
      icon: Icons.public_rounded,
    ),
  ];
}
