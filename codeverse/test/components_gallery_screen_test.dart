import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codeverse/features/dev/components_gallery_screen.dart';

void main() {
  testWidgets('renders every design-system section', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ComponentsGalleryScreen()),
    );

    final sectionTitles = [
      'PrimaryButton',
      'RealmCard',
      'LevelNode',
      'StarRating',
      'XpBar',
      'CoinBadge',
      'MascotBubble',
      'ConceptCard',
      'LockOverlay',
    ];

    for (final title in sectionTitles) {
      await tester.scrollUntilVisible(
        find.text(title),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(title), findsOneWidget);
    }
  });
}
