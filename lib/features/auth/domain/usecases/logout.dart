import '../repositories/auth_repository.dart';

/// Signs the user out by forgetting the stored token.
class Logout {
  const Logout(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.clearSession();
}
