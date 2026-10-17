import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/auth_failures.dart';
import 'auth_providers.dart';

/// Verifies and resends codes for the code page. The state carries loading and the last error.
class OtpController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns `true` once signed in.
  Future<bool> verify({required String phone, required String code}) async {
    state = const AsyncLoading();
    final result = await ref.read(verifyOtpProvider).call(phone: phone, code: code);
    if (!ref.mounted) return false; // Page left; the stored token is restored on next start.
    switch (result) {
      case Right(value: final auth):
        ref.read(authStatusProvider.notifier).signIn(auth.user);
        state = const AsyncData(null);
        return true;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return false;
    }
  }

  /// Requests a new code. Returns the seconds until the next resend, or `null` on error.
  /// On 429 no code is sent: the failure stays in [state] (to show the rate limit) and the server's
  /// `retryAfterSeconds` is returned so the countdown restarts.
  Future<int?> resend(String phone) async {
    state = const AsyncLoading();
    final result = await ref.read(requestOtpProvider).call(phone);
    if (!ref.mounted) return null;
    switch (result) {
      case Right(value: final request):
        state = const AsyncData(null);
        return request.resendInSeconds;
      case Left(value: final TooManyRequestsFailure failure):
        state = AsyncError(failure, StackTrace.current);
        return failure.retryAfterSeconds;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return null;
    }
  }
}
