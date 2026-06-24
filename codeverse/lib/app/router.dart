import 'package:go_router/go_router.dart';

import '../ui/tokens/app_colors.dart';
import '../features/dev/components_gallery_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/level/presentation/level_player_screen.dart';
import '../features/realm/presentation/realm_map_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/realm/:realmId',
      name: 'realm',
      builder: (context, state) => RealmMapScreen(
        realmId: RealmId.values.byName(state.pathParameters['realmId']!),
      ),
    ),
    GoRoute(
      path: '/level/:levelId',
      name: 'level',
      builder: (context, state) => LevelPlayerScreen(
        levelId: state.pathParameters['levelId']!,
      ),
    ),
    GoRoute(
      path: '/dev/components',
      name: 'devComponents',
      builder: (context, state) => const ComponentsGalleryScreen(),
    ),
  ],
);
