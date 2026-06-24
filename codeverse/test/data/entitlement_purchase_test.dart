import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:codeverse/data/local/hive_setup.dart';
import 'package:codeverse/data/models/entitlement.dart';
import 'package:codeverse/data/providers.dart';
import 'package:codeverse/data/repositories/entitlement_repository.dart';
import 'package:codeverse/data/services/mock_billing_service.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(EntitlementAdapter());
    }
    await Hive.openBox<Entitlement>(HiveBoxes.entitlement);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('starts out not PRO', () {
    final notifier =
        EntitlementNotifier(EntitlementRepository(), MockBillingService());
    expect(notifier.state.isPro, isFalse);
  });

  test('purchasePro grants and persists PRO via the mock billing service',
      () async {
    final notifier =
        EntitlementNotifier(EntitlementRepository(), MockBillingService());

    final success = await notifier.purchasePro();

    expect(success, isTrue);
    expect(notifier.state.isPro, isTrue);
    expect(EntitlementRepository().load().isPro, isTrue);
  });

  test('restorePurchases grants PRO via the mock billing service', () async {
    final notifier =
        EntitlementNotifier(EntitlementRepository(), MockBillingService());

    final restored = await notifier.restorePurchases();

    expect(restored, isTrue);
    expect(notifier.state.isPro, isTrue);
  });
}
