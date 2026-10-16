import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/http_client_provider.dart';
import '../../../../core/storage/token_storage_provider.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_session.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/request_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_status_notifier.dart';
import 'otp_controller.dart';
import 'phone_controller.dart';

// Dependency wiring for the auth feature. Override [authRepositoryProvider]
// (or [tokenStorageProvider]) in tests to avoid real HTTP and secure storage.

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = AuthRemoteDataSource(
    client: ref.watch(authenticatedHttpClientProvider),
    baseUrl: AppConfig.apiBaseUrl,
  );
  return AuthRepositoryImpl(remote: remote, tokenStorage: ref.watch(tokenStorageProvider));
});

final requestOtpProvider = Provider<RequestOtp>(
  (ref) => RequestOtp(ref.watch(authRepositoryProvider)),
);

final verifyOtpProvider = Provider<VerifyOtp>(
  (ref) => VerifyOtp(ref.watch(authRepositoryProvider)),
);

final checkSessionProvider = Provider<CheckSession>(
  (ref) => CheckSession(ref.watch(authRepositoryProvider)),
);

final logoutProvider = Provider<Logout>((ref) => Logout(ref.watch(authRepositoryProvider)));

/// App-wide sign-in state, read by the router guard.
final authStatusProvider = NotifierProvider<AuthStatusNotifier, AuthStatus>(AuthStatusNotifier.new);

final phoneControllerProvider = AsyncNotifierProvider.autoDispose<PhoneController, void>(
  PhoneController.new,
);

final otpControllerProvider = AsyncNotifierProvider.autoDispose<OtpController, void>(
  OtpController.new,
);
