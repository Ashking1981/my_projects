import 'package:flutter/material.dart';

import '../models/badge_definition.dart';

/// Catalog of all known badge ids. Add an entry here whenever a level's
/// `reward.badgeId` introduces a new id.
class BadgeRepository {
  List<BadgeDefinition> loadCatalog() => _catalog;

  /// Falls back to a generic "Achievement" look for any id not (yet)
  /// catalogued here, so unrecognized future content never crashes the UI.
  BadgeDefinition definitionFor(String id) {
    for (final badge in _catalog) {
      if (badge.id == id) return badge;
    }
    return BadgeDefinition(
      id: id,
      name: 'Achievement',
      description: 'A special milestone.',
      icon: Icons.military_tech_rounded,
    );
  }

  static const List<BadgeDefinition> _catalog = [
    BadgeDefinition(
      id: 'first_function',
      name: 'First Function',
      description: 'Wrote your first Python function.',
      icon: Icons.functions_rounded,
    ),
  ];
}
