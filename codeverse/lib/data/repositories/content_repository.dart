import 'dart:convert';

import 'package:flutter/services.dart';

import '../../ui/tokens/app_colors.dart';
import '../models/level.dart';
import '../models/realm.dart';

/// Loads the bundled, versioned JSON content under assets/content/ and
/// parses it into typed models. Adding a new level is purely a content
/// change: drop JSON into assets/content/, list it in [_levelAssetPaths],
/// and declare the asset in pubspec.yaml — no Dart code changes needed.
class ContentRepository {
  static const String _realmsAssetPath = 'assets/content/realms.json';

  static const List<String> _levelAssetPaths = [
    'assets/content/levels_python_peaks.json',
    'assets/content/levels_game_forge.json',
    'assets/content/levels_pixel_studio.json',
    'assets/content/levels_data_delta.json',
    'assets/content/levels_mind_machine.json',
  ];

  Future<List<Realm>> loadRealms() async {
    final raw = await rootBundle.loadString(_realmsAssetPath);
    final list = jsonDecode(raw) as List;
    final realms = list
        .map((e) => Realm.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return realms;
  }

  Future<List<Level>> loadLevels() async {
    final levels = <Level>[];
    for (final path in _levelAssetPaths) {
      final raw = await rootBundle.loadString(path);
      final list = jsonDecode(raw) as List;
      levels.addAll(
        list.map((e) => Level.fromJson(e as Map<String, dynamic>)),
      );
    }
    levels.sort((a, b) => a.order.compareTo(b.order));
    return levels;
  }

  Future<List<Level>> loadLevelsForRealm(RealmId realmId) async {
    final all = await loadLevels();
    return all.where((l) => l.realmId == realmId).toList();
  }
}
