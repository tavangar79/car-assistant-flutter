import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/latin_digits.dart';
import '../entities/auth_failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

/// Verifies the code the user typed. The length is not fixed here: the backend decides
/// (OTP_LENGTH), so any non-empty numeric code is sent as typed.
class VerifyOtp {
  const VerifyOtp(this._repository);

  static final _numeric = RegExp(r'^\d+$');

  final AuthRepository _repository;

  Future<Either<Failure, AuthResult>> call({required String phone, required String code}) async {
    final digits = toLatinDigits(code.trim());
    if (!_numeric.hasMatch(digits)) return const Left(InvalidCodeFailure('Code must be numeric'));
    return _repository.verifyOtp(phone: phone, code: digits);
  }
}
