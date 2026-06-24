import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codeverse/app/app.dart';
import 'package:codeverse/app/app_constants.dart';

void main() {
  testWidgets('Home screen shows app name', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CodeVerseApp()),
    );

    expect(find.text(AppConstants.appName), findsOneWidget);
  });
}
