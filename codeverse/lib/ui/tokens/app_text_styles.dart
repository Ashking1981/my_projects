import 'package:flutter/material.dart';

/// Font family names. Actual font files are not bundled yet — drop matching
/// .ttf files under assets/fonts/ and register them in pubspec.yaml to
/// activate; until then Flutter silently falls back to the platform font.
class AppFontFamilies {
  AppFontFamilies._();

  static const String display = 'Baloo2';
  static const String body = 'Inter';
  static const String dyslexiaFriendly = 'OpenDyslexic';
}

/// Centralized text styles. Compose new styles here rather than inlining
/// fontSize/fontWeight in widgets.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle display({String? fontFamily}) => TextStyle(
        fontFamily: fontFamily ?? AppFontFamilies.display,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle heading({String? fontFamily}) => TextStyle(
        fontFamily: fontFamily ?? AppFontFamilies.display,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle subheading({String? fontFamily}) => TextStyle(
        fontFamily: fontFamily ?? AppFontFamilies.display,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle body({String? fontFamily}) => TextStyle(
        fontFamily: fontFamily ?? AppFontFamilies.body,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle bodyStrong({String? fontFamily}) => TextStyle(
        fontFamily: fontFamily ?? AppFontFamilies.body,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  static TextStyle caption({String? fontFamily}) => TextStyle(
        fontFamily: fontFamily ?? AppFontFamilies.body,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );
}
