import 'package:flutter/material.dart';

/// What slot a [ShopItem] fills on the player's profile.
enum ShopItemCategory { avatar, companion }

/// A cosmetic the player can buy with coins earned from completing levels.
/// Plain Dart catalog data (not JSON) since this is product catalog, not
/// educational content — no art assets are bundled yet, so each item is
/// rendered as a colored glyph rather than an image.
class ShopItem {
  const ShopItem({
    required this.id,
    required this.name,
    required this.category,
    required this.cost,
    required this.color,
    required this.icon,
  });

  final String id;
  final String name;
  final ShopItemCategory category;
  final int cost;
  final Color color;
  final IconData icon;
}
