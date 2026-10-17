import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_result.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:car_assistant/features/auth/presentation/providers/otp_args.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const phone = '09121234567';
  final user = User(id: 'u1', phone: phone, createdAt: DateTime.utc(2026));
  const otpRequest = OtpRequest(
    phone: phone,
    expiresInSeconds: 120,
    resendInSeconds: 60,
    codeLength: 5,
    isRegistered: true,
  );

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

    test('restores to signed out without a token', () async {
      when(() => repository.hasSession()).thenAnswer((_) async => false);

      await container.read(authStatusProvider.notifier).restore();

      expect(container.read(authStatusProvider), AuthStatus.signedOut);
    });

    test('logout clears the session and signs out', () async {
      when(() => repository.clearSession()).thenAnswer((_) async => const Right(unit));
      container.read(authStatusProvider.notifier).markSignedIn();

      await container.read(authStatusProvider.notifier).logout();

      expect(container.read(authStatusProvider), AuthStatus.signedOut);
      verify(() => repository.clearSession()).called(1);
    });

    test('logout still signs out when clearing the session fails', () async {
      when(() => repository.clearSession())
          .thenAnswer((_) async => const Left(Failure('keystore broken')));
      container.read(authStatusProvider.notifier).markSignedIn();

      await container.read(authStatusProvider.notifier).logout();

      expect(container.read(authStatusProvider), AuthStatus.signedOut);
    });

    test('handleUnauthorized signs a signed-in user out and clears the token', () async {
      when(() => repository.clearSession()).thenAnswer((_) async => const Right(unit));
      container.read(authStatusProvider.notifier).markSignedIn();

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

  group('PhoneController', () {
    test('returns code page args on success', () async {
      when(() => repository.requestOtp(phone)).thenAnswer((_) async => const Right(otpRequest));
      final sub = container.listen(phoneControllerProvider, (_, _) {});

      final args = await container.read(phoneControllerProvider.notifier).submit('۰۹۱۲۱۲۳۴۵۶۷');

      expect(args, const OtpArgs(phone: phone, resendInSeconds: 60, codeLength: 5));
      expect(sub.read().hasError, isFalse);
    });

    test('keeps InvalidPhoneFailure in state and does not call the API', () async {
      final sub = container.listen(phoneControllerProvider, (_, _) {});

      final args = await container.read(phoneControllerProvider.notifier).submit('0912');

      expect(args, isNull);
      expect(sub.read().error, isA<InvalidPhoneFailure>());
      verifyNever(() => repository.requestOtp(any()));
    });

    test('on 429 continues to the code page with retryAfterSeconds', () async {
      when(() => repository.requestOtp(phone))
          .thenAnswer((_) async => const Left(TooManyRequestsFailure(42)));
      container.listen(phoneControllerProvider, (_, _) {});

      final args = await container.read(phoneControllerProvider.notifier).submit(phone);

      expect(
        args,
        const OtpArgs(phone: phone, resendInSeconds: 42, codeLength: OtpArgs.defaultCodeLength),
      );
    });

    test('on 429 uses the codeLength the server sent', () async {
      when(() => repository.requestOtp(phone))
          .thenAnswer((_) async => const Left(TooManyRequestsFailure(42, codeLength: 6)));
      container.listen(phoneControllerProvider, (_, _) {});

      final args = await container.read(phoneControllerProvider.notifier).submit(phone);

      expect(args, const OtpArgs(phone: phone, resendInSeconds: 42, codeLength: 6));
    });

    test('keeps SmsSendFailure in state', () async {
      when(() => repository.requestOtp(phone))
          .thenAnswer((_) async => const Left(SmsSendFailure()));
      final sub = container.listen(phoneControllerProvider, (_, _) {});

      expect(await container.read(phoneControllerProvider.notifier).submit(phone), isNull);
      expect(sub.read().error, isA<SmsSendFailure>());
    });
  });

  group('OtpController', () {
    test('verify signs in', () async {
      when(() => repository.verifyOtp(phone: phone, code: '12345'))
          .thenAnswer((_) async => Right(AuthResult(user: user, isNewUser: false)));
      container.listen(otpControllerProvider, (_, _) {});

      final ok = await container
          .read(otpControllerProvider.notifier)
          .verify(phone: phone, code: '12345');

      expect(ok, isTrue);
      expect(container.read(authStatusProvider), AuthStatus.signedIn);
    });

    test('verify keeps InvalidCodeFailure in state and stays signed out', () async {
      when(() => repository.verifyOtp(phone: phone, code: '00000'))
          .thenAnswer((_) async => const Left(InvalidCodeFailure()));
      final sub = container.listen(otpControllerProvider, (_, _) {});

      final ok = await container
          .read(otpControllerProvider.notifier)
          .verify(phone: phone, code: '00000');

      expect(ok, isFalse);
      expect(sub.read().error, isA<InvalidCodeFailure>());
      expect(container.read(authStatusProvider), AuthStatus.unknown);
    });

    test('resend returns the new cooldown', () async {
      when(() => repository.requestOtp(phone)).thenAnswer((_) async => const Right(otpRequest));
      container.listen(otpControllerProvider, (_, _) {});

      expect(await container.read(otpControllerProvider.notifier).resend(phone), 60);
    });

    test('resend on 429 returns retryAfterSeconds and keeps the failure in state', () async {
      when(() => repository.requestOtp(phone))
          .thenAnswer((_) async => const Left(TooManyRequestsFailure(42)));
      final sub = container.listen(otpControllerProvider, (_, _) {});

      expect(await container.read(otpControllerProvider.notifier).resend(phone), 42);
      expect(sub.read().error, const TooManyRequestsFailure(42));
    });

    test('verify on 429 keeps TooManyRequestsFailure in state', () async {
      when(() => repository.verifyOtp(phone: phone, code: '12345'))
          .thenAnswer((_) async => const Left(TooManyRequestsFailure(30)));
      final sub = container.listen(otpControllerProvider, (_, _) {});

      final ok = await container
          .read(otpControllerProvider.notifier)
          .verify(phone: phone, code: '12345');

      expect(ok, isFalse);
      expect(sub.read().error, const TooManyRequestsFailure(30));
    });

    test('resend on 502 keeps SmsSendFailure in state', () async {
      when(() => repository.requestOtp(phone))
          .thenAnswer((_) async => const Left(SmsSendFailure()));
      final sub = container.listen(otpControllerProvider, (_, _) {});

      expect(await container.read(otpControllerProvider.notifier).resend(phone), isNull);
      expect(sub.read().error, isA<SmsSendFailure>());
    });
  });
}
