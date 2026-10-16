import 'package:equatable/equatable.dart';

/// A one-time code was sent to [phone].
class OtpRequest extends Equatable {
  const OtpRequest({
    required this.phone,
    required this.expiresInSeconds,
    required this.resendInSeconds,
    required this.codeLength,
    required this.isRegistered,
  });

  /// Normalized `09xxxxxxxxx` the code was sent to.
  final String phone;
  final int expiresInSeconds;

  /// Seconds until a new code may be requested.
  final int resendInSeconds;

  /// Number of digits in the sent code (backend `OTP_LENGTH`).
  final int codeLength;
  final bool isRegistered;

  @override
  List<Object?> get props => [phone, expiresInSeconds, resendInSeconds, codeLength, isRegistered];
}
