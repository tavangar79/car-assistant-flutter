import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_failures.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/otp_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

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
    onStatus: (status, _) => status == 401 ? const UnauthorizedFailure() : null,
  );

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
}
