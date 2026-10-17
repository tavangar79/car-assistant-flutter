import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/complete_profile_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/phone_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/otp_args.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/shell/presentation/pages/app_shell.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/vehicles/presentation/pages/add_vehicle_page.dart';
import '../../features/vehicles/presentation/pages/vehicles_page.dart';
import 'app_routes.dart';
import 'auth_redirect.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // Re-run the redirect whenever the sign-in state changes (e.g. logout).
  final authChanges = ValueNotifier(ref.read(authStatusProvider));
  ref.listen(authStatusProvider, (_, next) => authChanges.value = next);

  final router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: authChanges,
    redirect: (context, state) => authRedirect(ref.read(authStatusProvider), state.matchedLocation),
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.phonePath,
        name: AppRoutes.phoneName,
        builder: (context, state) => const PhonePage(),
        routes: [
          GoRoute(
            path: 'otp',
            name: AppRoutes.otpName,
            // Without arguments (e.g. a restored deep link) start again from the phone page.
            redirect: (context, state) => state.extra is OtpArgs ? null : AppRoutes.phonePath,
            builder: (context, state) => OtpPage(args: state.extra! as OtpArgs),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.completeProfilePath,
        name: AppRoutes.completeProfileName,
        builder: (context, state) => const CompleteProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.addVehiclePath,
        name: AppRoutes.addVehicleName,
        builder: (context, state) => const AddVehiclePage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          _tab(AppRoutes.homePath, AppRoutes.homeName, const HomePage()),
          _tab(AppRoutes.vehiclesPath, AppRoutes.vehiclesName, const VehiclesPage()),
          _tab(AppRoutes.historyPath, AppRoutes.historyName, const HistoryPage()),
          _tab(AppRoutes.profilePath, AppRoutes.profileName, const ProfilePage()),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    authChanges.dispose();
  });
  return router;
});

StatefulShellBranch _tab(String path, String name, Widget page) => StatefulShellBranch(
  routes: [GoRoute(path: path, name: name, builder: (context, state) => page)],
);
