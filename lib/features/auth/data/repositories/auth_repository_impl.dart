import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_failures.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/avatar_file.dart';
import '../../domain/entities/otp_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/update_profile_request_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this._remote, required this._tokenStorage});

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  @override
  Future<Either<Failure, OtpRequest>> requestOtp(String phone) => apiCall(
    () async => (await _remote.requestOtp(phone)).toEntity(phone),
    onStatus: (status, error) => switch (status) {
      400 => InvalidPhoneFailure(error?.message ?? 'Invalid phone number'),
      429 => TooManyRequestsFailure(error?.retryAfterSeconds ?? 0, codeLength: error?.codeLength),
      502 => SmsSendFailure(error?.message ?? 'SMS provider failed'),
      _ => null,
    },
  );

  @override
  Future<Either<Failure, AuthResult>> verifyOtp({required String phone, required String code}) =>
      apiCall(
        () async {
          final dto = await _remote.verifyOtp(phone: phone, code: code);
          await _tokenStorage.write(dto.accessToken);
          return dto.toEntity();
        },
        onStatus: (status, error) => switch (status) {
          // 400 = bad phone or a code of the wrong length: for the user it is a wrong code too.
          400 || 401 => InvalidCodeFailure(error?.message ?? 'Invalid or expired code'),
          429 => TooManyRequestsFailure(error?.retryAfterSeconds ?? 0),
          _ => null,
        },
      );

  @override
  Future<bool> hasSession() async {
    try {
      final token = await _tokenStorage.read();
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() => apiCall(
    () async => (await _remote.fetchMe()).toEntity(),
    onStatus: (status, _) => _accountGone(status) ? const UnauthorizedFailure() : null,
  );

  @override
  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) => apiCall(
    () async {
      final request = UpdateProfileRequestDto(
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
      );
      return (await _remote.updateMe(request)).toEntity();
    },
    onStatus: (status, error) => switch (status) {
      400 => InvalidProfileFailure(message: error?.message ?? 'Invalid profile'),
      _ when _accountGone(status) => const UnauthorizedFailure(),
      _ => null,
    },
  );

  @override
  Future<Either<Failure, User>> uploadAvatar(AvatarFile file) => apiCall(
    () async => (await _remote.uploadAvatar(file)).toEntity(),
    onStatus: (status, error) => switch (status) {
      400 => InvalidAvatarFailure(error?.message ?? 'Invalid image'),
      413 => AvatarTooLargeFailure(error?.message ?? 'Image too large'),
      _ when _accountGone(status) => const UnauthorizedFailure(),
      _ => null,
    },
  );

  @override
  Future<Either<Failure, User>> deleteAvatar() => apiCall(
    () async => (await _remote.deleteAvatar()).toEntity(),
    onStatus: (status, _) => _accountGone(status) ? const UnauthorizedFailure() : null,
  );

  /// A 404 here means "no photo", not a deleted account, so it stays a generic failure.
  @override
  Future<Either<Failure, Uint8List>> fetchAvatar(String avatarUrl) =>
      apiCall(() => _remote.fetchAvatar(avatarUrl));

  @override
  Future<Either<Failure, Unit>> clearSession() => apiCall(() async {
    try {
      await _tokenStorage.clear();
    } catch (_) {
      // Could not delete it: overwrite it so it can never sign the user back in.
      await _tokenStorage.write('');
    }
    return unit;
  });

  /// 401: token rejected. 404 on `/api/auth/me`: the account was deleted. Both end the session.
  static bool _accountGone(int status) => status == 401 || status == 404;
}
