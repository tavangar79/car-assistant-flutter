import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

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

  /// Checks the stored session (called by the splash screen). Returns `false` when the server could
  /// not be reached; the status then stays [AuthStatus.unknown] so the splash can offer a retry.
  Future<bool> restore() async {
    final result = await ref.read(checkSessionProvider).call();
    switch (result) {
      case Left():
        return false;
      case Right(value: final user?):
        signIn(user);
      case Right():
        ref.read(currentUserProvider.notifier).set(null);
        state = AuthStatus.signedOut;
    }
    return true;
  }

  /// Signs [user] in, or updates it (e.g. after saving the profile).
  void signIn(User user) {
    ref.read(currentUserProvider.notifier).set(user);
    state = user.isProfileComplete ? AuthStatus.signedIn : AuthStatus.profileIncomplete;
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
