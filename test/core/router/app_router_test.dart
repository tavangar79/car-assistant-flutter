import 'package:car_assistant/app.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_result.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/pages/otp_page.dart';
import 'package:car_assistant/features/auth/presentation/pages/phone_page.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/splash/presentation/pages/splash_page.dart';
import 'package:car_assistant/features/splash/presentation/providers/splash_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const delay = Duration(milliseconds: 500);
  late MockVehicleRepository vehicles;
  late MockAuthRepository auth;

  setUp(() {
    vehicles = MockVehicleRepository();
    auth = MockAuthRepository();
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([]));
  });

  Widget app() => ProviderScope(
    overrides: [
      vehicleRepositoryProvider.overrideWithValue(vehicles),
      authRepositoryProvider.overrideWithValue(auth),
      splashDelayProvider.overrideWithValue(delay),
      packageInfoProvider.overrideWith(
        (ref) async => PackageInfo(
          appName: 'car_assistant',
          packageName: 'car_assistant',
          version: '1.0.0',
          buildNumber: '1',
        ),
      ),
    ],
    child: const CarAssistantApp(),
  );

  Future<void> passSplash(WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.pump();
    expect(find.byType(SplashPage), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(SplashPage))), TextDirection.rtl);
    await tester.pump(delay);
    await tester.pumpAndSettle();
  }

  testWidgets('with a valid session: splash, then vehicles (RTL)', (tester) async {
    when(() => auth.hasSession()).thenAnswer((_) async => true);
    when(() => auth.getCurrentUser()).thenAnswer(
      (_) async => Right(User(id: 'u1', phone: '09121234567', createdAt: DateTime.utc(2026))),
    );

    await passSplash(tester);

    expect(find.byType(SplashPage), findsNothing);
    expect(find.byType(VehiclesPage), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(VehiclesPage))), TextDirection.rtl);
  });

  testWidgets('without a token: splash, then the phone page', (tester) async {
    when(() => auth.hasSession()).thenAnswer((_) async => false);

    await passSplash(tester);

    expect(find.byType(PhonePage), findsOneWidget);
    expect(find.byType(VehiclesPage), findsNothing);
  });

  testWidgets('when /me returns 401: clears the token and shows the phone page', (tester) async {
    when(() => auth.hasSession()).thenAnswer((_) async => true);
    when(() => auth.getCurrentUser()).thenAnswer((_) async => const Left(UnauthorizedFailure()));
    when(() => auth.clearSession()).thenAnswer((_) async => const Right(unit));

    await passSplash(tester);

    expect(find.byType(PhonePage), findsOneWidget);
    verify(() => auth.clearSession()).called(1);
  });

  testWidgets('logout from vehicles returns to the phone page', (tester) async {
    when(() => auth.hasSession()).thenAnswer((_) async => true);
    when(() => auth.getCurrentUser()).thenAnswer(
      (_) async => Right(User(id: 'u1', phone: '09121234567', createdAt: DateTime.utc(2026))),
    );
    when(() => auth.clearSession()).thenAnswer((_) async => const Right(unit));
    await passSplash(tester);

    await tester.tap(find.byTooltip('خروج از حساب'));
    await tester.pumpAndSettle();

    verify(() => auth.clearSession()).called(1);
    expect(find.byType(PhonePage), findsOneWidget);
  });

  testWidgets('logout then sign in again: the router opens vehicles and refetches them', (
    tester,
  ) async {
    const phone = '09121234567';
    final user = User(id: 'u1', phone: phone, createdAt: DateTime.utc(2026));
    when(() => auth.hasSession()).thenAnswer((_) async => true);
    when(() => auth.getCurrentUser()).thenAnswer((_) async => Right(user));
    when(() => auth.clearSession()).thenAnswer((_) async => const Right(unit));
    when(() => auth.requestOtp(phone)).thenAnswer(
      (_) async => const Right(
        OtpRequest(
          phone: phone,
          expiresInSeconds: 120,
          resendInSeconds: 60,
          codeLength: 5,
          isRegistered: true,
        ),
      ),
    );
    when(() => auth.verifyOtp(phone: phone, code: '12345'))
        .thenAnswer((_) async => Right(AuthResult(user: user, isNewUser: false)));
    await passSplash(tester);
    verify(() => vehicles.getVehicles()).called(1);

    await tester.tap(find.byTooltip('خروج از حساب'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), phone);
    await tester.pump(); // the button enables once the number is valid
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.byType(OtpPage), findsOneWidget);

    await tester.enterText(find.byType(TextField), '12345');
    await tester.pumpAndSettle();

    expect(find.byType(VehiclesPage), findsOneWidget);
    verify(() => vehicles.getVehicles()).called(1); // fresh list, not the previous user's
  });
}
