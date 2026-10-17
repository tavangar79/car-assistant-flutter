import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_result.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/domain/usecases/check_session.dart';
import 'package:car_assistant/features/auth/domain/usecases/logout.dart';
import 'package:car_assistant/features/auth/domain/usecases/request_otp.dart';
import 'package:car_assistant/features/auth/domain/usecases/verify_otp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  const phone = '09121234567';
  final user = User(
    id: 'u1',
    phone: phone,
    createdAt: DateTime.utc(2026, 1, 1),
    isProfileComplete: true,
  );
  const otpRequest = OtpRequest(
    phone: phone,
    expiresInSeconds: 120,
    resendInSeconds: 60,
    codeLength: 5,
    isRegistered: false,
  );

  setUp(() => repository = MockAuthRepository());

  group('RequestOtp', () {
    test('sends the normalized phone', () async {
      when(() => repository.requestOtp(phone)).thenAnswer((_) async => const Right(otpRequest));

      final result = await RequestOtp(repository)('+۹۸۹۱۲۱۲۳۴۵۶۷');

      expect(result, const Right<Failure, OtpRequest>(otpRequest));
      verify(() => repository.requestOtp(phone)).called(1);
    });

    test('returns InvalidPhoneFailure without calling the API', () async {
      expect(
        await RequestOtp(repository)('123'),
        const Left<Failure, OtpRequest>(InvalidPhoneFailure()),
      );
      verifyNever(() => repository.requestOtp(any()));
    });
  });

  group('VerifyOtp', () {
    test('sends the typed code with Latin digits, whatever its length', () async {
      final result = AuthResult(user: user, isNewUser: true);
      when(() => repository.verifyOtp(phone: phone, code: '123456'))
          .thenAnswer((_) async => Right(result));

      expect(
        await VerifyOtp(repository)(phone: phone, code: '۱۲۳۴۵۶'),
        Right<Failure, AuthResult>(result),
      );
    });

    test(
      'returns InvalidCodeFailure for an empty or non-numeric code without calling the API',
      () async {
        for (final code in ['', '12a45']) {
          final result = await VerifyOtp(repository)(phone: phone, code: code);
          expect(result.getLeft().toNullable(), isA<InvalidCodeFailure>());
        }
        verifyNever(
          () => repository.verifyOtp(
            phone: any(named: 'phone'),
            code: any(named: 'code'),
          ),
        );
      },
    );
  });

  group('CheckSession', () {
    test('is signed out without a token', () async {
      when(() => repository.hasSession()).thenAnswer((_) async => false);

      expect((await CheckSession(repository)()).signedIn, isFalse);
      verifyNever(() => repository.getCurrentUser());
    });

    test('is signed in when /me succeeds', () async {
      when(() => repository.hasSession()).thenAnswer((_) async => true);
      when(() => repository.getCurrentUser()).thenAnswer((_) async => Right(user));

      expect(await CheckSession(repository)(), (signedIn: true, user: user));
    });

    test('clears the token and signs out on 401', () async {
      when(() => repository.hasSession()).thenAnswer((_) async => true);
      when(() => repository.getCurrentUser())
          .thenAnswer((_) async => const Left(UnauthorizedFailure()));
      when(() => repository.clearSession()).thenAnswer((_) async => const Right(unit));

      expect((await CheckSession(repository)()).signedIn, isFalse);
      verify(() => repository.clearSession()).called(1);
    });

    test('keeps the session when offline', () async {
      when(() => repository.hasSession()).thenAnswer((_) async => true);
      when(() => repository.getCurrentUser()).thenAnswer((_) async => const Left(NetworkFailure()));

      expect((await CheckSession(repository)()).signedIn, isTrue);
      verifyNever(() => repository.clearSession());
    });

    test('keeps the session on other server errors', () async {
      when(() => repository.hasSession()).thenAnswer((_) async => true);
      when(() => repository.getCurrentUser())
          .thenAnswer((_) async => const Left(Failure('HTTP 500')));

      expect((await CheckSession(repository)()).signedIn, isTrue);
    });
  });

  test('Logout clears the session', () async {
    when(() => repository.clearSession()).thenAnswer((_) async => const Right(unit));

    await Logout(repository)();

    verify(() => repository.clearSession()).called(1);
  });
}
