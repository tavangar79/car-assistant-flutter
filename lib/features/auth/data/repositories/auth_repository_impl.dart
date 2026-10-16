import 'package:http/http.dart' as http;

import '../../../../core/error/failure.dart';
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
  Future<OtpRequest> requestOtp(String phone) async {
    final dto = await _guard(() => _remote.requestOtp(phone));
    return dto.toEntity(phone);
  }

  @override
  Future<AuthResult> verifyOtp({required String phone, required String code}) async {
    final dto = await _guard(() => _remote.verifyOtp(phone: phone, code: code));
    await _guard(() => _tokenStorage.write(dto.accessToken));
    return dto.toEntity();
  }

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
  Future<User> getCurrentUser() async {
    final dto = await _guard(_remote.fetchMe);
    return dto.toEntity();
  }

  @override
  Future<void> clearSession() => _guard(() async {
    try {
      await _tokenStorage.clear();
    } catch (_) {
      // Could not delete it: overwrite it so it can never sign the user back in.
      await _tokenStorage.write('');
    }
  });

  /// Lets [Failure]s through and converts everything else into one.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on Failure {
      rethrow;
    } on http.ClientException {
      throw const NetworkFailure();
    } catch (error) {
      throw Failure('Unexpected error: $error');
    }
  }
}
