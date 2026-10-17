import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Removes the profile photo.
class DeleteAvatar {
  const DeleteAvatar(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call() => _repository.deleteAvatar();
}
