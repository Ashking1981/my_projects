import 'package:flutter_test/flutter_test.dart';

import 'package:codeverse/data/repositories/content_repository.dart';
import 'package:codeverse/ui/tokens/app_colors.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repository = ContentRepository();

  test('loads all 5 realms ordered', () async {
    final realms = await repository.loadRealms();
    expect(realms.length, 5);
    expect(realms.first.id, RealmId.pythonPeaks);
    for (var i = 1; i < realms.length; i++) {
      expect(realms[i].order, greaterThan(realms[i - 1].order));
    }
  });

  test('loads levels for Python Peaks fully authored', () async {
    final levels = await repository.loadLevelsForRealm(RealmId.pythonPeaks);
    expect(levels.length, 5);
    expect(levels.last.isBoss, isTrue);
  });

  test('loads 3 levels for each non-Python realm', () async {
    for (final realmId in [
      RealmId.gameForge,
      RealmId.pixelStudio,
      RealmId.dataDelta,
      RealmId.mindMachine,
    ]) {
      final levels = await repository.loadLevelsForRealm(realmId);
      expect(levels.length, 3, reason: '$realmId should have 3 levels');
    }
  });
}
