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
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const phone = '09121234567';

Widget buildApp(
  AuthRepository repository, {
  int resendInSeconds = 60,
  int codeLength = 5,
  Locale locale = const Locale('en'),
}) {
  final router = GoRouter(
    initialLocation: '/login/otp',
    initialExtra: OtpArgs(phone: phone, resendInSeconds: resendInSeconds, codeLength: codeLength),
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const Text('phone page')),
      GoRoute(
        path: '/login/otp',
        builder: (context, state) => OtpPage(args: state.extra! as OtpArgs),
      ),
      GoRoute(path: '/vehicles', builder: (context, state) => const Text('vehicles')),
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
  late MockAuthRepository repository;
  final result = AuthResult(
    user: User(id: 'u1', phone: phone, createdAt: DateTime.utc(2026)),
    isNewUser: true,
  );

  setUp(() => repository = MockAuthRepository());

  testWidgets('shows 5 boxes, the phone in Persian digits and the countdown (fa)', (tester) async {
    await tester.pumpWidget(buildApp(repository, resendInSeconds: 45, locale: const Locale('fa')));
    await tester.pump();

    expect(Directionality.of(tester.element(find.byType(OtpPage))), TextDirection.rtl);
    expect(find.text('کد تأیید را وارد کنید'), findsOneWidget);
    expect(find.text('کد تأیید به ۰۹۱۲۱۲۳۴۵۶۷ پیامک شد'), findsOneWidget);
    expect(find.text('ارسال دوباره کد تا ۰:۴۵'), findsOneWidget);
    final boxes = find.byWidgetPredicate((w) => w is Container && w.constraints?.maxHeight == 64);
    expect(boxes, findsNWidgets(5));
  });

  testWidgets('verifies automatically after 5 digits and signs in', (tester) async {
    when(() => repository.verifyOtp(phone: phone, code: '12345')).thenAnswer((_) async => result);
    await tester.pumpWidget(buildApp(repository));
    await tester.pump();

    await tester.enterText(find.byType(TextField), '۱۲۳۴۵');
    await tester.pumpAndSettle();

    verify(() => repository.verifyOtp(phone: phone, code: '12345')).called(1);
    final container = ProviderScope.containerOf(tester.element(find.byType(OtpPage)));
    expect(container.read(authStatusProvider), AuthStatus.signedIn);
    // Leaving the page is the router guard's job (see app_router_test), not the page's.
    expect(find.text('vehicles'), findsNothing);
  });

  testWidgets('uses the code length from the server', (tester) async {
    when(() => repository.verifyOtp(phone: phone, code: '123456')).thenAnswer((_) async => result);
    await tester.pumpWidget(buildApp(repository, codeLength: 6));
    await tester.pump();

    final boxes = find.byWidgetPredicate((w) => w is Container && w.constraints?.maxHeight == 64);
    expect(boxes, findsNWidgets(6));

    await tester.enterText(find.byType(TextField), '12345');
    await tester.pump();
    verifyNever(
      () => repository.verifyOtp(
        phone: phone,
        code: any(named: 'code'),
      ),
    );

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pumpAndSettle();
    verify(() => repository.verifyOtp(phone: phone, code: '123456')).called(1);
  });

  testWidgets('shows the rate-limit message when verify gets 429', (tester) async {
    when(() => repository.verifyOtp(phone: phone, code: '12345'))
        .thenThrow(const TooManyRequestsFailure(30));
    await tester.pumpWidget(buildApp(repository));
    await tester.pump();

    await tester.enterText(find.byType(TextField), '12345');
    await tester.pump();
    await tester.pump();

    expect(find.text('Too many tries, try again in 0:30'), findsOneWidget);
  });

  testWidgets('verify button sends a shorter code as typed', (tester) async {
    when(() => repository.verifyOtp(phone: phone, code: '1234')).thenAnswer((_) async => result);
    await tester.pumpWidget(buildApp(repository));
    await tester.pump();

    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();
    await tester.tap(find.text('Verify and sign in'));
    await tester.pumpAndSettle();

    verify(() => repository.verifyOtp(phone: phone, code: '1234')).called(1);
  });

  testWidgets('shows "invalid or expired code" on 401 and clears the boxes', (tester) async {
    when(() => repository.verifyOtp(phone: phone, code: '00000'))
        .thenThrow(const InvalidCodeFailure());
    await tester.pumpWidget(buildApp(repository));
    await tester.pump();

    await tester.enterText(find.byType(TextField), '00000');
    await tester.pump();
    await tester.pump();

    expect(find.text('Invalid or expired code'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
  });

  testWidgets('counts down, then resends and restarts the countdown', (tester) async {
    when(() => repository.requestOtp(phone)).thenAnswer(
      (_) async => const OtpRequest(
        phone: phone,
        expiresInSeconds: 120,
        resendInSeconds: 60,
        codeLength: 5,
        isRegistered: true,
      ),
    );
    await tester.pumpWidget(buildApp(repository, resendInSeconds: 2));
    await tester.pump();

    expect(find.text('Resend code in 0:02'), findsOneWidget);
    expect(find.text('Resend code'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Resend code in 0:01'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Resend code'));
    await tester.pump();
    await tester.pump();

    verify(() => repository.requestOtp(phone)).called(1);
    expect(find.text('Resend code in 1:00'), findsOneWidget);
    expect(find.text('A new code is on its way'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5)); // let the snackbar timer finish
  });

  testWidgets('resend on 429 restarts the countdown and shows the rate limit', (tester) async {
    when(() => repository.requestOtp(phone)).thenThrow(const TooManyRequestsFailure(42));
    await tester.pumpWidget(buildApp(repository, resendInSeconds: 0));
    await tester.pump();

    await tester.tap(find.text('Resend code'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Resend code in 0:42'), findsOneWidget);
    expect(find.text('Too many tries, try again in 0:42'), findsOneWidget);
    expect(find.text('A new code is on its way'), findsNothing);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('shows the SMS error when resend fails with 502', (tester) async {
    when(() => repository.requestOtp(phone)).thenThrow(const SmsSendFailure());
    await tester.pumpWidget(buildApp(repository, resendInSeconds: 0));
    await tester.pump();

    await tester.tap(find.text('Resend code'));
    await tester.pump();
    await tester.pump();

    expect(find.text("Couldn't send the SMS, try again"), findsOneWidget);
    expect(find.text('Resend code'), findsOneWidget);
  });

  testWidgets('change number goes back to the phone page', (tester) async {
    await tester.pumpWidget(buildApp(repository));
    await tester.pump();

    await tester.tap(find.text('Change number'));
    await tester.pumpAndSettle();

    expect(find.text('phone page'), findsOneWidget);
  });
}
