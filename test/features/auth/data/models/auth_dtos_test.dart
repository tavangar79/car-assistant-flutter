import 'package:car_assistant/features/auth/data/models/otp_request_dto.dart';
import 'package:car_assistant/features/auth/data/models/update_profile_request_dto.dart';
import 'package:car_assistant/features/auth/data/models/user_dto.dart';
import 'package:car_assistant/features/auth/data/models/verify_otp_response_dto.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_result.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userJson = {
    'id': '665f1c2e8a1b2c3d4e5f6a7b',
    'phone': '09121234567',
    'createdAt': '2026-10-16T08:30:00.000Z',
    'firstName': null,
    'lastName': null,
    'birthDate': null,
    'avatarUrl': null,
    'isProfileComplete': false,
  };
  final user = User(
    id: '665f1c2e8a1b2c3d4e5f6a7b',
    phone: '09121234567',
    createdAt: DateTime.utc(2026, 10, 16, 8, 30),
    isProfileComplete: false,
  );

  test('UserDto parses the contract shape', () {
    expect(UserDto.fromJson(userJson).toEntity(), user);
  });

  test('UserDto maps a completed profile: names, Gregorian birth date and avatarUrl', () {
    final dto = UserDto.fromJson({
      ...userJson,
      'firstName': 'علی',
      'lastName': 'محمدی',
      'birthDate': '1991-11-12',
      'avatarUrl': '/api/auth/me/avatar?v=1729150000000',
      'isProfileComplete': true,
    });

    expect(
      dto.toEntity(),
      User(
        id: '665f1c2e8a1b2c3d4e5f6a7b',
        phone: '09121234567',
        createdAt: DateTime.utc(2026, 10, 16, 8, 30),
        firstName: 'علی',
        lastName: 'محمدی',
        birthDate: DateTime(1991, 11, 12),
        avatarUrl: '/api/auth/me/avatar?v=1729150000000',
        isProfileComplete: true,
      ),
    );
  });

  test('UpdateProfileRequestDto sends the birth date as YYYY-MM-DD', () {
    final dto = UpdateProfileRequestDto(
      firstName: 'علی',
      lastName: 'محمدی',
      birthDate: DateTime(1991, 1, 2, 23, 59),
    );

    expect(dto.toJson(), {'firstName': 'علی', 'lastName': 'محمدی', 'birthDate': '1991-01-02'});
  });

  test('OtpRequestDto parses the contract shape', () {
    final dto = OtpRequestDto.fromJson({
      'expiresInSeconds': 120,
      'resendInSeconds': 60,
      'codeLength': 6,
      'isRegistered': false,
    });

    expect(
      dto.toEntity('09121234567'),
      const OtpRequest(
        phone: '09121234567',
        expiresInSeconds: 120,
        resendInSeconds: 60,
        codeLength: 6,
        isRegistered: false,
      ),
    );
  });

  test('VerifyOtpResponseDto parses the contract shape', () {
    final dto = VerifyOtpResponseDto.fromJson({
      'accessToken': 'jwt.token.value',
      'isNewUser': true,
      'user': userJson,
    });

    expect(dto.accessToken, 'jwt.token.value');
    expect(dto.toEntity(), AuthResult(user: user, isNewUser: true));
  });
}
