import 'package:hive/hive.dart';

/// Local record of the player's PRO unlock status. The single source of
/// truth for gating is EntitlementService (Phase 6) — this is just its
/// persisted state.
class Entitlement {
  Entitlement({this.isPro = false, this.purchaseToken});

  bool isPro;
  String? purchaseToken;

  /// A distinct instance with the same field values, so Riverpod's default
  /// `previous != next` check (which uses identity here, since this class
  /// has no `==` override) actually sees a change and notifies watchers.
  Entitlement clone() => Entitlement(isPro: isPro, purchaseToken: purchaseToken);
}

class EntitlementAdapter extends TypeAdapter<Entitlement> {
  @override
  final int typeId = 1;

  @override
  Entitlement read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };
    return Entitlement(
      isPro: fields[0] as bool? ?? false,
      purchaseToken: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Entitlement obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isPro)
      ..writeByte(1)
      ..write(obj.purchaseToken);
  }
}
