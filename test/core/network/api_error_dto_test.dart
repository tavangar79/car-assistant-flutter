import 'dart:convert';

import 'package:car_assistant/core/network/api_error_dto.dart';
import 'package:flutter_test/flutter_test.dart';

/// Round-trips through JSON like Dio does for a response body.
Object? _decoded(Object? value) => jsonDecode(jsonEncode(value));

void main() {
  group('ApiErrorDto', () {
    test('parses message and retryAfterSeconds', () {
      final error = ApiErrorDto.tryParse(
        _decoded({
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
        _decoded({
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
        _decoded({
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
        _decoded({
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
        _decoded({
          'error': {'message': 'SMS provider failed'},
        }),
      );

      expect(error?.message, 'SMS provider failed');
      expect(error?.retryAfterSeconds, isNull);
      expect(error?.codeLength, isNull);
    });

    test('returns null for a body that is not an error', () {
      expect(ApiErrorDto.tryParse('<html>'), isNull);
      expect(ApiErrorDto.tryParse({'ok': true}), isNull);
    });
  });
}
