import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:codeverse/app/app.dart';
import 'package:codeverse/app/app_constants.dart';
import 'package:codeverse/data/local/hive_setup.dart';
import 'package:codeverse/data/models/entitlement.dart';
import 'package:codeverse/data/models/player_profile.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_widget_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PlayerProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(EntitlementAdapter());
    }
    await Hive.openBox<PlayerProfile>(HiveBoxes.player);
    await Hive.openBox<Entitlement>(HiveBoxes.entitlement);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('Shows onboarding before a nickname is set',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CodeVerseApp()),
    );

    expect(find.text('Welcome to ${AppConstants.appName}'), findsOneWidget);
  });
}
