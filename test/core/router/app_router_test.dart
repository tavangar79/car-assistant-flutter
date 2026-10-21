import 'package:car_assistant/app.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_result.dart';
import 'package:car_assistant/features/auth/domain/entities/otp_request.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/pages/complete_profile_page.dart';
import 'package:car_assistant/features/auth/presentation/pages/otp_page.dart';
import 'package:car_assistant/features/auth/presentation/pages/phone_page.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/home/presentation/pages/home_page.dart';
import 'package:car_assistant/features/profile/domain/entities/profile_stats.dart';
import 'package:car_assistant/features/profile/domain/repositories/profile_repository.dart';
import 'package:car_assistant/features/profile/presentation/providers/profile_providers.dart';
import 'package:car_assistant/features/splash/presentation/pages/splash_page.dart';
import 'package:car_assistant/features/splash/presentation/providers/splash_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  const delay = Duration(milliseconds: 500);
  late MockVehicleRepository vehicles;
  late MockAuthRepository auth;
  late MockProfileRepository profile;

  setUp(() {
    vehicles = MockVehicleRepository();
    auth = MockAuthRepository();
    profile = MockProfileRepository();
    when(() => profile.getStats()).thenAnswer(
      (_) async => const Right(ProfileStats(vehicleCount: 0, serviceCount: 0, documentCount: 0)),
    );
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([]));
  });

  Widget app() => ProviderScope(
    overrides: [
      vehicleRepositoryProvider.overrideWithValue(vehicles),
      authRepositoryProvider.overrideWithValue(auth),
      profileRepositoryProvider.overrideWithValue(profile),
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

  testWidgets('with a valid session: splash, then the home tab (RTL)', (tester) async {
    when(() => auth.hasSession()).thenAnswer((_) async => true);
    when(() => auth.getCurrentUser()).thenAnswer(
      (_) async => Right(
        User(
          id: 'u1',
          phone: '09121234567',
          createdAt: DateTime.utc(2026),
          isProfileComplete: true,
        ),
      ),
    );

    await passSplash(tester);

    expect(find.byType(SplashPage), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(HomePage))), TextDirection.rtl);
  });

  testWidgets('without a token: splash, then the phone page', (tester) async {
    when(() => auth.hasSession()).thenAnswer((_) async => false);

    await passSplash(tester);

    expect(find.byType(PhonePage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('when /me returns 401: clears the token and shows the phone page', (tester) async {
    when(() => auth.hasSession()).thenAnswer((_) async => true);
    when(() => auth.getCurrentUser()).thenAnswer((_) async => const Left(UnauthorizedFailure()));
    when(() => auth.clearSession()).thenAnswer((_) async => const Right(unit));

    await passSplash(tester);

    expect(find.byType(PhonePage), findsOneWidget);
    verify(() => auth.clearSession()).called(1);
  });

  testWidgets('logout from the profile tab returns to the phone page', (tester) async {
    when(() => auth.hasSession()).thenAnswer((_) async => true);
    when(() => auth.getCurrentUser()).thenAnswer(
      (_) async => Right(
        User(
          id: 'u1',
          phone: '09121234567',
          createdAt: DateTime.utc(2026),
          isProfileComplete: true,
        ),
      ),
    );
    when(() => auth.clearSession()).thenAnswer((_) async => const Right(unit));
    await passSplash(tester);

    await tester.tap(find.text('پروفایل'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('خروج از حساب کاربری'), 200);
    await tester.tap(find.text('خروج از حساب کاربری'));
    await tester.pumpAndSettle();

    verify(() => auth.clearSession()).called(1);
    expect(find.byType(PhonePage), findsOneWidget);
  });

  testWidgets('logout then sign in again: the router opens home and refetches them', (
    tester,
  ) async {
    const phone = '09121234567';
    final user = User(
      id: 'u1',
      phone: phone,
      createdAt: DateTime.utc(2026),
      isProfileComplete: true,
    );
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

    await tester.tap(find.text('پروفایل'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('خروج از حساب کاربری'), 200);
    await tester.tap(find.text('خروج از حساب کاربری'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), phone);
    await tester.pump(); // the button enables once the number is valid
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.byType(OtpPage), findsOneWidget);

    await tester.enterText(find.byType(TextField), '12345');
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    verify(() => vehicles.getVehicles()).called(1); // fresh list, not the previous user's
  });

  testWidgets('incomplete profile: splash, then complete-profile; saving opens home', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390 * 3, 1600 * 3)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    registerFallbackValue(DateTime(2000));
    final incomplete = User(
      id: 'u1',
      phone: '09121234567',
      createdAt: DateTime.utc(2026),
      isProfileComplete: false,
    );
    when(() => auth.hasSession()).thenAnswer((_) async => true);
    when(() => auth.getCurrentUser()).thenAnswer((_) async => Right(incomplete));
    when(
      () => auth.updateProfile(
        firstName: any(named: 'firstName'),
        lastName: any(named: 'lastName'),
        birthDate: any(named: 'birthDate'),
      ),
    ).thenAnswer(
      (_) async => Right(
        User(
          id: 'u1',
          phone: '09121234567',
          createdAt: DateTime.utc(2026),
          firstName: 'علی',
          lastName: 'محمدی',
          birthDate: DateTime(1991, 11, 12),
          isProfileComplete: true,
        ),
      ),
    );

    await passSplash(tester);
    expect(find.byType(CompleteProfilePage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);

    await tester.enterText(find.byType(TextField).at(0), 'علی');
    await tester.enterText(find.byType(TextField).at(1), 'محمدی');
    await tester.tap(find.text('انتخاب تاریخ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تأیید تاریخ تولد'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تأیید و ذخیره اطلاعات'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });
}
