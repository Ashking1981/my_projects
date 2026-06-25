import 'package:flutter_test/flutter_test.dart';

import 'package:codeverse/data/repositories/badge_repository.dart';
import 'package:codeverse/data/repositories/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every badgeId referenced in level content has a catalog entry', () async {
    final levels = await ContentRepository().loadLevels();
    final badgeRepository = BadgeRepository();
    final catalogIds = badgeRepository.loadCatalog().map((b) => b.id).toSet();

    for (final level in levels) {
      final badgeId = level.reward.badgeId;
      if (badgeId == null) continue;
      expect(
        catalogIds.contains(badgeId),
        isTrue,
        reason: 'Level ${level.id} awards unknown badgeId "$badgeId" — '
            'add it to BadgeRepository._catalog.',
      );
    }
  });
}
