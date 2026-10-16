import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

enum AuthStatus { unknown, signedIn, signedOut }

/// Holds whether the user is signed in. Starts as [AuthStatus.unknown] until [restore] runs.
class AuthStatusNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => AuthStatus.unknown;

  /// Checks the stored session (called once by the splash screen).
  Future<void> restore() async {
    bool signedIn;
    try {
      signedIn = await ref.read(checkSessionProvider).call();
    } catch (_) {
      signedIn = false;
    }
    state = signedIn ? AuthStatus.signedIn : AuthStatus.signedOut;
  }

  void markSignedIn() => state = AuthStatus.signedIn;

  /// Signs out even when the token cannot be removed: the repository has then already made it
  /// unusable, and the user asked to leave.
  Future<void> logout() async {
    try {
      await ref.read(logoutProvider).call();
    } catch (_) {}
    state = AuthStatus.signedOut;
  }

  /// An authenticated call got 401: the token expired or was revoked. Ignored until the session is
  /// restored ([restore] handles a rejected token itself) and once signed out.
  Future<void> handleUnauthorized() async {
    if (state == AuthStatus.signedIn) await logout();
  }
}
