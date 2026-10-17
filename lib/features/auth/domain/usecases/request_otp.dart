import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_failures.dart';
import '../entities/otp_request.dart';
import '../entities/phone_number.dart';
import '../repositories/auth_repository.dart';

/// Normalizes and validates a typed phone number, then asks the backend to send a code.
class RequestOtp {
  const RequestOtp(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, OtpRequest>> call(String rawPhone) async {
    final phone = PhoneNumber.normalize(rawPhone);
    if (phone == null) return const Left(InvalidPhoneFailure());
    return _repository.requestOtp(phone);
  }
}
