import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/storage/token_storage_provider.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_session.dart';
import '../../domain/usecases/delete_avatar.dart';
import '../../domain/usecases/get_avatar.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/request_otp.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_avatar.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_status_notifier.dart';
import 'avatar_controller.dart';
import 'avatar_picker.dart';
import 'complete_profile_controller.dart';
import 'current_user_notifier.dart';
import 'otp_controller.dart';
import 'phone_controller.dart';

// Dependency wiring for the auth feature. Override [authRepositoryProvider]
// (or [tokenStorageProvider]) in tests to avoid real HTTP and secure storage.

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: AuthRemoteDataSource(ref.watch(dioProvider)),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
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

final updateProfileProvider = Provider<UpdateProfile>(
  (ref) => UpdateProfile(ref.watch(authRepositoryProvider)),
);

final uploadAvatarProvider = Provider<UploadAvatar>(
  (ref) => UploadAvatar(ref.watch(authRepositoryProvider)),
);

final deleteAvatarProvider = Provider<DeleteAvatar>(
  (ref) => DeleteAvatar(ref.watch(authRepositoryProvider)),
);

final getAvatarProvider = Provider<GetAvatar>(
  (ref) => GetAvatar(ref.watch(authRepositoryProvider)),
);

final avatarPickerProvider = Provider<AvatarPicker>((ref) => const AvatarPicker());

/// The photo bytes for a `User.avatarUrl` (each upload gets a new URL, so no stale cache).
final avatarBytesProvider = FutureProvider.autoDispose.family<Uint8List, String>((ref, url) async {
  return (await ref.watch(getAvatarProvider).call(url)).getOrElse((failure) => throw failure);
});

final logoutProvider = Provider<Logout>((ref) => Logout(ref.watch(authRepositoryProvider)));

/// App-wide sign-in state, read by the router guard.
final authStatusProvider = NotifierProvider<AuthStatusNotifier, AuthStatus>(AuthStatusNotifier.new);

/// The signed-in user (phone, profile), or `null` when signed out or not loaded yet.
final currentUserProvider = NotifierProvider<CurrentUserNotifier, User?>(CurrentUserNotifier.new);

/// State of the phone page: loading while a code is requested, and the last error.
final phoneControllerProvider = AsyncNotifierProvider.autoDispose<PhoneController, void>(
  PhoneController.new,
);

/// State of the code page: loading while verifying or resending, and the last error.
final otpControllerProvider = AsyncNotifierProvider.autoDispose<OtpController, void>(
  OtpController.new,
);

/// State of the complete-profile page: loading while saving, and the last error.
final completeProfileControllerProvider =
    AsyncNotifierProvider.autoDispose<CompleteProfileController, void>(
      CompleteProfileController.new,
    );

/// State of the profile photo: loading while uploading or removing, and the last error.
final avatarControllerProvider = AsyncNotifierProvider.autoDispose<AvatarController, void>(
  AvatarController.new,
);
