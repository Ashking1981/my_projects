import 'package:flutter/material.dart';

/// Identifies a Realm for theming purposes only. The full domain model
/// (with mentor, description, levels, etc.) is defined in the data layer.
enum RealmId { pythonPeaks, gameForge, pixelStudio, dataDelta, mindMachine }

/// Centralized color tokens. Never hardcode a color outside this file —
/// reference [AppColors] or [RealmPalette] instead.
class AppColors {
  AppColors._();

  // Brand
  static const Color brandPrimary = Color(0xFF6C4CF1);
  static const Color brandSecondary = Color(0xFFFF8A65);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color danger = Color(0xFFEF5350);
  static const Color coin = Color(0xFFFFC542);
  static const Color star = Color(0xFFFFD54F);

  // Light theme neutrals
  static const Color lightBackground = Color(0xFFF7F6FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1E1B2E);

  // Dark theme neutrals
  static const Color darkBackground = Color(0xFF13111C);
  static const Color darkSurface = Color(0xFF1E1B2E);
  static const Color darkOnSurface = Color(0xFFF1EFFA);

  static const Color lockedOverlay = Color(0x991E1B2E);
}

/// Per-Realm gradient + accent used by RealmCard, LevelNode, map backgrounds.
class RealmPalette {
  const RealmPalette({
    required this.gradient,
    required this.accent,
  });

  final List<Color> gradient;
  final Color accent;

  static const Map<RealmId, RealmPalette> values = {
    RealmId.pythonPeaks: RealmPalette(
      gradient: [Color(0xFF2E7D32), Color(0xFF81C784)],
      accent: Color(0xFF2E7D32),
    ),
    RealmId.gameForge: RealmPalette(
      gradient: [Color(0xFFE65100), Color(0xFFFFB74D)],
      accent: Color(0xFFE65100),
    ),
    RealmId.pixelStudio: RealmPalette(
      gradient: [Color(0xFFAD1457), Color(0xFFF06292)],
      accent: Color(0xFFAD1457),
    ),
    RealmId.dataDelta: RealmPalette(
      gradient: [Color(0xFF0277BD), Color(0xFF4FC3F7)],
      accent: Color(0xFF0277BD),
    ),
    RealmId.mindMachine: RealmPalette(
      gradient: [Color(0xFF4527A0), Color(0xFF9575CD)],
      accent: Color(0xFF4527A0),
    ),
  };

  static RealmPalette of(RealmId id) => values[id]!;
}
