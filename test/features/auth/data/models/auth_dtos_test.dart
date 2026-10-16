import 'dart:convert';

import 'package:car_assistant/features/auth/data/models/api_error_dto.dart';
import 'package:car_assistant/features/auth/data/models/otp_request_dto.dart';
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
  };
  final user = User(
    id: '665f1c2e8a1b2c3d4e5f6a7b',
    phone: '09121234567',
    createdAt: DateTime.utc(2026, 10, 16, 8, 30),
  );

  test('UserDto parses the contract shape', () {
    expect(UserDto.fromJson(userJson).toEntity(), user);
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

  group('ApiErrorDto', () {
    test('parses message and retryAfterSeconds', () {
      final error = ApiErrorDto.tryParse(
        jsonEncode({
          'error': {
            'message': 'Too many requests',
            'details': {'retryAfterSeconds': 42},
          },
        }),
      );

      expect(error?.message, 'Too many requests');
      expect(error?.retryAfterSeconds, 42);
    });

    test('reads a non-integer retryAfterSeconds safely', () {
      ApiErrorDto? parse(Object value) => ApiErrorDto.tryParse(
        jsonEncode({
          'error': {
            'message': 'Too many requests',
            'details': {'retryAfterSeconds': value},
          },
        }),
      );

      expect(parse(42.0)?.retryAfterSeconds, 42);
      expect(parse('42')?.retryAfterSeconds, isNull);
    });

    test('parses codeLength from a request-OTP 429', () {
      final error = ApiErrorDto.tryParse(
        jsonEncode({
          'error': {
            'message': 'Too many requests',
            'details': {'retryAfterSeconds': 42, 'codeLength': 6},
          },
        }),
      );

      expect(error?.retryAfterSeconds, 42);
      expect(error?.codeLength, 6);
    });

    test('treats a missing or invalid codeLength as missing', () {
      ApiErrorDto? parse(Object? value) => ApiErrorDto.tryParse(
        jsonEncode({
          'error': {
            'message': 'Too many requests',
            'details': {'retryAfterSeconds': 42, 'codeLength': value},
          },
        }),
      );

      expect(parse(6.0)?.codeLength, 6);
      expect(parse(null)?.codeLength, isNull);
      expect(parse('6')?.codeLength, isNull);
      expect(parse(0)?.codeLength, isNull);
      expect(parse(-5)?.codeLength, isNull);
    });

    test('works without details', () {
      final error = ApiErrorDto.tryParse(
        jsonEncode({
          'error': {'message': 'SMS provider failed'},
        }),
      );

      expect(error?.message, 'SMS provider failed');
      expect(error?.retryAfterSeconds, isNull);
      expect(error?.codeLength, isNull);
    });

    test('returns null for a body that is not an error', () {
      expect(ApiErrorDto.tryParse('<html>'), isNull);
      expect(ApiErrorDto.tryParse('{"ok":true}'), isNull);
    });
  });
}
