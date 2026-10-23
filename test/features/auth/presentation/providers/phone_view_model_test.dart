import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/otp_args.dart';
import 'package:car_assistant/features/auth/presentation/providers/phone_state.dart';
import 'package:car_assistant/features/auth/presentation/providers/phone_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const phone = '09121234567';
  const otpRequest = OtpRequest(
    phone: phone,
    expiresInSeconds: 120,
    resendInSeconds: 60,
    codeLength: 5,
    isRegistered: true,
  );

  late MockAuthRepository repository;
  late ProviderSubscription<PhoneState> sub;
  late PhoneViewModel viewModel;

  setUp(() {
    repository = MockAuthRepository();
    final container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    sub = container.listen(phoneViewModelProvider, (_, _) {});
    viewModel = container.read(phoneViewModelProvider.notifier);
  });

  test('starts empty and invalid', () {
    expect(sub.read(), const PhoneState());
    expect(sub.read().isValid, isFalse);
  });

  test('phoneChanged keeps the national digits and validates them', () {
    viewModel.phoneChanged('912 123');
    expect(sub.read().digits, '912123');
    expect(sub.read().isValid, isFalse);

    viewModel.phoneChanged('۰۹۱۲۱۲۳۴۵۶۷');
    expect(sub.read().digits, '9121234567');
    expect(sub.read().phone, phone);
    expect(sub.read().isValid, isTrue);
  });

  test('a complete non-mobile number is invalid', () {
    viewModel.phoneChanged('1121234567');

    expect(sub.read().isValid, isFalse);
  });

  test('submit returns code page args on success and stops loading', () async {
    when(() => repository.requestOtp(phone)).thenAnswer((_) async => const Right(otpRequest));
    viewModel.phoneChanged('9121234567');

    final future = viewModel.submit();
    expect(sub.read().isSubmitting, isTrue);
    final args = await future;

    expect(args, const OtpArgs(phone: phone, resendInSeconds: 60, codeLength: 5));
    expect(sub.read().isSubmitting, isFalse);
    expect(sub.read().failure, isNull);
  });

  test('submit keeps InvalidPhoneFailure in state and does not call the API', () async {
    viewModel.phoneChanged('912');

    expect(await viewModel.submit(), isNull);
    expect(sub.read().failure, isA<InvalidPhoneFailure>());
    verifyNever(() => repository.requestOtp(any()));
  });

  test('submit on 429 continues to the code page with retryAfterSeconds', () async {
    when(() => repository.requestOtp(phone))
        .thenAnswer((_) async => const Left(TooManyRequestsFailure(42)));
    viewModel.phoneChanged('9121234567');

    expect(
      await viewModel.submit(),
      const OtpArgs(phone: phone, resendInSeconds: 42, codeLength: OtpArgs.defaultCodeLength),
    );
  });

  test('submit on 429 uses the codeLength the server sent', () async {
    when(() => repository.requestOtp(phone))
        .thenAnswer((_) async => const Left(TooManyRequestsFailure(42, codeLength: 6)));
    viewModel.phoneChanged('9121234567');

    expect(
      await viewModel.submit(),
      const OtpArgs(phone: phone, resendInSeconds: 42, codeLength: 6),
    );
  });

  test('submit keeps SmsSendFailure in state; editing the number clears it', () async {
    when(() => repository.requestOtp(phone)).thenAnswer((_) async => const Left(SmsSendFailure()));
    viewModel.phoneChanged('9121234567');

    expect(await viewModel.submit(), isNull);
    expect(sub.read().failure, isA<SmsSendFailure>());
    expect(sub.read().isSubmitting, isFalse);

    viewModel.phoneChanged('912123456');
    expect(sub.read().failure, isNull);
  });
}
