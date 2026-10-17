import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../domain/entities/avatar_file.dart';

import '../models/otp_request_dto.dart';
import '../models/update_profile_request_dto.dart';
import '../models/user_dto.dart';
import '../models/verify_otp_response_dto.dart';

/// HTTP calls for phone OTP auth. Throws [DioException] on a non-2xx response; the repository maps
/// it to a `Failure`. The [Dio] attaches the bearer token for the `/api/auth/me` calls.
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

  Future<UserDto> updateMe(UpdateProfileRequestDto request) async {
    final response = await _dio.put<Map<String, dynamic>>('/api/auth/me', data: request.toJson());
    return UserDto.fromJson(response.data!);
  }

  /// `multipart/form-data` with the single file field `avatar`.
  Future<UserDto> uploadAvatar(AvatarFile file) async {
    final form = FormData.fromMap({
      'avatar': MultipartFile.fromBytes(
        file.bytes,
        filename: file.fileName,
        contentType: DioMediaType.parse(file.mimeType ?? imageMimeType(file.fileName)),
      ),
    });
    final response = await _dio.put<Map<String, dynamic>>(
      '/api/auth/me/avatar',
      data: form,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return UserDto.fromJson(response.data!);
  }

  Future<UserDto> deleteAvatar() async {
    final response = await _dio.delete<Map<String, dynamic>>('/api/auth/me/avatar');
    return UserDto.fromJson(response.data!);
  }

  /// [avatarUrl] is the relative path from `PublicUser.avatarUrl`; Dio resolves it against the base URL.
  Future<Uint8List> fetchAvatar(String avatarUrl) async {
    final response = await _dio.get<List<int>>(
      avatarUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  /// The image type for a file name; JPEG unless it ends in `.png` or `.webp`.
  static String imageMimeType(String fileName) {
    final name = fileName.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
