import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/vehicles/presentation/pages/vehicles_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.vehiclesPath,
        name: AppRoutes.vehiclesName,
        builder: (context, state) => const VehiclesPage(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
