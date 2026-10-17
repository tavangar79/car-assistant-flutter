import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

/// Loads the profile photo bytes for a `User.avatarUrl`.
class GetAvatar {
  const GetAvatar(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Uint8List>> call(String avatarUrl) => _repository.fetchAvatar(avatarUrl);
}
