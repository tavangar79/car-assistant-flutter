import '../../domain/entities/otp_request.dart';

/// 200 body of `POST /api/auth/otp/request`.
class OtpRequestDto {
  const OtpRequestDto({
    required this.expiresInSeconds,
    required this.resendInSeconds,
    required this.codeLength,
    required this.isRegistered,
  });

  factory OtpRequestDto.fromJson(Map<String, dynamic> json) => OtpRequestDto(
    expiresInSeconds: json['expiresInSeconds'] as int,
    resendInSeconds: json['resendInSeconds'] as int,
    codeLength: json['codeLength'] as int,
    isRegistered: json['isRegistered'] as bool,
  );

  final int expiresInSeconds;
  final int resendInSeconds;
  final int codeLength;
  final bool isRegistered;

  OtpRequest toEntity(String phone) => OtpRequest(
    phone: phone,
    expiresInSeconds: expiresInSeconds,
    resendInSeconds: resendInSeconds,
    codeLength: codeLength,
    isRegistered: isRegistered,
  );
}
