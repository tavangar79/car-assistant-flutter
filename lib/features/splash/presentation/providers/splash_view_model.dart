import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import 'splash_providers.dart';

enum SplashStatus {
  /// Restoring the session, or waiting for [splashDelayProvider].
  loading,

  /// The server could not be reached; the user can [SplashViewModel.retry].
  failed,

  /// The session is known; the view leaves the splash.
  done,
}

/// View model of the splash page: restores the session, taking at least [splashDelayProvider].
class SplashViewModel extends Notifier<SplashStatus> {
  Timer? _timer;

  @override
  SplashStatus build() {
    ref.onDispose(() => _timer?.cancel());
    final delay = Completer<void>();
    _timer = Timer(ref.read(splashDelayProvider), delay.complete);
    _restore(delay.future);
    return SplashStatus.loading;
  }

  /// Tries again after a failure, without the splash delay.
  Future<void> retry() async {
    if (state != SplashStatus.failed) return;
    state = SplashStatus.loading;
    await _restore();
  }

  Future<void> _restore([Future<void>? minimumWait]) async {
    final restored = ref.read(authStatusProvider.notifier).restore();
    await minimumWait;
    final ok = await restored;
    if (!ref.mounted) return;
    state = ok ? SplashStatus.done : SplashStatus.failed;
  }
}
