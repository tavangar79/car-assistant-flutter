import 'package:dio/dio.dart';

import '../models/otp_request_dto.dart';
import '../models/user_dto.dart';
import '../models/verify_otp_response_dto.dart';

/// HTTP calls for phone OTP auth. Throws [DioException] on a non-2xx response; the repository maps
/// it to a `Failure`. The [Dio] attaches the bearer token for [fetchMe].
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<OtpRequestDto> requestOtp(String phone) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/otp/request',
      data: {'phone': phone},
    );
    return OtpRequestDto.fromJson(response.data!);
  }

  Future<VerifyOtpResponseDto> verifyOtp({required String phone, required String code}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/otp/verify',
      data: {'phone': phone, 'code': code},
    );
    return VerifyOtpResponseDto.fromJson(response.data!);
  }

  Future<UserDto> fetchMe() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/auth/me');
    return UserDto.fromJson(response.data!);
  }
}
