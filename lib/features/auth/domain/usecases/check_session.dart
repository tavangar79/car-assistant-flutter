import '../../../../core/error/failure.dart';
import '../entities/auth_failures.dart';
import '../repositories/auth_repository.dart';

/// Decides at startup whether the user is signed in.
///
/// No token, or a token the server rejects (401), means signed out; a rejected token is cleared.
/// Other failures (e.g. offline) keep the session so the app stays usable.
class CheckSession {
  const CheckSession(this._repository);

  final AuthRepository _repository;

  Future<bool> call() async {
    if (!await _repository.hasSession()) return false;
    try {
      await _repository.getCurrentUser();
      return true;
    } on UnauthorizedFailure {
      await _repository.clearSession();
      return false;
    } on Failure {
      return true;
    }
  }
}
