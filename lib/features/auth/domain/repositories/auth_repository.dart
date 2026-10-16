import '../entities/auth_result.dart';
import '../entities/otp_request.dart';
import '../entities/user.dart';

/// Phone OTP authentication. Every method throws a `Failure` on error.
abstract interface class AuthRepository {
  /// Sends a code to the normalized [phone].
  Future<OtpRequest> requestOtp(String phone);

  /// Verifies [code] and stores the session token.
  Future<AuthResult> verifyOtp({required String phone, required String code});

  /// Whether a session token is stored.
  Future<bool> hasSession();

  /// The signed-in user. Throws `UnauthorizedFailure` when the token is rejected.
  Future<User> getCurrentUser();

  /// Forgets the stored session token. If it cannot be deleted it is made unusable instead.
  Future<void> clearSession();
}
