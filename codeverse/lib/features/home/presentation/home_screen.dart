import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import 'universe_map_screen.dart';

/// Root route. Shows onboarding until the player has picked a nickname,
/// then the Universe Map — no router redirect needed since both states
/// live under the same `/` route.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    if (profile.nickname.isEmpty) {
      return const OnboardingScreen();
    }
    return const UniverseMapScreen();
  }
}
