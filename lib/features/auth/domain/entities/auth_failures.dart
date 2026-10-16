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

/// The stored token is missing, invalid or expired (HTTP 401 on authenticated calls).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

/// The server could not be reached.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Could not reach the server']);
}
