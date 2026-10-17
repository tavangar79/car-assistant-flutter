import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_result.dart';
import '../entities/otp_request.dart';
import '../entities/user.dart';

/// Phone OTP authentication. Every fallible method returns a [Failure] on the left.
abstract interface class AuthRepository {
  /// Sends a code to the normalized [phone].
  Future<Either<Failure, OtpRequest>> requestOtp(String phone);

  /// Verifies [code] and stores the session token.
  Future<Either<Failure, AuthResult>> verifyOtp({required String phone, required String code});

  /// Whether a session token is stored. Never fails: an unreadable store counts as "no token".
  Future<bool> hasSession();

  /// The signed-in user. `UnauthorizedFailure` when the token is rejected.
  Future<Either<Failure, User>> getCurrentUser();

  /// Forgets the stored session token. If it cannot be deleted it is made unusable instead.
  Future<Either<Failure, Unit>> clearSession();
}
