import 'dart:convert';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/network/authenticated_client.dart';
import 'package:car_assistant/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:car_assistant/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../../../helpers/fake_token_storage.dart';

void main() {
  const phone = '09121234567';
  final userJson = {'id': 'u1', 'phone': phone, 'createdAt': '2026-10-16T08:30:00.000Z'};

  late FakeTokenStorage storage;

  setUp(() => storage = FakeTokenStorage());

  // Wired like production: the data source talks through the bearer-adding client.
  AuthRepositoryImpl buildRepository(MockClientHandler handler) {
    final client = AuthenticatedClient(inner: MockClient(handler), tokenStorage: storage);
    return AuthRepositoryImpl(
      remote: AuthRemoteDataSource(client: client, baseUrl: 'http://api.test'),
      tokenStorage: storage,
    );
  }

  test('requestOtp maps the response and keeps the phone', () async {
    final repository = buildRepository(
      (_) async => http.Response(
        jsonEncode({
          'expiresInSeconds': 120,
          'resendInSeconds': 60,
          'codeLength': 5,
          'isRegistered': false,
        }),
        200,
      ),
    );

    expect(
      await repository.requestOtp(phone),
      const OtpRequest(
        phone: phone,
        expiresInSeconds: 120,
        resendInSeconds: 60,
        codeLength: 5,
        isRegistered: false,
      ),
    );
  });

  test('verifyOtp stores the token and returns the user', () async {
    final repository = buildRepository(
      (_) async => http.Response(
        jsonEncode({'accessToken': 'jwt', 'isNewUser': true, 'user': userJson}),
        200,
      ),
    );

    final result = await repository.verifyOtp(phone: phone, code: '12345');

    expect(storage.token, 'jwt');
    expect(result.isNewUser, isTrue);
    expect(result.user.phone, phone);
    expect(await repository.hasSession(), isTrue);
  });

  test('verifyOtp does not store anything on 401', () async {
    final repository = buildRepository(
      (_) async => http.Response(
        jsonEncode({
          'error': {'message': 'Invalid or expired code'},
        }),
        401,
      ),
    );

    await expectLater(
      repository.verifyOtp(phone: phone, code: '12345'),
      throwsA(isA<InvalidCodeFailure>()),
    );
    expect(storage.token, isNull);
  });

  test('getCurrentUser sends the stored bearer token', () async {
    storage.token = 'jwt';
    final repository = buildRepository((request) async {
      expect(request.headers['Authorization'], 'Bearer jwt');
      return http.Response(jsonEncode(userJson), 200);
    });

    expect((await repository.getCurrentUser()).id, 'u1');
  });

  test('getCurrentUser throws UnauthorizedFailure on 401', () {
    storage.token = 'expired';
    final repository = buildRepository(
      (_) async => http.Response(
        jsonEncode({
          'error': {'message': 'Unauthorized'},
        }),
        401,
      ),
    );

    expect(repository.getCurrentUser(), throwsA(isA<UnauthorizedFailure>()));
  });

  test('network errors become NetworkFailure', () {
    final repository = buildRepository((_) async => throw http.ClientException('offline'));

    expect(repository.requestOtp(phone), throwsA(const NetworkFailure()));
  });

  test('malformed JSON becomes a Failure', () {
    final repository = buildRepository((_) async => http.Response('not json', 200));

    expect(repository.requestOtp(phone), throwsA(isA<Failure>()));
  });

  test('hasSession and clearSession use the token storage', () async {
    final repository = buildRepository((_) async => http.Response('', 200));
    expect(await repository.hasSession(), isFalse);

    storage.token = 'jwt';
    expect(await repository.hasSession(), isTrue);

    await repository.clearSession();
    expect(storage.token, isNull);
    expect(await repository.hasSession(), isFalse);
  });

  test('clearSession overwrites the token when it cannot be deleted', () async {
    storage
      ..token = 'jwt'
      ..failClear = true;
    final repository = buildRepository((_) async => http.Response('', 200));

    await repository.clearSession();

    expect(storage.token, isEmpty);
    expect(await repository.hasSession(), isFalse);
  });
}
