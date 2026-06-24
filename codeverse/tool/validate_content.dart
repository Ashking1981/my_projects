// Standalone validator for assets/content/*.json — run with:
//   dart run tool/validate_content.dart
// Deliberately has zero Flutter dependency so it can run without a device
// or the Flutter SDK's UI bindings; only dart:io and dart:convert.
import 'dart:convert';
import 'dart:io';

const _validRealmIds = {
  'pythonPeaks',
  'gameForge',
  'pixelStudio',
  'dataDelta',
  'mindMachine',
};

const _validChallengeTypes = {
  'multiple_choice',
  'drag_to_order',
  'fill_blank',
  'match_pairs',
  'block_code',
};

final _errors = <String>[];

void _fail(String context, String message) {
  _errors.add('[$context] $message');
}

void _requireKeys(
  Map<String, dynamic> json,
  List<String> keys,
  String context,
) {
  for (final key in keys) {
    if (!json.containsKey(key)) {
      _fail(context, 'missing required key "$key"');
    }
  }
}

void _validateChallenge(Map<String, dynamic> json, String context) {
  final type = json['type'];
  if (type is! String || !_validChallengeTypes.contains(type)) {
    _fail(context, 'unknown or missing challenge type: $type');
    return;
  }
  _requireKeys(json, ['prompt'], context);

  switch (type) {
    case 'multiple_choice':
      _requireKeys(json, ['options', 'correctIndex'], context);
      final options = json['options'];
      final correctIndex = json['correctIndex'];
      if (options is List && correctIndex is int) {
        if (correctIndex < 0 || correctIndex >= options.length) {
          _fail(context, 'correctIndex out of range');
        }
      }
    case 'drag_to_order':
      _requireKeys(json, ['correctOrder'], context);
      final order = json['correctOrder'];
      if (order is List && order.length < 2) {
        _fail(context, 'correctOrder needs at least 2 items');
      }
    case 'fill_blank':
      _requireKeys(json, ['template', 'answer'], context);
      final template = json['template'];
      if (template is String && !template.contains('___')) {
        _fail(context, 'fill_blank template must contain a ___ placeholder');
      }
    case 'match_pairs':
      _requireKeys(json, ['pairs'], context);
      final pairs = json['pairs'];
      if (pairs is Map && pairs.isEmpty) {
        _fail(context, 'match_pairs must have at least one pair');
      }
    case 'block_code':
      _requireKeys(json, ['correctBlocks'], context);
      final blocks = json['correctBlocks'];
      if (blocks is List && blocks.isEmpty) {
        _fail(context, 'block_code needs at least one correct block');
      }
  }
}

void _validateLevel(Map<String, dynamic> json, String context) {
  _requireKeys(json, [
    'id',
    'realmId',
    'order',
    'title',
    'story',
    'concept',
    'playground',
    'challenge',
    'reward',
  ], context);

  final realmId = json['realmId'];
  if (realmId is String && !_validRealmIds.contains(realmId)) {
    _fail(context, 'unknown realmId: $realmId');
  }

  final story = json['story'];
  if (story is List && story.isEmpty) {
    _fail(context, 'story must have at least one panel');
  } else if (story is List) {
    for (var i = 0; i < story.length; i++) {
      final panel = story[i];
      if (panel is Map<String, dynamic>) {
        _requireKeys(panel, ['speaker', 'message'], '$context/story[$i]');
      } else {
        _fail(context, 'story[$i] must be an object');
      }
    }
  }

  final concept = json['concept'];
  if (concept is Map<String, dynamic>) {
    _requireKeys(concept, ['title', 'explanation'], '$context/concept');
  } else {
    _fail(context, 'concept must be an object');
  }

  final playground = json['playground'];
  if (playground is Map<String, dynamic>) {
    _requireKeys(playground, ['type', 'instructions'], '$context/playground');
  } else {
    _fail(context, 'playground must be an object');
  }

  final challenge = json['challenge'];
  if (challenge is Map<String, dynamic>) {
    _validateChallenge(challenge, '$context/challenge');
  } else {
    _fail(context, 'challenge must be an object');
  }

  final reward = json['reward'];
  if (reward is Map<String, dynamic>) {
    _requireKeys(reward, ['xp', 'coins'], '$context/reward');
  } else {
    _fail(context, 'reward must be an object');
  }
}

void _validateRealm(Map<String, dynamic> json, String context) {
  _requireKeys(json, [
    'id',
    'name',
    'mentorName',
    'description',
    'order',
  ], context);

  final id = json['id'];
  if (id is String && !_validRealmIds.contains(id)) {
    _fail(context, 'unknown realm id: $id');
  }
}

void main() {
  final contentDir = Directory('assets/content');
  if (!contentDir.existsSync()) {
    stderr.writeln('assets/content/ not found — run from the project root.');
    exitCode = 1;
    return;
  }

  final realmsFile = File('assets/content/realms.json');
  final seenRealmIds = <String>{};
  if (!realmsFile.existsSync()) {
    _fail('realms.json', 'file is missing');
  } else {
    final realms = jsonDecode(realmsFile.readAsStringSync()) as List;
    for (var i = 0; i < realms.length; i++) {
      _validateRealm(realms[i] as Map<String, dynamic>, 'realms.json[$i]');
      seenRealmIds.add(realms[i]['id'] as String);
    }
    for (final required in _validRealmIds) {
      if (!seenRealmIds.contains(required)) {
        _fail('realms.json', 'missing entry for realm "$required"');
      }
    }
  }

  final levelFiles = contentDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json') && !f.path.endsWith('realms.json'))
      .toList();

  final seenLevelIds = <String>{};
  final ordersByRealm = <String, List<int>>{};

  for (final file in levelFiles) {
    final levels = jsonDecode(file.readAsStringSync()) as List;
    for (var i = 0; i < levels.length; i++) {
      final level = levels[i] as Map<String, dynamic>;
      final context = '${file.path}[$i]';
      _validateLevel(level, context);

      final id = level['id'];
      if (id is String) {
        if (!seenLevelIds.add(id)) {
          _fail(context, 'duplicate level id: $id');
        }
      }

      final realmId = level['realmId'];
      final order = level['order'];
      if (realmId is String && order is int) {
        ordersByRealm.putIfAbsent(realmId, () => []).add(order);
      }
    }
  }

  for (final entry in ordersByRealm.entries) {
    final sorted = [...entry.value]..sort();
    for (var i = 0; i < sorted.length; i++) {
      if (sorted[i] != i + 1) {
        _fail(
          entry.key,
          'level order must be a contiguous sequence starting at 1, got $sorted',
        );
        break;
      }
    }
  }

  if (_errors.isNotEmpty) {
    stderr.writeln('Content validation FAILED with ${_errors.length} error(s):');
    for (final error in _errors) {
      stderr.writeln('  - $error');
    }
    exitCode = 1;
  } else {
    stdout.writeln(
      'Content validation passed: ${seenLevelIds.length} levels across '
      '${ordersByRealm.length} realms.',
    );
  }
}
