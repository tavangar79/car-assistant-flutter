import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/pages/phone_page.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/otp_args.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

Widget buildApp(AuthRepository repository, {Locale locale = const Locale('en')}) {
  final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const PhonePage()),
      GoRoute(
        path: '/login/otp',
        builder: (context, state) {
          final args = state.extra! as OtpArgs;
          return Text('otp ${args.phone} ${args.resendInSeconds} ${args.codeLength}');
        },
      ),
    ],
  );
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp.router(
      theme: AppTheme.dark,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    ),
  );
}

void main() {
  const phone = '09121234567';
  late MockAuthRepository repository;

  setUp(() => repository = MockAuthRepository());

  Future<void> submit(WidgetTester tester, String input) async {
    await tester.enterText(find.byType(TextField), input);
    await tester.tap(find.text('Get code'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the design in Persian (RTL)', (tester) async {
    await tester.pumpWidget(buildApp(repository, locale: const Locale('fa')));
    await tester.pumpAndSettle();

    expect(Directionality.of(tester.element(find.byType(PhonePage))), TextDirection.rtl);
    expect(find.text('ورود یا ثبت‌نام'), findsOneWidget);
    expect(find.text('شماره موبایل'), findsOneWidget);
    expect(find.text('دریافت کد تأیید'), findsOneWidget);
    expect(find.text('۰۹۱۲۳۴۵۶۷۸۹'), findsOneWidget); // localized hint
    expect(tester.getSize(find.byType(FilledButton)).height, greaterThanOrEqualTo(64));
  });

  testWidgets('sends the normalized number and opens the code page', (tester) async {
    when(() => repository.requestOtp(phone)).thenAnswer(
      (_) async => const OtpRequest(
        phone: phone,
        expiresInSeconds: 120,
        resendInSeconds: 60,
        codeLength: 5,
        isRegistered: false,
      ),
    );
    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    await submit(tester, '۰۹۱۲ ۱۲۳ ۴۵۶۷');

    verify(() => repository.requestOtp(phone)).called(1);
    expect(find.text('otp $phone 60 5'), findsOneWidget);
  });

  testWidgets('accepts a full international number with spaces and dashes', (tester) async {
    when(() => repository.requestOtp(phone)).thenAnswer(
      (_) async => const OtpRequest(
        phone: phone,
        expiresInSeconds: 120,
        resendInSeconds: 60,
        codeLength: 5,
        isRegistered: true,
      ),
    );
    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    await submit(tester, '0098 912-123-4567');

    verify(() => repository.requestOtp(phone)).called(1);
  });

  testWidgets('validates the number before calling the API', (tester) async {
    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    await submit(tester, '0912');

    expect(find.text('Enter a valid mobile number'), findsOneWidget);
    verifyNever(() => repository.requestOtp(any()));
  });

  testWidgets('shows the SMS error on 502', (tester) async {
    when(() => repository.requestOtp(phone)).thenThrow(const SmsSendFailure());
    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    await submit(tester, phone);

    expect(find.text("Couldn't send the SMS, try again"), findsOneWidget);
  });

  testWidgets('shows a generic error when offline', (tester) async {
    when(() => repository.requestOtp(phone)).thenThrow(const NetworkFailure());
    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    await submit(tester, phone);

    expect(find.text('Something went wrong, try again'), findsOneWidget);
  });

  testWidgets('on 429 opens the code page with the retry countdown', (tester) async {
    when(() => repository.requestOtp(phone)).thenThrow(const TooManyRequestsFailure(42));
    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    await submit(tester, phone);

    expect(find.text('otp $phone 42 ${OtpArgs.defaultCodeLength}'), findsOneWidget);
  });

  testWidgets('on 429 opens the code page with the server codeLength', (tester) async {
    when(() => repository.requestOtp(phone))
        .thenThrow(const TooManyRequestsFailure(42, codeLength: 6));
    await tester.pumpWidget(buildApp(repository));
    await tester.pumpAndSettle();

    await submit(tester, phone);

    expect(find.text('otp $phone 42 6'), findsOneWidget);
  });
}
