import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/auth_failures.dart';
import '../../domain/entities/phone_number.dart';
import 'auth_providers.dart';
import 'otp_args.dart';

/// Requests a code for the phone page. The state carries loading and the last error.
class PhoneController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns the code page arguments, or `null` on error (the error is then in [state]).
  Future<OtpArgs?> submit(String rawPhone) async {
    state = const AsyncLoading();
    final result = await ref.read(requestOtpProvider).call(rawPhone);
    if (!ref.mounted) return null;
    switch (result) {
      case Right(value: final request):
        state = const AsyncData(null);
        return OtpArgs(
          phone: request.phone,
          resendInSeconds: request.resendInSeconds,
          codeLength: request.codeLength,
        );
      // A code was sent moments ago and is still valid: go enter it, with the server's cooldown.
      case Left(value: final TooManyRequestsFailure failure):
        state = const AsyncData(null);
        return OtpArgs(
          phone: PhoneNumber.normalize(rawPhone)!,
          resendInSeconds: failure.retryAfterSeconds,
          codeLength: failure.codeLength ?? OtpArgs.defaultCodeLength,
        );
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return null;
    }
  }
}
