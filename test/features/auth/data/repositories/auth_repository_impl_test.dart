import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:car_assistant/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_result.dart';
import 'package:car_assistant/features/auth/domain/entities/avatar_file.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_token_storage.dart';

class MockDio extends Mock implements Dio {}

const _phone = '09121234567';
const _userJson = {
  'id': 'u1',
  'phone': _phone,
  'createdAt': '2026-01-01T00:00:00.000Z',
  'firstName': null,
  'lastName': null,
  'birthDate': null,
  'avatarUrl': null,
  'isProfileComplete': true,
};
final _user = User(id: 'u1', phone: _phone, createdAt: DateTime.utc(2026), isProfileComplete: true);

Response<Map<String, dynamic>> _ok(Map<String, dynamic> data) =>
    Response(requestOptions: RequestOptions(), statusCode: 200, data: data);

/// A non-2xx response as Dio reports it, with the backend error body.
DioException _httpError(int status, {String message = 'error', Map<String, dynamic>? details}) =>
    DioException.badResponse(
      statusCode: status,
      requestOptions: RequestOptions(),
      response: Response(
        requestOptions: RequestOptions(),
        statusCode: status,
        data: {
          'error': {'message': message, 'details': ?details},
        },
      ),
    );

void main() {
  late MockDio dio;
  late FakeTokenStorage storage;
  late AuthRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(Options()));

  setUp(() {
    dio = MockDio();
    storage = FakeTokenStorage();
    repository = AuthRepositoryImpl(remote: AuthRemoteDataSource(dio), tokenStorage: storage);
  });

  void stubPost(String path, Future<Response<Map<String, dynamic>>> Function() answer) {
    when(() => dio.post<Map<String, dynamic>>(path, data: any(named: 'data')))
        .thenAnswer((_) => answer());
  }

  group('requestOtp', () {
    test('posts the phone and maps the response, keeping the phone', () async {
      stubPost(
        '/api/auth/otp/request',
        () async => _ok({
          'expiresInSeconds': 120,
          'resendInSeconds': 60,
          'codeLength': 5,
          'isRegistered': false,
        }),
      );

      final result = await repository.requestOtp(_phone);

      expect(
        result,
        const Right<Failure, OtpRequest>(
          OtpRequest(
            phone: _phone,
            expiresInSeconds: 120,
            resendInSeconds: 60,
            codeLength: 5,
            isRegistered: false,
          ),
        ),
      );
      verify(() => dio.post<Map<String, dynamic>>('/api/auth/otp/request', data: {'phone': _phone}))
          .called(1);
    });

    test('maps 400, 429 (with details) and 502 to their failures', () async {
      final cases = <DioException, Failure>{
        _httpError(400, message: 'bad phone'): const InvalidPhoneFailure('bad phone'),
        _httpError(429, details: {'retryAfterSeconds': 42, 'codeLength': 6}):
            const TooManyRequestsFailure(42, codeLength: 6),
        _httpError(502, message: 'sms down'): const SmsSendFailure('sms down'),
      };
      for (final MapEntry(key: error, value: failure) in cases.entries) {
        stubPost('/api/auth/otp/request', () => Future.error(error));
        expect(await repository.requestOtp(_phone), Left<Failure, OtpRequest>(failure));
      }
    });

    test('maps an unexpected status to a generic Failure with the server message', () async {
      stubPost('/api/auth/otp/request', () => Future.error(_httpError(500, message: 'boom')));

      expect(
        await repository.requestOtp(_phone),
        const Left<Failure, OtpRequest>(Failure('HTTP 500: boom')),
      );
    });

    test('maps a connection error to NetworkFailure', () async {
      stubPost(
        '/api/auth/otp/request',
        () => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
        ),
      );

      expect(
        await repository.requestOtp(_phone),
        const Left<Failure, OtpRequest>(NetworkFailure()),
      );
    });

    test('maps a malformed body to a Failure', () async {
      stubPost('/api/auth/otp/request', () async => _ok({'unexpected': true}));

      expect((await repository.requestOtp(_phone)).isLeft(), isTrue);
    });
  });

  group('verifyOtp', () {
    test('stores the token and returns the user', () async {
      stubPost(
        '/api/auth/otp/verify',
        () async => _ok({'accessToken': 'jwt', 'isNewUser': true, 'user': _userJson}),
      );

      final result = await repository.verifyOtp(phone: _phone, code: '12345');

      expect(result, Right<Failure, AuthResult>(AuthResult(user: _user, isNewUser: true)));
      expect(storage.token, 'jwt');
    });

    test('maps 400 and 401 to InvalidCodeFailure and stores nothing', () async {
      for (final status in [400, 401]) {
        stubPost('/api/auth/otp/verify', () => Future.error(_httpError(status, message: 'wrong')));

        expect(
          await repository.verifyOtp(phone: _phone, code: '00000'),
          const Left<Failure, AuthResult>(InvalidCodeFailure('wrong')),
        );
      }
      expect(storage.token, isNull);
    });

    test('maps 429 to TooManyRequestsFailure', () async {
      stubPost(
        '/api/auth/otp/verify',
        () => Future.error(_httpError(429, details: {'retryAfterSeconds': 30})),
      );

      expect(
        await repository.verifyOtp(phone: _phone, code: '12345'),
        const Left<Failure, AuthResult>(TooManyRequestsFailure(30)),
      );
    });
  });

  group('getCurrentUser', () {
    test('returns the user', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/auth/me'))
          .thenAnswer((_) async => _ok(_userJson));

      expect(await repository.getCurrentUser(), Right<Failure, User>(_user));
    });

    test('maps 401 to UnauthorizedFailure', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/auth/me'))
          .thenAnswer((_) => Future.error(_httpError(401)));

      expect(await repository.getCurrentUser(), const Left<Failure, User>(UnauthorizedFailure()));
    });

    test('maps 404 (account deleted) to UnauthorizedFailure', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/auth/me'))
          .thenAnswer((_) => Future.error(_httpError(404, message: 'User not found')));

      expect(await repository.getCurrentUser(), const Left<Failure, User>(UnauthorizedFailure()));
    });
  });

  group('updateProfile', () {
    void stubPut(Future<Response<Map<String, dynamic>>> Function() answer) {
      when(() => dio.put<Map<String, dynamic>>('/api/auth/me', data: any(named: 'data')))
          .thenAnswer((_) => answer());
    }

    test('puts the names and a YYYY-MM-DD birth date and returns the user', () async {
      stubPut(
        () async => _ok({
          ..._userJson,
          'firstName': 'علی',
          'lastName': 'محمدی',
          'birthDate': '1991-11-12',
          'isProfileComplete': true,
        }),
      );

      final result = await repository.updateProfile(
        firstName: 'علی',
        lastName: 'محمدی',
        birthDate: DateTime(1991, 11, 12),
      );

      expect(
        result,
        Right<Failure, User>(
          User(
            id: 'u1',
            phone: _phone,
            createdAt: DateTime.utc(2026),
            firstName: 'علی',
            lastName: 'محمدی',
            birthDate: DateTime(1991, 11, 12),
            isProfileComplete: true,
          ),
        ),
      );
      verify(
        () => dio.put<Map<String, dynamic>>(
          '/api/auth/me',
          data: {'firstName': 'علی', 'lastName': 'محمدی', 'birthDate': '1991-11-12'},
        ),
      ).called(1);
    });

    test('maps 400 to InvalidProfileFailure, 401 and 404 to UnauthorizedFailure', () async {
      final cases = <int, Failure>{
        400: const InvalidProfileFailure(message: 'bad name'),
        401: const UnauthorizedFailure(),
        404: const UnauthorizedFailure(),
      };
      for (final MapEntry(key: status, value: failure) in cases.entries) {
        stubPut(() => Future.error(_httpError(status, message: 'bad name')));
        final result = await repository.updateProfile(
          firstName: 'a',
          lastName: 'b',
          birthDate: DateTime(1991),
        );
        expect(result, Left<Failure, User>(failure));
      }
    });
  });

  group('avatar', () {
    final file = AvatarFile(bytes: Uint8List.fromList([1, 2, 3]), fileName: 'me.png');
    const avatarUrl = '/api/auth/me/avatar?v=1729150000000';

    void stubUpload(Future<Response<Map<String, dynamic>>> Function() answer) {
      when(
        () => dio.put<Map<String, dynamic>>(
          '/api/auth/me/avatar',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) => answer());
    }

    test('uploads multipart field "avatar" with the image type and returns the user', () async {
      stubUpload(() async => _ok({..._userJson, 'avatarUrl': avatarUrl}));

      final result = await repository.uploadAvatar(file);

      expect(result.getOrElse((f) => throw f).avatarUrl, avatarUrl);
      final form =
          verify(
                () => dio.put<Map<String, dynamic>>(
                  '/api/auth/me/avatar',
                  data: captureAny(named: 'data'),
                  options: any(named: 'options'),
                ),
              ).captured.single
              as FormData;
      final part = form.files.single;
      expect(part.key, 'avatar');
      expect(part.value.filename, 'me.png');
      expect(part.value.contentType.toString(), 'image/png');
    });

    test('maps 400, 413, 401 and 404 to their failures', () async {
      final cases = <int, Failure>{
        400: const InvalidAvatarFailure('bad'),
        413: const AvatarTooLargeFailure('bad'),
        401: const UnauthorizedFailure(),
        404: const UnauthorizedFailure(),
      };
      for (final MapEntry(key: status, value: failure) in cases.entries) {
        stubUpload(() => Future.error(_httpError(status, message: 'bad')));
        expect(await repository.uploadAvatar(file), Left<Failure, User>(failure));
      }
    });

    test('deletes the photo and returns the user without avatarUrl', () async {
      when(() => dio.delete<Map<String, dynamic>>('/api/auth/me/avatar'))
          .thenAnswer((_) async => _ok(_userJson));

      expect(await repository.deleteAvatar(), Right<Failure, User>(_user));
    });

    test('fetches the photo bytes from the relative avatarUrl', () async {
      when(() => dio.get<List<int>>(avatarUrl, options: any(named: 'options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(), statusCode: 200, data: [9, 8]),
      );

      final result = await repository.fetchAvatar(avatarUrl);

      expect(result.getOrElse((f) => throw f), Uint8List.fromList([9, 8]));
    });

    test('a 404 when fetching the photo is not a lost session', () async {
      when(() => dio.get<List<int>>(avatarUrl, options: any(named: 'options')))
          .thenAnswer((_) => Future.error(_httpError(404)));

      final result = await repository.fetchAvatar(avatarUrl);

      expect(result.isLeft(), isTrue);
      expect(result.getLeft().toNullable(), isNot(isA<UnauthorizedFailure>()));
    });
  });

  group('session', () {
    test('hasSession and clearSession use the token storage', () async {
      expect(await repository.hasSession(), isFalse);
      storage.token = 'jwt';
      expect(await repository.hasSession(), isTrue);

      expect(await repository.clearSession(), const Right<Failure, Unit>(unit));
      expect(await repository.hasSession(), isFalse);
    });

    test('hasSession is false when the storage cannot be read', () async {
      storage
        ..token = 'jwt'
        ..failRead = true;

      expect(await repository.hasSession(), isFalse);
    });

    test('clearSession overwrites the token when it cannot be deleted', () async {
      storage
        ..token = 'jwt'
        ..failClear = true;

      expect(await repository.clearSession(), const Right<Failure, Unit>(unit));
      expect(storage.token, '');
      expect(await repository.hasSession(), isFalse);
    });
  });
}
