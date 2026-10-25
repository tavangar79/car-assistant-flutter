import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Decides at startup whether the user is signed in: `Right(user)` when signed in, `Right(null)`
/// when signed out.
///
/// No token, or a token the server rejects (401), means signed out; a rejected token is cleared.
/// Other failures (e.g. offline, server down) are returned so the caller can offer a retry.
class CheckSession {
  const CheckSession(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User?>> call() async {
    if (!await _repository.hasSession()) return const Right(null);
    switch (await _repository.getCurrentUser()) {
      case Right(value: final user):
        return Right(user);
      case Left(value: UnauthorizedFailure()):
        await _repository.clearSession();
        return const Right(null);
      case Left(value: final failure):
        return Left(failure);
    }
  }
}
