import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_failures.dart';
import '../entities/avatar_file.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Uploads a profile photo, refusing files over the backend limit before sending them.
class UploadAvatar {
  const UploadAvatar(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call(AvatarFile file) async {
    if (file.bytes.isEmpty) return const Left(InvalidAvatarFailure('Empty image'));
    if (file.bytes.length > AvatarFile.maxBytes) return const Left(AvatarTooLargeFailure());
    return _repository.uploadAvatar(file);
  }
}
