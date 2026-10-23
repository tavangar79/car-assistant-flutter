import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/auth_failures.dart';
import 'auth_providers.dart';
import 'otp_args.dart';
import 'otp_state.dart';

/// View model of the code page: owns the typed code, the resend countdown, loading and the last error.
///
/// One instance per [OtpArgs], so a code requested for another number starts over.
class OtpViewModel extends Notifier<OtpState> {
  OtpViewModel(this.args);

  final OtpArgs args;
  Timer? _timer;

  @override
  OtpState build() {
    ref.onDispose(() => _timer?.cancel());
    final seconds = _nonNegative(args.resendInSeconds);
    _startTimer(seconds);
    return OtpState(codeLength: args.codeLength, secondsLeft: seconds);
  }

  /// Called on every edit of the code boxes.
  void codeChanged(String code) {
    if (code != state.code) state = state.copyWith(code: code);
  }

  /// Signs in with the typed code. On failure the code is cleared and the error kept in [state].
  Future<void> verify() async {
    if (state.isVerifying || state.isResending || !state.isComplete) return;
    state = state.copyWith(isVerifying: true, clearFailure: true);
    final result = await ref.read(verifyOtpProvider).call(phone: args.phone, code: state.code);
    if (!ref.mounted) return; // Page left; the stored token is restored on next start.
    switch (result) {
      case Right(value: final auth):
        state = state.copyWith(isVerifying: false);
        ref.read(authStatusProvider.notifier).signIn(auth.user);
      case Left(value: final failure):
        state = state.copyWith(isVerifying: false, code: '', failure: failure);
    }
  }

  /// Requests a new code and restarts the countdown. Returns `true` when a code was sent.
  /// On 429 no code is sent: the failure stays in [state] (to show the rate limit) and the
  /// countdown restarts from the server's `retryAfterSeconds`.
  Future<bool> resend() async {
    if (state.isResending || state.isVerifying) return false;
    state = state.copyWith(isResending: true, clearFailure: true);
    final result = await ref.read(requestOtpProvider).call(args.phone);
    if (!ref.mounted) return false;
    state = state.copyWith(isResending: false);
    switch (result) {
      case Right(value: final request):
        _restartCountdown(request.resendInSeconds);
        return true;
      case Left(value: final TooManyRequestsFailure failure):
        state = state.copyWith(failure: failure);
        _restartCountdown(failure.retryAfterSeconds);
        return false;
      case Left(value: final failure):
        state = state.copyWith(failure: failure);
        return false;
    }
  }

  void _restartCountdown(int seconds) {
    final left = _nonNegative(seconds);
    state = state.copyWith(secondsLeft: left);
    _startTimer(left);
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    if (seconds == 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final left = state.secondsLeft - 1;
      state = state.copyWith(secondsLeft: left);
      if (left <= 0) timer.cancel();
    });
  }

  static int _nonNegative(int seconds) => seconds < 0 ? 0 : seconds;
}
