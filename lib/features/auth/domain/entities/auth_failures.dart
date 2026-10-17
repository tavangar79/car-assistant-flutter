import '../../../../core/error/failure.dart';

/// The phone number is not a valid Iranian mobile number (client check or HTTP 400).
class InvalidPhoneFailure extends Failure {
  const InvalidPhoneFailure([super.message = 'Invalid phone number']);
}

/// The code is wrong, expired, already used or attempts are exhausted (HTTP 401 on verify).
class InvalidCodeFailure extends Failure {
  const InvalidCodeFailure([super.message = 'Invalid or expired code']);
}

/// Rate limited (HTTP 429): a code was requested too soon, or too many codes were tried.
class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure(
    this.retryAfterSeconds, {
    this.codeLength,
    String message = 'Too many requests',
  }) : super(message);

  final int retryAfterSeconds;

  /// Length of the code already sent; only a 429 on request carries it.
  final int? codeLength;

  @override
  List<Object?> get props => [message, retryAfterSeconds, codeLength];
}

/// The backend could not send the SMS (HTTP 502).
class SmsSendFailure extends Failure {
  const SmsSendFailure([super.message = 'SMS provider failed']);
}

/// The stored token is missing, invalid or expired (HTTP 401 on authenticated calls), or the
/// account no longer exists (HTTP 404 on `/api/auth/me`).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

/// Which profile field a validation error belongs to.
enum ProfileField { firstName, lastName, birthDate }

/// The profile was rejected: by the client rules ([field] is set) or by the server (HTTP 400,
/// [field] is `null` because the error body does not name one).
class InvalidProfileFailure extends Failure {
  const InvalidProfileFailure({this.field, String message = 'Invalid profile'}) : super(message);

  final ProfileField? field;

  @override
  List<Object?> get props => [message, field];
}

/// The photo was rejected: missing or not a JPEG, PNG or WebP image (HTTP 400).
class InvalidAvatarFailure extends Failure {
  const InvalidAvatarFailure([super.message = 'Invalid image']);
}

/// The photo is larger than [AvatarFile.maxBytes] (client check or HTTP 413).
class AvatarTooLargeFailure extends Failure {
  const AvatarTooLargeFailure([super.message = 'Image too large']);
}
