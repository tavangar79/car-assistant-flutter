import 'package:fpdart/fpdart.dart';

import '../entities/auth_failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Result of [CheckSession]. [user] is `null` when signed out, or when signed in but the server
/// could not be reached.
typedef SessionCheck = ({bool signedIn, User? user});

/// Decides at startup whether the user is signed in. Never fails.
///
/// No token, or a token the server rejects (401), means signed out; a rejected token is cleared.
/// Other failures (e.g. offline) keep the session so the app stays usable.
class CheckSession {
  const CheckSession(this._repository);

  final AuthRepository _repository;

  Future<SessionCheck> call() async {
    if (!await _repository.hasSession()) return (signedIn: false, user: null);
    switch (await _repository.getCurrentUser()) {
      case Right(value: final user):
        return (signedIn: true, user: user);
      case Left(value: UnauthorizedFailure()):
        await _repository.clearSession();
        return (signedIn: false, user: null);
      case Left():
        return (signedIn: true, user: null);
    }
  }
}
