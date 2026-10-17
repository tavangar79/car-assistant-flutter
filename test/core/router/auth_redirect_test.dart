import 'package:car_assistant/core/router/app_routes.dart';
import 'package:car_assistant/core/router/auth_redirect.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const splash = AppRoutes.splashPath;
  const phone = AppRoutes.phonePath;
  const otp = AppRoutes.otpPath;
  const home = AppRoutes.homePath;
  const vehicles = AppRoutes.vehiclesPath;
  const profile = AppRoutes.completeProfilePath;

  test('splash is never redirected', () {
    for (final status in AuthStatus.values) {
      expect(authRedirect(status, splash), isNull);
    }
  });

  test('unknown session goes back to splash', () {
    expect(authRedirect(AuthStatus.unknown, vehicles), splash);
    expect(authRedirect(AuthStatus.unknown, phone), splash);
  });

  test('signed out stays in the sign-in flow', () {
    expect(authRedirect(AuthStatus.signedOut, vehicles), phone);
    expect(authRedirect(AuthStatus.signedOut, phone), isNull);
    expect(authRedirect(AuthStatus.signedOut, otp), isNull);
  });

  test('signed in skips the sign-in flow', () {
    expect(authRedirect(AuthStatus.signedIn, phone), home);
    expect(authRedirect(AuthStatus.signedIn, otp), home);
    for (final tab in [home, vehicles, AppRoutes.historyPath, AppRoutes.profilePath]) {
      expect(authRedirect(AuthStatus.signedIn, tab), isNull);
    }
  });

  test('an incomplete profile is always sent to complete-profile', () {
    expect(authRedirect(AuthStatus.profileIncomplete, profile), isNull);
    expect(authRedirect(AuthStatus.profileIncomplete, vehicles), profile);
    expect(authRedirect(AuthStatus.profileIncomplete, phone), profile);
    expect(authRedirect(AuthStatus.profileIncomplete, otp), profile);
    expect(authRedirect(AuthStatus.profileIncomplete, '/anything'), profile);
  });

  test('a complete profile cannot open complete-profile', () {
    expect(authRedirect(AuthStatus.signedIn, profile), home);
  });

  test('signed out cannot open complete-profile', () {
    expect(authRedirect(AuthStatus.signedOut, profile), phone);
    expect(authRedirect(AuthStatus.unknown, profile), splash);
  });

  test('only the sign-in routes count as the sign-in flow', () {
    expect(authRedirect(AuthStatus.signedOut, '/loginx'), phone);
    expect(authRedirect(AuthStatus.signedOut, '/login-help'), phone);
    expect(authRedirect(AuthStatus.signedIn, '/loginx'), isNull);
  });
}
