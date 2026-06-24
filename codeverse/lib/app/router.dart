import 'package:go_router/go_router.dart';

import '../features/dev/components_gallery_screen.dart';
import '../features/home/presentation/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/dev/components',
      name: 'devComponents',
      builder: (context, state) => const ComponentsGalleryScreen(),
    ),
  ],
);
