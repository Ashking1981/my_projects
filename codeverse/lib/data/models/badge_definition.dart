import 'package:flutter/material.dart';

/// Static metadata (name/description/icon) for a badge id that can appear
/// in [PlayerProfile.badgeIds]. Badge ids themselves come from level reward
/// JSON (`reward.badgeId`); this catalog is the only place that needs
/// updating when a new badge id is introduced in content.
class BadgeDefinition {
  const BadgeDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
}
