import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_result.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:car_assistant/features/auth/presentation/providers/otp_args.dart';
import 'package:car_assistant/features/auth/presentation/providers/otp_state.dart';
import 'package:car_assistant/features/auth/presentation/providers/otp_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const phone = '09121234567';
  const args = OtpArgs(phone: phone, resendInSeconds: 60, codeLength: 5);
  final user = User(id: 'u1', phone: phone, createdAt: DateTime.utc(2026), isProfileComplete: true);
  const otpRequest = OtpRequest(
    phone: phone,
    expiresInSeconds: 120,
    resendInSeconds: 90,
    codeLength: 5,
    isRegistered: true,
  );

  late MockAuthRepository repository;
  late ProviderContainer container;
  late ProviderSubscription<OtpState> sub;
  late OtpViewModel viewModel;

  setUp(() {
    repository = MockAuthRepository();
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    sub = container.listen(otpViewModelProvider(args), (_, _) {});
    viewModel = container.read(otpViewModelProvider(args).notifier);
  });

  test('starts empty with the countdown from the args', () {
    expect(sub.read(), const OtpState(codeLength: 5, secondsLeft: 60));
    expect(sub.read().isComplete, isFalse);
  });

  test('a negative cooldown starts at zero', () {
    const late = OtpArgs(phone: phone, resendInSeconds: -3, codeLength: 5);
    container.listen(otpViewModelProvider(late), (_, _) {});

    expect(container.read(otpViewModelProvider(late)).secondsLeft, 0);
  });

  test('codeChanged completes the code at codeLength', () {
    viewModel.codeChanged('1234');
    expect(sub.read().isComplete, isFalse);

    viewModel.codeChanged('12345');
    expect(sub.read().isComplete, isTrue);
  });

  test('verify signs in', () async {
    when(() => repository.verifyOtp(phone: phone, code: '12345'))
        .thenAnswer((_) async => Right(AuthResult(user: user, isNewUser: false)));
    viewModel.codeChanged('12345');

    final future = viewModel.verify();
    expect(sub.read().isVerifying, isTrue);
    await future;

    expect(sub.read().isVerifying, isFalse);
    expect(container.read(authStatusProvider), AuthStatus.signedIn);
  });

  test('verify with an incomplete profile asks to complete it', () async {
    final incomplete = User(
      id: 'u1',
      phone: phone,
      createdAt: DateTime.utc(2026),
      isProfileComplete: false,
    );
    when(() => repository.verifyOtp(phone: phone, code: '12345'))
        .thenAnswer((_) async => Right(AuthResult(user: incomplete, isNewUser: true)));
    viewModel.codeChanged('12345');

    await viewModel.verify();

    expect(container.read(authStatusProvider), AuthStatus.profileIncomplete);
    expect(container.read(currentUserProvider), incomplete);
  });

  test('verify does nothing until the code is complete', () async {
    viewModel.codeChanged('123');

    await viewModel.verify();

    verifyNever(
      () => repository.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
      ),
    );
  });

  test('a wrong code clears the code, keeps the failure and stays signed out', () async {
    when(() => repository.verifyOtp(phone: phone, code: '00000'))
        .thenAnswer((_) async => const Left(InvalidCodeFailure()));
    viewModel.codeChanged('00000');

    await viewModel.verify();

    expect(sub.read().code, '');
    expect(sub.read().failure, isA<InvalidCodeFailure>());
    expect(sub.read().showsCodeError, isTrue);
    expect(container.read(authStatusProvider), AuthStatus.unknown);

    viewModel.codeChanged('1');
    expect(sub.read().showsCodeError, isFalse);
  });

  test('verify on 429 keeps TooManyRequestsFailure in state', () async {
    when(() => repository.verifyOtp(phone: phone, code: '12345'))
        .thenAnswer((_) async => const Left(TooManyRequestsFailure(30)));
    viewModel.codeChanged('12345');

    await viewModel.verify();

    expect(sub.read().failure, const TooManyRequestsFailure(30));
  });

  test('resend restarts the countdown with the new cooldown', () async {
    when(() => repository.requestOtp(phone)).thenAnswer((_) async => const Right(otpRequest));

    final future = viewModel.resend();
    expect(sub.read().isResending, isTrue);

    expect(await future, isTrue);
    expect(sub.read().isResending, isFalse);
    expect(sub.read().secondsLeft, 90);
  });

  test('resend on 429 restarts from retryAfterSeconds and keeps the failure', () async {
    when(() => repository.requestOtp(phone))
        .thenAnswer((_) async => const Left(TooManyRequestsFailure(42)));

    expect(await viewModel.resend(), isFalse);
    expect(sub.read().secondsLeft, 42);
    expect(sub.read().failure, const TooManyRequestsFailure(42));
  });

  test('resend on 502 keeps SmsSendFailure and the countdown', () async {
    when(() => repository.requestOtp(phone)).thenAnswer((_) async => const Left(SmsSendFailure()));

    expect(await viewModel.resend(), isFalse);
    expect(sub.read().failure, isA<SmsSendFailure>());
    expect(sub.read().secondsLeft, 60);
  });
}
