import 'package:hive_flutter/hive_flutter.dart';

import '../models/entitlement.dart';
import '../models/player_profile.dart';

class HiveBoxes {
  HiveBoxes._();

  static const String player = 'player_profile_box';
  static const String entitlement = 'entitlement_box';
}

/// Call once in main() before runApp(). Registers all TypeAdapters and
/// opens every box the app needs.
Future<void> setUpHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerProfileAdapter());
  Hive.registerAdapter(EntitlementAdapter());
  await Hive.openBox<PlayerProfile>(HiveBoxes.player);
  await Hive.openBox<Entitlement>(HiveBoxes.entitlement);
}
