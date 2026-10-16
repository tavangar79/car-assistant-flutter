import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_failures.dart';
import '../../domain/entities/phone_number.dart';
import 'auth_providers.dart';
import 'otp_args.dart';

/// Sends the code for the phone page. The state carries loading and the last error.
class PhoneController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns the code page arguments, or `null` on error (the error is in [state]).
  Future<OtpArgs?> submit(String rawPhone) async {
    state = const AsyncLoading();
    try {
      final request = await ref.read(requestOtpProvider).call(rawPhone);
      if (!ref.mounted) return null;
      state = const AsyncData(null);
      return OtpArgs(
        phone: request.phone,
        resendInSeconds: request.resendInSeconds,
        codeLength: request.codeLength,
      );
    } on TooManyRequestsFailure catch (failure) {
      // A code was sent moments ago and is still valid: go enter it, with the server's cooldown.
      if (!ref.mounted) return null;
      state = const AsyncData(null);
      return OtpArgs(
        phone: PhoneNumber.normalize(rawPhone)!,
        resendInSeconds: failure.retryAfterSeconds,
        codeLength: failure.codeLength ?? OtpArgs.defaultCodeLength,
      );
    } catch (error, stackTrace) {
      if (ref.mounted) state = AsyncError(error, stackTrace);
      return null;
    }
  }
}
