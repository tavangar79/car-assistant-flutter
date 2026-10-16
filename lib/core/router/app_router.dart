import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/vehicles/presentation/pages/vehicles_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.vehiclesPath,
    routes: [
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
