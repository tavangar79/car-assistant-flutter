import 'dart:convert';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

AuthRemoteDataSource buildSource(MockClientHandler handler) =>
    AuthRemoteDataSource(client: MockClient(handler), baseUrl: 'http://api.test');

http.Response jsonResponse(Object body, int status) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Map<String, Object> errorBody(String message, [Map<String, Object>? details]) => {
  'error': {'message': message, 'details': ?details},
};

void main() {
  const phone = '09121234567';
  final userJson = {'id': 'u1', 'phone': phone, 'createdAt': '2026-10-16T08:30:00.000Z'};

  group('requestOtp', () {
    test('200: posts the phone as JSON and parses the response', () async {
      final source = buildSource((request) async {
        expect(request.method, 'POST');
        expect(request.url.toString(), 'http://api.test/api/auth/otp/request');
        expect(request.headers['Content-Type'], startsWith('application/json'));
        expect(jsonDecode(request.body), {'phone': phone});
        return jsonResponse({
          'expiresInSeconds': 120,
          'resendInSeconds': 60,
          'codeLength': 5,
          'isRegistered': true,
        }, 200);
      });

      final dto = await source.requestOtp(phone);

      expect(dto.expiresInSeconds, 120);
      expect(dto.resendInSeconds, 60);
      expect(dto.codeLength, 5);
      expect(dto.isRegistered, isTrue);
    });

    test('400 → InvalidPhoneFailure', () {
      final source = buildSource((_) async => jsonResponse(errorBody('Invalid phone'), 400));

      expect(source.requestOtp(phone), throwsA(isA<InvalidPhoneFailure>()));
    });

    test('429 → TooManyRequestsFailure with details.retryAfterSeconds', () {
      final source = buildSource(
        (_) async => jsonResponse(errorBody('Too many requests', {'retryAfterSeconds': 42}), 429),
      );

      expect(source.requestOtp(phone), throwsA(const TooManyRequestsFailure(42)));
    });

    test('429 → TooManyRequestsFailure with details.codeLength', () {
      final source = buildSource(
        (_) async => jsonResponse(
          errorBody('Too many requests', {'retryAfterSeconds': 42, 'codeLength': 6}),
          429,
        ),
      );

      expect(source.requestOtp(phone), throwsA(const TooManyRequestsFailure(42, codeLength: 6)));
    });

    test('502 → SmsSendFailure', () {
      final source = buildSource((_) async => jsonResponse(errorBody('SMS provider failed'), 502));

      expect(source.requestOtp(phone), throwsA(isA<SmsSendFailure>()));
    });

    test('other status → Failure', () {
      final source = buildSource((_) async => http.Response('oops', 500));

      expect(source.requestOtp(phone), throwsA(isA<Failure>()));
    });
  });

  group('verifyOtp', () {
    test('200: posts phone and code and parses token, flag and user', () async {
      final source = buildSource((request) async {
        expect(request.url.toString(), 'http://api.test/api/auth/otp/verify');
        expect(jsonDecode(request.body), {'phone': phone, 'code': '12345'});
        return jsonResponse({'accessToken': 'jwt', 'isNewUser': false, 'user': userJson}, 200);
      });

      final dto = await source.verifyOtp(phone: phone, code: '12345');

      expect(dto.accessToken, 'jwt');
      expect(dto.isNewUser, isFalse);
      expect(dto.user.id, 'u1');
    });

    test('401 → InvalidCodeFailure', () {
      final source = buildSource(
        (_) async => jsonResponse(errorBody('Invalid or expired code'), 401),
      );

      expect(
        source.verifyOtp(phone: phone, code: '00000'),
        throwsA(const InvalidCodeFailure('Invalid or expired code')),
      );
    });

    test('400 (wrong code length) → InvalidCodeFailure', () {
      final source = buildSource((_) async => jsonResponse(errorBody('Validation failed'), 400));

      expect(source.verifyOtp(phone: phone, code: '1'), throwsA(isA<InvalidCodeFailure>()));
    });

    test('429 → TooManyRequestsFailure with details.retryAfterSeconds', () {
      final source = buildSource(
        (_) async => jsonResponse(errorBody('Too many requests', {'retryAfterSeconds': 30}), 429),
      );

      expect(
        source.verifyOtp(phone: phone, code: '12345'),
        throwsA(const TooManyRequestsFailure(30)),
      );
    });

    test('502 → generic Failure', () {
      final source = buildSource((_) async => jsonResponse(errorBody('Bad gateway'), 502));

      expect(
        source.verifyOtp(phone: phone, code: '12345'),
        throwsA(const Failure('Could not verify the code (HTTP 502)')),
      );
    });
  });

  group('fetchMe', () {
    test('200: parses the user', () async {
      final source = buildSource((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), 'http://api.test/api/auth/me');
        return jsonResponse(userJson, 200);
      });

      expect((await source.fetchMe()).phone, phone);
    });

    test('401 → UnauthorizedFailure', () {
      final source = buildSource((_) async => jsonResponse(errorBody('Unauthorized'), 401));

      expect(source.fetchMe(), throwsA(isA<UnauthorizedFailure>()));
    });
  });
}
