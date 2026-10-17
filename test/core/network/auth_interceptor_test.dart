import 'dart:typed_data';

import 'package:car_assistant/core/network/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_token_storage.dart';

/// Answers every request with [status] and records the last request.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.status);

  final int status;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late FakeTokenStorage storage;
  late int unauthorizedCalls;

  setUp(() {
    storage = FakeTokenStorage();
    unauthorizedCalls = 0;
  });

  (Dio, _FakeAdapter) build(int status) {
    final adapter = _FakeAdapter(status);
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(tokenStorage: storage, onUnauthorized: () => unauthorizedCalls++),
      );
    return (dio, adapter);
  }

  test('adds the bearer token when one is stored', () async {
    storage.token = 'jwt';
    final (dio, adapter) = build(200);

    await dio.get<Object?>('/api/vehicles');

    expect(adapter.lastRequest!.headers['Authorization'], 'Bearer jwt');
  });

  test('sends no header without a token, or when the keystore is broken', () async {
    final (dio, adapter) = build(200);
    await dio.get<Object?>('/api/vehicles');
    expect(adapter.lastRequest!.headers.containsKey('Authorization'), isFalse);

    storage
      ..token = 'jwt'
      ..failRead = true;
    await dio.get<Object?>('/api/vehicles');
    expect(adapter.lastRequest!.headers.containsKey('Authorization'), isFalse);
    expect(storage.clearCalls, 1);
  });

  test('reports a rejected token (401) and still rethrows the error', () async {
    storage.token = 'jwt';
    final (dio, _) = build(401);

    await expectLater(dio.get<Object?>('/api/vehicles'), throwsA(isA<DioException>()));

    expect(unauthorizedCalls, 1);
  });

  test('ignores 401 on the OTP endpoints and when no token was sent', () async {
    storage.token = 'jwt';
    final (dio, _) = build(401);
    await expectLater(dio.post<Object?>('/api/auth/otp/verify'), throwsA(isA<DioException>()));

    storage.token = null;
    await expectLater(dio.get<Object?>('/api/vehicles'), throwsA(isA<DioException>()));

    expect(unauthorizedCalls, 0);
  });

  test('reports a 404 from the account endpoints (account deleted)', () async {
    storage.token = 'jwt';
    final (dio, _) = build(404);

    await expectLater(dio.get<Object?>('/api/auth/me'), throwsA(isA<DioException>()));
    await expectLater(dio.put<Object?>('/api/auth/me'), throwsA(isA<DioException>()));
    await expectLater(dio.delete<Object?>('/api/auth/me/avatar'), throwsA(isA<DioException>()));

    expect(unauthorizedCalls, 3);
  });

  test('ignores a 404 when loading the photo or from other endpoints', () async {
    storage.token = 'jwt';
    final (dio, _) = build(404);

    await expectLater(
      dio.get<Object?>('/api/auth/me/avatar?v=1729150000000'),
      throwsA(isA<DioException>()),
    );
    await expectLater(dio.get<Object?>('/api/vehicles/42'), throwsA(isA<DioException>()));

    expect(unauthorizedCalls, 0);
  });
}
