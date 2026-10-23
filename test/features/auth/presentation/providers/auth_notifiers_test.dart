import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:car_assistant/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_token_storage.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDio extends Mock implements Dio {}

void main() {
  const phone = '09121234567';
  final user = User(id: 'u1', phone: phone, createdAt: DateTime.utc(2026), isProfileComplete: true);

  late MockAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
  });

  group('AuthStatusNotifier', () {
    test('starts unknown and restores a valid session', () async {
      when(() => repository.hasSession()).thenAnswer((_) async => true);
      when(() => repository.getCurrentUser()).thenAnswer((_) async => Right(user));

      expect(container.read(authStatusProvider), AuthStatus.unknown);
      await container.read(authStatusProvider.notifier).restore();

      expect(container.read(authStatusProvider), AuthStatus.signedIn);
    });

    test('restores a user with an incomplete profile and keeps the user', () async {
      final incomplete = User(
        id: 'u1',
        phone: phone,
        createdAt: DateTime.utc(2026),
        isProfileComplete: false,
      );
      when(() => repository.hasSession()).thenAnswer((_) async => true);
      when(() => repository.getCurrentUser()).thenAnswer((_) async => Right(incomplete));

      await container.read(authStatusProvider.notifier).restore();

      expect(container.read(authStatusProvider), AuthStatus.profileIncomplete);
      expect(container.read(currentUserProvider), incomplete);
    });

    test('restores to signed out without a token', () async {
      when(() => repository.hasSession()).thenAnswer((_) async => false);

      await container.read(authStatusProvider.notifier).restore();

      expect(container.read(authStatusProvider), AuthStatus.signedOut);
    });

    test('logout clears the session and signs out', () async {
      when(() => repository.clearSession()).thenAnswer((_) async => const Right(unit));
      container.read(authStatusProvider.notifier).signIn(user);

      await container.read(authStatusProvider.notifier).logout();

      expect(container.read(authStatusProvider), AuthStatus.signedOut);
      expect(container.read(currentUserProvider), isNull);
      verify(() => repository.clearSession()).called(1);
    });

    test('logout still signs out when clearing the session fails', () async {
      when(() => repository.clearSession())
          .thenAnswer((_) async => const Left(Failure('keystore broken')));
      container.read(authStatusProvider.notifier).signIn(user);

      await container.read(authStatusProvider.notifier).logout();

      expect(container.read(authStatusProvider), AuthStatus.signedOut);
    });

    test('handleUnauthorized signs a signed-in user out and clears the token', () async {
      when(() => repository.clearSession()).thenAnswer((_) async => const Right(unit));
      container.read(authStatusProvider.notifier).signIn(user);

      await container.read(authStatusProvider.notifier).handleUnauthorized();

      expect(container.read(authStatusProvider), AuthStatus.signedOut);
      verify(() => repository.clearSession()).called(1);
    });

    test('handleUnauthorized is ignored before the session is restored', () async {
      await container.read(authStatusProvider.notifier).handleUnauthorized();

      expect(container.read(authStatusProvider), AuthStatus.unknown);
      verifyNever(() => repository.clearSession());
    });
  });

  group('CompleteProfileController', () {
    test('save stores the completed user and signs in fully', () async {
      final complete = User(
        id: 'u1',
        phone: phone,
        createdAt: DateTime.utc(2026),
        firstName: 'علی',
        lastName: 'محمدی',
        birthDate: DateTime(1991, 11, 12),
        isProfileComplete: true,
      );
      when(
        () => repository.updateProfile(
          firstName: 'علی',
          lastName: 'محمدی',
          birthDate: DateTime(1991, 11, 12),
        ),
      ).thenAnswer((_) async => Right(complete));
      container.listen(completeProfileControllerProvider, (_, _) {});

      final ok = await container
          .read(completeProfileControllerProvider.notifier)
          .save(firstName: 'علی', lastName: 'محمدی', birthDate: DateTime(1991, 11, 12));

      expect(ok, isTrue);
      expect(container.read(authStatusProvider), AuthStatus.signedIn);
      expect(container.read(currentUserProvider), complete);
    });

    test('save keeps the server failure in state', () async {
      when(() => repository.updateProfile(firstName: 'a', lastName: 'b', birthDate: DateTime(1991)))
          .thenAnswer((_) async => const Left(InvalidProfileFailure(message: 'bad')));
      final sub = container.listen(completeProfileControllerProvider, (_, _) {});

      final ok = await container
          .read(completeProfileControllerProvider.notifier)
          .save(firstName: 'a', lastName: 'b', birthDate: DateTime(1991));

      expect(ok, isFalse);
      expect(sub.read().error, const InvalidProfileFailure(message: 'bad'));
    });
  });

  test('restore: /me answering 404 (account deleted) clears the token and signs out', () async {
    final dio = MockDio();
    final storage = FakeTokenStorage()..token = 'jwt';
    when(() => dio.get<Map<String, dynamic>>('/api/auth/me')).thenAnswer(
      (_) => Future.error(
        DioException.badResponse(
          statusCode: 404,
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 404,
            data: {
              'error': {'message': 'User not found'},
            },
          ),
        ),
      ),
    );
    final real = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepositoryImpl(remote: AuthRemoteDataSource(dio), tokenStorage: storage),
        ),
      ],
    );

    await real.read(authStatusProvider.notifier).restore();

    expect(real.read(authStatusProvider), AuthStatus.signedOut);
    expect(storage.token, isNull);
  });
}
