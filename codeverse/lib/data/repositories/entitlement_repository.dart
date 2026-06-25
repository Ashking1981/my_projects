import 'package:hive/hive.dart';

import '../local/hive_setup.dart';
import '../models/entitlement.dart';

const String _entitlementKey = 'current';

class EntitlementRepository {
  Box<Entitlement> get _box => Hive.box<Entitlement>(HiveBoxes.entitlement);

  Entitlement load() => _box.get(_entitlementKey) ?? Entitlement();

  Future<void> save(Entitlement entitlement) =>
      _box.put(_entitlementKey, entitlement);
}
