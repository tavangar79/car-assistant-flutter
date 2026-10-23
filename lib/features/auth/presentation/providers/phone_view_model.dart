import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/auth_failures.dart';
import '../../domain/entities/phone_number.dart';
import '../widgets/phone_input_formatter.dart';
import 'auth_providers.dart';
import 'otp_args.dart';
import 'phone_state.dart';

/// View model of the phone page: owns the typed number, loading and the last error.
class PhoneViewModel extends Notifier<PhoneState> {
  @override
  PhoneState build() => const PhoneState();

  /// Called on every edit of the phone field.
  void phoneChanged(String text) {
    final digits = PhoneInputFormatter.digitsOf(text);
    if (digits != state.digits) state = state.copyWith(digits: digits);
  }

  /// Returns the code page arguments, or `null` on error (the error is then in [state]).
  Future<OtpArgs?> submit() async {
    if (state.isSubmitting) return null;
    final rawPhone = state.phone;
    state = state.copyWith(isSubmitting: true);
    final result = await ref.read(requestOtpProvider).call(rawPhone);
    if (!ref.mounted) return null;
    switch (result) {
      case Right(value: final request):
        state = state.copyWith(isSubmitting: false);
        return OtpArgs(
          phone: request.phone,
          resendInSeconds: request.resendInSeconds,
          codeLength: request.codeLength,
        );
      // A code was sent moments ago and is still valid: go enter it, with the server's cooldown.
      case Left(value: final TooManyRequestsFailure failure):
        state = state.copyWith(isSubmitting: false);
        return OtpArgs(
          phone: PhoneNumber.normalize(rawPhone)!,
          resendInSeconds: failure.retryAfterSeconds,
          codeLength: failure.codeLength ?? OtpArgs.defaultCodeLength,
        );
      case Left(value: final failure):
        state = state.copyWith(isSubmitting: false, failure: failure);
        return null;
    }
  }
}
