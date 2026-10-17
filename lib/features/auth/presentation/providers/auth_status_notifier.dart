import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import 'auth_providers.dart';

enum AuthStatus {
  unknown,
  signedIn,

  /// Signed in, but the profile must be completed before anything else.
  profileIncomplete,
  signedOut,
}

/// Holds whether the user is signed in. Starts as [AuthStatus.unknown] until [restore] runs.
/// The signed-in user, when known, is kept in [currentUserProvider].
class AuthStatusNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => AuthStatus.unknown;

  /// Checks the stored session (called once by the splash screen).
  Future<void> restore() async {
    final session = await ref.read(checkSessionProvider).call();
    if (session.signedIn) {
      signIn(session.user);
    } else {
      ref.read(currentUserProvider.notifier).set(null);
      state = AuthStatus.signedOut;
    }
  }

  /// Signs [user] in, or updates it (e.g. after saving the profile). A `null` user means signed in
  /// while the server could not be reached; the profile check then waits for the next start.
  void signIn(User? user) {
    ref.read(currentUserProvider.notifier).set(user);
    state = user != null && !user.isProfileComplete
        ? AuthStatus.profileIncomplete
        : AuthStatus.signedIn;
  }

  /// Signs out even when the token cannot be removed: the repository has then already made it
  /// unusable, and the user asked to leave.
  Future<void> logout() async {
    await ref.read(logoutProvider).call();
    ref.read(currentUserProvider.notifier).set(null);
    state = AuthStatus.signedOut;
  }

  /// An authenticated call got 401: the token expired or was revoked. Ignored until the session is
  /// restored ([restore] handles a rejected token itself) and once signed out.
  Future<void> handleUnauthorized() async {
    if (state == AuthStatus.signedIn || state == AuthStatus.profileIncomplete) await logout();
  }
}
