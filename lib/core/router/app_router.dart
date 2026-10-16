import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/phone_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/otp_args.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
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
        path: AppRoutes.vehiclesPath,
        name: AppRoutes.vehiclesName,
        builder: (context, state) => const VehiclesPage(),
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    authChanges.dispose();
  });
  return router;
});
