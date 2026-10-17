import 'package:car_assistant/core/router/app_routes.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:car_assistant/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/pages/phone_page.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/otp_args.dart';
import 'package:car_assistant/features/auth/presentation/widgets/phone_digits_status.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_token_storage.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDio extends Mock implements Dio {}

const _phone = '09121234567';
const _request = OtpRequest(
  phone: _phone,
  expiresInSeconds: 120,
  resendInSeconds: 60,
  codeLength: 5,
  isRegistered: false,
);

void main() {
  late AuthRepository repository;
  OtpArgs? openedWith;

  setUp(() {
    repository = MockAuthRepository();
    openedWith = null;
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390 * 3, 1000 * 3)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: AppRoutes.phonePath,
      routes: [
        GoRoute(
          path: AppRoutes.phonePath,
          name: AppRoutes.phoneName,
          builder: (context, state) => const PhonePage(),
          routes: [
            GoRoute(
              path: 'otp',
              name: AppRoutes.otpName,
              builder: (context, state) {
                openedWith = state.extra as OtpArgs?;
                return const Text('otp page');
              },
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp.router(
          theme: AppTheme.dark, // the page switches itself to the light Stitch theme
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  FilledButton cta(WidgetTester tester) => tester.widget(find.byType(FilledButton));

  /// Real repository and data source over a Dio that answers the OTP request with [answer].
  MockDio useRealRepository(Future<Response<Map<String, dynamic>>> Function() answer) {
    final dio = MockDio();
    when(() => dio.post<Map<String, dynamic>>('/api/auth/otp/request', data: any(named: 'data')))
        .thenAnswer((_) => answer());
    repository = AuthRepositoryImpl(
      remote: AuthRemoteDataSource(dio),
      tokenStorage: FakeTokenStorage(),
    );
    return dio;
  }

  Future<void> submitPhone(WidgetTester tester, String phone) async {
    await tester.enterText(find.byType(TextField), phone);
    await tester.pump();
    expect(cta(tester).onPressed, isNotNull);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the Stitch content in Persian, on the light theme', (tester) async {
    await pumpPage(tester);

    expect(find.text('مدیریت خودرو'), findsOneWidget);
    expect(find.text('دفتر کل اختصاصی هزینه‌های اتومبیل'), findsOneWidget);
    expect(find.text('ورود یا ایجاد حساب کاربری'), findsOneWidget);
    expect(find.text('شماره تلفن همراه'), findsOneWidget);
    expect(find.text('+98'), findsOneWidget);
    expect(find.text('مزایای ثبت و مدیریت در سامانه'), findsOneWidget);
    expect(find.text('یادآور هوشمند سرویس‌ها'), findsOneWidget);
    expect(find.text('ثبت دقیق فاکتورها و هزینه‌ها'), findsOneWidget);
    expect(find.text('انتقال آنلاین سوابق خودرو'), findsOneWidget);
    expect(find.text('دریافت کد تایید'), findsOneWidget);
    expect(find.textContaining('قوانین و مقررات', findRichText: true), findsOneWidget);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, AppTheme.light.colorScheme.surface);
    expect(Directionality.of(tester.element(find.byType(PhonePage))), TextDirection.rtl);
  });

  testWidgets('counts digits and enables the button once the number is valid', (tester) async {
    await pumpPage(tester);
    expect(find.text('۰ از ۱۰ رقم'), findsOneWidget);
    expect(cta(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '0912123');
    await tester.pump();
    expect(find.text('912 123'), findsOneWidget);
    expect(find.text('۶ از ۱۰ رقم'), findsOneWidget);
    expect(cta(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '۹۱۲۱۲۳۴۵۶۷');
    await tester.pump();
    expect(find.text('۱۱ رقم کامل شد'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(cta(tester).onPressed, isNotNull);
  });

  testWidgets('flags a complete number that is not a mobile number', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), '1121234567');
    await tester.pump();

    expect(find.text('شماره موبایل معتبر نیست'), findsOneWidget);
    expect(cta(tester).onPressed, isNull);
  });

  testWidgets('requests a code and opens the code page', (tester) async {
    when(() => repository.requestOtp(_phone)).thenAnswer((_) async => const Right(_request));
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), '9121234567');
    await tester.pump();
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    verify(() => repository.requestOtp(_phone)).called(1);
    expect(find.text('otp page'), findsOneWidget);
    expect(openedWith, const OtpArgs(phone: _phone, resendInSeconds: 60, codeLength: 5));
  });

  testWidgets('shows a localized error when the SMS cannot be sent', (tester) async {
    when(() => repository.requestOtp(_phone)).thenAnswer((_) async => const Left(SmsSendFailure()));
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), '9121234567');
    await tester.pump();
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('ارسال پیامک ممکن نشد، دوباره تلاش کنید'), findsOneWidget);
    expect(find.text('otp page'), findsNothing);
  });

  for (final input in ['0912 123 4567', '912 123 4567', '+989121234567', '۰۹۱۲۱۲۳۴۵۶۷']) {
    testWidgets('accepts "$input" and requests the code for 09121234567', (tester) async {
      when(() => repository.requestOtp(_phone)).thenAnswer((_) async => const Right(_request));
      await pumpPage(tester);

      await submitPhone(tester, input);

      verify(() => repository.requestOtp(_phone)).called(1);
      expect(find.text('otp page'), findsOneWidget);
    });
  }

  testWidgets('a 500 from the server shows the generic error and stops loading', (tester) async {
    final dio = useRealRepository(
      () => Future.error(
        DioException.badResponse(
          statusCode: 500,
          requestOptions: RequestOptions(path: '/api/auth/otp/request'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/auth/otp/request'),
            statusCode: 500,
            data: {
              'error': {'message': 'Internal server error'},
            },
          ),
        ),
      ),
    );
    await pumpPage(tester);

    await submitPhone(tester, '0912 123 4567');

    verify(() => dio.post<Map<String, dynamic>>('/api/auth/otp/request', data: {'phone': _phone}))
        .called(1);
    expect(find.text('مشکلی پیش آمد، دوباره تلاش کنید'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(cta(tester).onPressed, isNotNull); // the user can try again
    expect(find.text('otp page'), findsNothing);
  });

  testWidgets('no response (offline, CORS, timeout) shows the generic error', (tester) async {
    useRealRepository(
      () => Future.error(
        DioException.connectionError(
          requestOptions: RequestOptions(),
          reason: 'XMLHttpRequest error',
        ),
      ),
    );
    await pumpPage(tester);

    await submitPhone(tester, '9121234567');

    expect(find.text('مشکلی پیش آمد، دوباره تلاش کنید'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('a malformed success body shows the generic error', (tester) async {
    useRealRepository(
      () async => Response(requestOptions: RequestOptions(), statusCode: 200, data: {'oops': 1}),
    );
    await pumpPage(tester);

    await submitPhone(tester, '9121234567');

    expect(find.text('مشکلی پیش آمد، دوباره تلاش کنید'), findsOneWidget);
  });

  testWidgets('the phone text is vertically centered in its field', (tester) async {
    await pumpPage(tester);
    await tester.enterText(find.byType(TextField), '9121234567');
    await tester.pump();

    final field = tester.getRect(
      find.ancestor(of: find.byType(TextField), matching: find.byType(Container)).first,
    );
    final text = tester.getRect(find.byType(EditableText));

    expect(field.height, 48);
    expect((text.center.dy - field.center.dy).abs(), lessThan(1));
  });

  testWidgets('the digit status sits at the physical left edge, left of the SMS hint (RTL)', (
    tester,
  ) async {
    await pumpPage(tester);
    final row = tester.getRect(find.byType(PhoneDigitsStatus));
    final hint = tester.getRect(find.text('ارسال کد تایید پیامکی'));

    for (final input in ['912', '9121234567', '1121234567']) {
      await tester.enterText(find.byType(TextField), input);
      await tester.pump();
      final status = tester.getRect(
        find.text(switch (input) {
          '912' => '۳ از ۱۰ رقم',
          '9121234567' => '۱۱ رقم کامل شد',
          _ => 'شماره موبایل معتبر نیست',
        }).last,
      );

      expect(status.left, moreOrLessEquals(row.left, epsilon: 0.5), reason: input);
      expect(status.right, lessThanOrEqualTo(hint.left), reason: input);
    }
  });
}
