import 'package:equatable/equatable.dart';

/// What the code page needs: where the code went, how long it is and when a new one may be requested.
class OtpArgs extends Equatable {
  const OtpArgs({required this.phone, required this.resendInSeconds, required this.codeLength});

  /// Used when the server did not say (a 429 on request without a valid `details.codeLength`).
  /// Matches the backend default `OTP_LENGTH`.
  static const defaultCodeLength = 5;

  /// Normalized `09xxxxxxxxx`.
  final String phone;
  final int resendInSeconds;
  final int codeLength;

  @override
  List<Object?> get props => [phone, resendInSeconds, codeLength];
}
