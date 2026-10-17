import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_failures.dart';
import '../entities/profile_rules.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Validates and saves the signed-in user's profile. Names are sent trimmed.
class UpdateProfile {
  UpdateProfile(this._repository, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final AuthRepository _repository;
  final DateTime Function() _now;

  Future<Either<Failure, User>> call({
    required String firstName,
    required String lastName,
    required DateTime? birthDate,
  }) async {
    if (!ProfileRules.isValidName(firstName)) {
      return const Left(InvalidProfileFailure(field: ProfileField.firstName));
    }
    if (!ProfileRules.isValidName(lastName)) {
      return const Left(InvalidProfileFailure(field: ProfileField.lastName));
    }
    if (birthDate == null || !ProfileRules.isValidBirthDate(birthDate, _now())) {
      return const Left(InvalidProfileFailure(field: ProfileField.birthDate));
    }
    return _repository.updateProfile(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      birthDate: birthDate,
    );
  }
}
