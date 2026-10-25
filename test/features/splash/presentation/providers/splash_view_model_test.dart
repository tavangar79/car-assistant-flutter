import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:car_assistant/features/splash/presentation/providers/splash_providers.dart';
import 'package:car_assistant/features/splash/presentation/providers/splash_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  final user = User(
    id: 'u1',
    phone: '09121234567',
    createdAt: DateTime.utc(2026),
    isProfileComplete: true,
  );

  late MockAuthRepository repository;
  late ProviderContainer container;
  late ProviderSubscription<SplashStatus> sub;

  setUp(() {
    repository = MockAuthRepository();
    when(() => repository.hasSession()).thenAnswer((_) async => true);
    container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        splashDelayProvider.overrideWithValue(Duration.zero),
      ],
    );
  });

  /// Starts the view model and waits until it leaves [SplashStatus.loading].
  Future<SplashStatus> start() async {
    sub = container.listen(splashViewModelProvider, (_, _) {});
    expect(sub.read(), SplashStatus.loading);
    await pumpEventQueue();
    return sub.read();
  }

  test('is done once the session is restored', () async {
    when(() => repository.getCurrentUser()).thenAnswer((_) async => Right(user));

    expect(await start(), SplashStatus.done);
    expect(container.read(authStatusProvider), AuthStatus.signedIn);
  });

  test('is done when signed out', () async {
    when(() => repository.hasSession()).thenAnswer((_) async => false);

    expect(await start(), SplashStatus.done);
    expect(container.read(authStatusProvider), AuthStatus.signedOut);
  });

  test('fails when the server is unreachable', () async {
    when(() => repository.getCurrentUser()).thenAnswer((_) async => const Left(NetworkFailure()));

    expect(await start(), SplashStatus.failed);
    expect(container.read(authStatusProvider), AuthStatus.unknown);
  });

  test('retry restores the session once the server is back', () async {
    when(() => repository.getCurrentUser()).thenAnswer((_) async => const Left(NetworkFailure()));
    await start();

    when(() => repository.getCurrentUser()).thenAnswer((_) async => Right(user));
    final retry = container.read(splashViewModelProvider.notifier).retry();
    expect(sub.read(), SplashStatus.loading);
    await retry;

    expect(sub.read(), SplashStatus.done);
  });

  test('retry is ignored unless it failed', () async {
    when(() => repository.getCurrentUser()).thenAnswer((_) async => Right(user));
    await start();

    await container.read(splashViewModelProvider.notifier).retry();

    expect(sub.read(), SplashStatus.done);
    verify(() => repository.getCurrentUser()).called(1);
  });
}
