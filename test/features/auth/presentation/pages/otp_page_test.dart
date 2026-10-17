import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_result.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/pages/otp_page.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:car_assistant/features/auth/presentation/providers/otp_args.dart';
import 'package:car_assistant/features/auth/presentation/widgets/masked_phone_card.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const _phone = '09121236789';
const _args = OtpArgs(phone: _phone, resendInSeconds: 45, codeLength: 5);

void main() {
  late MockAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390 * 3, 1000 * 3)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.dark,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const OtpPage(args: _args),
        ),
      ),
    );
    await tester.pump();
  }

  test('masks the phone as 0912 ••• 6789 with locale digits', () {
    expect(MaskedPhoneCard.mask(_phone, 'en'), '0912 ••• 6789');
    expect(MaskedPhoneCard.mask(_phone, 'fa'), '۰۹۱۲ ••• ۶۷۸۹');
  });

  testWidgets('shows the Stitch content, masked phone and countdown', (tester) async {
    await pumpPage(tester);

    expect(find.text('کد تأیید را وارد کنید'), findsOneWidget);
    expect(find.text('کد تأیید ۵ رقمی به شماره زیر پیامک شد:'), findsOneWidget);
    expect(find.text('۰۹۱۲ ••• ۶۷۸۹'), findsOneWidget);
    expect(find.text('ویرایش شماره'), findsOneWidget);
    expect(find.text('کد ۵ رقمی ارسالی'), findsOneWidget);
    expect(find.text('۰ از ۵ رقم درج شد'), findsOneWidget);
    expect(find.text('ارسال مجدد تا'), findsOneWidget);
    expect(find.text('۰۰:۴۵'), findsOneWidget);
    expect(find.text('تأیید و ادامه'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('۰۰:۴۲'), findsOneWidget);
  });

  testWidgets('fills the boxes with Persian digits and signs in when complete', (tester) async {
    final user = User(id: 'u1', phone: _phone, createdAt: DateTime.utc(2026));
    when(() => repository.verifyOtp(phone: _phone, code: '12345'))
        .thenAnswer((_) async => Right(AuthResult(user: user, isNewUser: false)));
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), '۱۲');
    await tester.pump();
    expect(find.text('۱'), findsOneWidget);
    expect(find.text('۲'), findsOneWidget);
    expect(find.text('۲ از ۵ رقم درج شد'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '12345');
    await tester.pump();

    verify(() => repository.verifyOtp(phone: _phone, code: '12345')).called(1);
    expect(container.read(authStatusProvider), AuthStatus.signedIn);
  });

  testWidgets('shows a wrong code error and clears the boxes', (tester) async {
    when(() => repository.verifyOtp(phone: _phone, code: '00000'))
        .thenAnswer((_) async => const Left(InvalidCodeFailure()));
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), '00000');
    await tester.pump();

    expect(find.text('کد نادرست است یا منقضی شده'), findsOneWidget);
    expect(find.text('۰ از ۵ رقم درج شد'), findsOneWidget);
  });

  testWidgets('enables resend at zero and restarts the countdown', (tester) async {
    when(() => repository.requestOtp(_phone)).thenAnswer(
      (_) async => const Right(
        OtpRequest(
          phone: _phone,
          expiresInSeconds: 120,
          resendInSeconds: 60,
          codeLength: 5,
          isRegistered: true,
        ),
      ),
    );
    await pumpPage(tester);
    TextButton resend() => tester.widget(find.widgetWithText(TextButton, 'ارسال مجدد کد پیامکی'));
    expect(resend().onPressed, isNull);

    await tester.pump(const Duration(seconds: 45));
    expect(find.text('۰۰:۰۰'), findsOneWidget);
    expect(resend().onPressed, isNotNull);

    await tester.tap(find.text('ارسال مجدد کد پیامکی'));
    await tester.pump();

    verify(() => repository.requestOtp(_phone)).called(1);
    expect(find.text('۰۱:۰۰'), findsOneWidget);
    expect(find.text('کد جدید پیامک شد'), findsOneWidget);
  });

  testWidgets('shows a generic error for an unexpected failure', (tester) async {
    when(() => repository.verifyOtp(phone: _phone, code: '12345'))
        .thenAnswer((_) async => const Left(Failure('HTTP 500')));
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), '12345');
    await tester.pump();

    expect(find.text('مشکلی پیش آمد، دوباره تلاش کنید'), findsOneWidget);
  });
}
