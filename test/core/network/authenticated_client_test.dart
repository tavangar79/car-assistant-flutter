import 'package:car_assistant/core/network/authenticated_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../helpers/fake_token_storage.dart';

void main() {
  late int unauthorizedCalls;

  setUp(() => unauthorizedCalls = 0);

  AuthenticatedClient buildClient(FakeTokenStorage storage, MockClientHandler handler) =>
      AuthenticatedClient(
        inner: MockClient(handler),
        tokenStorage: storage,
        onUnauthorized: () => unauthorizedCalls++,
      );

  test('adds the bearer header when a token is stored', () async {
    final client = buildClient(FakeTokenStorage('abc'), (request) async {
      expect(request.headers['Authorization'], 'Bearer abc');
      return http.Response('ok', 200);
    });

    expect((await client.get(Uri.parse('http://api.test/x'))).statusCode, 200);
    expect(unauthorizedCalls, 0);
  });

  test('sends no auth header without a token', () async {
    final client = buildClient(FakeTokenStorage(), (request) async {
      expect(request.headers.containsKey('Authorization'), isFalse);
      return http.Response('ok', 200);
    });

    await client.get(Uri.parse('http://api.test/x'));
  });

  test('a 401 on an authenticated call reports unauthorized', () async {
    final client = buildClient(FakeTokenStorage('expired'), (_) async => http.Response('', 401));

    final response = await client.get(Uri.parse('http://api.test/api/vehicles'));

    expect(response.statusCode, 401);
    expect(unauthorizedCalls, 1);
  });

  test('a 401 on /otp/verify is a wrong code, not a lost session', () async {
    final client = buildClient(FakeTokenStorage('jwt'), (_) async => http.Response('', 401));

    await client.post(Uri.parse('http://api.test/api/auth/otp/verify'));

    expect(unauthorizedCalls, 0);
  });

  test('a 401 without a token does not report unauthorized', () async {
    final client = buildClient(FakeTokenStorage(), (_) async => http.Response('', 401));

    await client.get(Uri.parse('http://api.test/api/vehicles'));

    expect(unauthorizedCalls, 0);
  });

  test('when reading the token fails: sends no header and clears the storage', () async {
    final storage = FakeTokenStorage('jwt')..failRead = true;
    final client = buildClient(storage, (request) async {
      expect(request.headers.containsKey('Authorization'), isFalse);
      return http.Response('ok', 200);
    });

    expect((await client.post(Uri.parse('http://api.test/api/auth/otp/request'))).statusCode, 200);
    expect(storage.clearCalls, 1);
  });

  test('when reading and clearing both fail the request still goes out', () async {
    final storage = FakeTokenStorage('jwt')
      ..failRead = true
      ..failClear = true;
    final client = buildClient(storage, (_) async => http.Response('ok', 200));

    expect((await client.get(Uri.parse('http://api.test/x'))).statusCode, 200);
  });
}
