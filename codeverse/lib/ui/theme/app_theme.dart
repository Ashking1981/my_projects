import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_text_styles.dart';

/// Builds the light and dark [ThemeData] used by the app. Both themes pull
/// exclusively from AppColors/AppTextStyles/AppSpacing tokens.
class AppTheme {
  AppTheme._();

  static ThemeData light({String? fontFamilyOverride}) => _build(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        fontFamilyOverride: fontFamilyOverride,
      );

  static ThemeData dark({String? fontFamilyOverride}) => _build(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        fontFamilyOverride: fontFamilyOverride,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
    String? fontFamilyOverride,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brandPrimary,
      brightness: brightness,
      surface: surface,
      onSurface: onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayMedium: AppTextStyles.display(fontFamily: fontFamilyOverride)
            .copyWith(color: onSurface),
        headlineMedium: AppTextStyles.heading(fontFamily: fontFamilyOverride)
            .copyWith(color: onSurface),
        titleMedium: AppTextStyles.subheading(fontFamily: fontFamilyOverride)
            .copyWith(color: onSurface),
        bodyLarge: AppTextStyles.body(fontFamily: fontFamilyOverride)
            .copyWith(color: onSurface),
        bodyMedium: AppTextStyles.body(fontFamily: fontFamilyOverride)
            .copyWith(color: onSurface),
        labelLarge: AppTextStyles.bodyStrong(fontFamily: fontFamilyOverride)
            .copyWith(color: onSurface),
        bodySmall: AppTextStyles.caption(fontFamily: fontFamilyOverride)
            .copyWith(color: onSurface.withOpacity(0.7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          textStyle: AppTextStyles.bodyStrong(fontFamily: fontFamilyOverride),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: AppElevation.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading(fontFamily: fontFamilyOverride)
            .copyWith(color: onSurface),
      ),
    );
  }
}
