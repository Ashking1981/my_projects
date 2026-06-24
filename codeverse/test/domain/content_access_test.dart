import 'package:flutter_test/flutter_test.dart';

import 'package:codeverse/domain/content_access.dart';
import 'package:codeverse/ui/tokens/app_colors.dart';

void main() {
  test('Python Peaks is free regardless of PRO status', () {
    expect(ContentAccess.requiresPro(RealmId.pythonPeaks), isFalse);
    expect(
      ContentAccess.isRealmLocked(RealmId.pythonPeaks, isPro: false),
      isFalse,
    );
  });

  test('other realms require PRO', () {
    expect(ContentAccess.requiresPro(RealmId.gameForge), isTrue);
    expect(
      ContentAccess.isRealmLocked(RealmId.gameForge, isPro: false),
      isTrue,
    );
    expect(
      ContentAccess.isRealmLocked(RealmId.gameForge, isPro: true),
      isFalse,
    );
  });
}
