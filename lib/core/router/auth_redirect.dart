import '../../features/auth/presentation/providers/auth_status_notifier.dart';
import 'app_routes.dart';

/// Router guard. The splash screen decides when to leave; until the session is known every other
/// page goes back to splash. Signed-out users stay in the sign-in flow, signed-in users skip it.
String? authRedirect(AuthStatus status, String location) {
  if (location == AppRoutes.splashPath) return null;
  final inSignInFlow = location == AppRoutes.phonePath || location == AppRoutes.otpPath;
  return switch (status) {
    AuthStatus.unknown => AppRoutes.splashPath,
    AuthStatus.signedOut => inSignInFlow ? null : AppRoutes.phonePath,
    AuthStatus.signedIn => inSignInFlow ? AppRoutes.vehiclesPath : null,
  };
}
