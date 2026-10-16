import '../../domain/entities/auth_result.dart';
import 'user_dto.dart';

/// 200 body of `POST /api/auth/otp/verify`.
class VerifyOtpResponseDto {
  const VerifyOtpResponseDto({
    required this.accessToken,
    required this.isNewUser,
    required this.user,
  });

  factory VerifyOtpResponseDto.fromJson(Map<String, dynamic> json) => VerifyOtpResponseDto(
    accessToken: json['accessToken'] as String,
    isNewUser: json['isNewUser'] as bool,
    user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
  );

  final String accessToken;
  final bool isNewUser;
  final UserDto user;

  AuthResult toEntity() => AuthResult(user: user.toEntity(), isNewUser: isNewUser);
}
