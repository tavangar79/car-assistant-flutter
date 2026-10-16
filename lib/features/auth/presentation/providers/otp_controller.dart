import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_failures.dart';
import 'auth_providers.dart';

/// Verifies and resends codes for the code page. The state carries loading and the last error.
class OtpController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns `true` once signed in.
  Future<bool> verify({required String phone, required String code}) async {
    state = const AsyncLoading();
    try {
      await ref.read(verifyOtpProvider).call(phone: phone, code: code);
      if (!ref.mounted) return false; // Page left; the stored token is restored on next start.
      ref.read(authStatusProvider.notifier).markSignedIn();
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      if (ref.mounted) state = AsyncError(error, stackTrace);
      return false;
    }
  }

  /// Requests a new code. Returns the seconds until the next resend, or `null` on error.
  /// On 429 no code is sent: the failure stays in [state] (to show the rate limit) and the server's
  /// `retryAfterSeconds` is returned so the countdown restarts.
  Future<int?> resend(String phone) async {
    state = const AsyncLoading();
    try {
      final request = await ref.read(requestOtpProvider).call(phone);
      if (ref.mounted) state = const AsyncData(null);
      return request.resendInSeconds;
    } on TooManyRequestsFailure catch (failure, stackTrace) {
      if (ref.mounted) state = AsyncError(failure, stackTrace);
      return failure.retryAfterSeconds;
    } catch (error, stackTrace) {
      if (ref.mounted) state = AsyncError(error, stackTrace);
      return null;
    }
  }
}
