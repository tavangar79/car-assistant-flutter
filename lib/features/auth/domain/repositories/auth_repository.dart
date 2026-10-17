import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_result.dart';
import '../entities/avatar_file.dart';
import '../entities/otp_request.dart';
import '../entities/user.dart';

/// Phone OTP authentication. Every fallible method returns a [Failure] on the left.
abstract interface class AuthRepository {
  /// Sends a code to the normalized [phone].
  Future<Either<Failure, OtpRequest>> requestOtp(String phone);

  /// Verifies [code] and stores the session token.
  Future<Either<Failure, AuthResult>> verifyOtp({required String phone, required String code});

  /// Whether a session token is stored. Never fails: an unreadable store counts as "no token".
  Future<bool> hasSession();

  /// The signed-in user. `UnauthorizedFailure` when the token is rejected or the account is gone.
  Future<Either<Failure, User>> getCurrentUser();

  /// Saves the signed-in user's profile (names already trimmed) and returns the updated user.
  /// `InvalidProfileFailure` on 400, `UnauthorizedFailure` on 401/404.
  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  });

  /// Uploads [file] as the profile photo and returns the updated user.
  /// `InvalidAvatarFailure` on 400, `AvatarTooLargeFailure` on 413, `UnauthorizedFailure` on 401/404.
  Future<Either<Failure, User>> uploadAvatar(AvatarFile file);

  /// Removes the profile photo and returns the updated user.
  Future<Either<Failure, User>> deleteAvatar();

  /// The image bytes at [avatarUrl] (a `User.avatarUrl`). A generic `Failure` when there is none.
  Future<Either<Failure, Uint8List>> fetchAvatar(String avatarUrl);

  /// Forgets the stored session token. If it cannot be deleted it is made unusable instead.
  Future<Either<Failure, Unit>> clearSession();
}
