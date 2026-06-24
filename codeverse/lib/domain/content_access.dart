import '../ui/tokens/app_colors.dart';

/// FREE/PRO content split: Python Peaks (the tutorial realm) is free
/// forever; the other four Realms require the PRO unlock. Pure rule, no
/// storage/widget dependency — same style as [ProgressCalculator].
class ContentAccess {
  ContentAccess._();

  static const RealmId freeRealm = RealmId.pythonPeaks;

  static bool requiresPro(RealmId realmId) => realmId != freeRealm;

  static bool isRealmLocked(RealmId realmId, {required bool isPro}) =>
      requiresPro(realmId) && !isPro;
}
