import 'dart:convert';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/avatar_file.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:car_assistant/features/auth/presentation/providers/avatar_picker.dart';
import 'package:car_assistant/features/profile/domain/entities/profile_stats.dart';
import 'package:car_assistant/features/profile/domain/repositories/profile_repository.dart';
import 'package:car_assistant/features/profile/presentation/pages/profile_page.dart';
import 'package:car_assistant/features/profile/presentation/providers/profile_providers.dart';
import 'package:car_assistant/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:car_assistant/features/splash/presentation/providers/splash_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

/// Returns [file] (or throws [error]) instead of opening the gallery.
class FakeAvatarPicker implements AvatarPicker {
  FakeAvatarPicker({this.file, this.error});

  final AvatarFile? file;
  final Object? error;

  @override
  Future<AvatarFile?> pick(AvatarSource source) async {
    if (error case final error?) throw error;
    return file;
  }
}

final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);

/// Created on ۵ فروردین ۱۴۰۲.
final _user = User(
  id: 'u1',
  phone: '09123456789',
  createdAt: DateTime.utc(2023, 3, 25, 8),
  firstName: 'علیرضا',
  lastName: 'محمدی',
  isProfileComplete: true,
);

void main() {
  late MockAuthRepository auth;
  late MockProfileRepository profile;
  late FakeAvatarPicker picker;
  late ProviderContainer container;

  setUpAll(() => registerFallbackValue(AvatarFile(bytes: _png, fileName: 'f.png')));

  setUp(() {
    auth = MockAuthRepository();
    profile = MockProfileRepository();
    picker = FakeAvatarPicker(
      file: AvatarFile(bytes: _png, fileName: 'me.png'),
    );
    when(() => profile.getStats()).thenAnswer(
      (_) async => const Right(ProfileStats(vehicleCount: 2, serviceCount: 18, documentCount: 5)),
    );
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        profileRepositoryProvider.overrideWithValue(profile),
        avatarPickerProvider.overrideWithValue(picker),
        appVersionProvider.overrideWith((ref) async => '1.0.0'),
      ],
    );
    container.read(authStatusProvider.notifier).signIn(_user);
  });

  tearDown(() => container.dispose());

  Future<void> pumpPage(WidgetTester tester, {Locale locale = const Locale('fa')}) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const ProfilePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the identity card: name, grouped phone and Jalali member-since', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('پروفایل'), findsOneWidget);
    expect(find.text('علیرضا محمدی'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget);
    expect(find.text('۰۹۱۲ ۳۴۵ ۶۷۸۹'), findsOneWidget);
    expect(find.text('عضو رسمی از فروردین ۱۴۰۲'), findsOneWidget);
    // No edit flow for a complete profile yet.
    final edit = tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.edit));
    expect(edit.onPressed, isNull);
  });

  testWidgets('shows the basic plan card, and the vehicle, service and document counts', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('۲'), findsOneWidget);
    expect(find.text('خودرو فعال'), findsOneWidget);
    expect(find.text('۱۸'), findsOneWidget);
    expect(find.text('سرویس ثبت‌شده'), findsOneWidget);
    expect(find.text('۵'), findsOneWidget);
    expect(find.text('مدرک در کیف'), findsOneWidget);
    expect(find.text('اشتراک حرفه‌ای'), findsNothing);
    expect(find.text('اشتراک پایه'), findsOneWidget);
    expect(find.text('ارتقا یا تمدید'), findsOneWidget);
  });

  testWidgets('settings and legal rows are shown disabled; the version line is localized', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('تنظیمات و سامانه'), findsOneWidget);
    expect(find.text('ارتباطات و حقوقی'), findsOneWidget);
    for (final title in [
      'تنظیمات یادآورها',
      'اطلاع‌رسانی پیامک',
      'امنیت و رمز عبور',
      'پشتیبانی و تماس با ما',
      'قوانین و حریم خصوصی',
    ]) {
      expect(find.text(title), findsOneWidget);
      expect(
        tester.getSemantics(find.text(title)),
        isSemantics(isEnabled: false, hasEnabledState: true, hint: 'به‌زودی'),
      );
    }
    expect(find.text('نسخه اپلیکیشن ۱٫۰٫۰'), findsOneWidget);
  });

  testWidgets('a stats error shows a localized message and retries', (tester) async {
    when(() => profile.getStats()).thenAnswer((_) async => const Left(Failure('HTTP 500')));
    await pumpPage(tester, locale: const Locale('en'));

    expect(find.text("Couldn't load your stats"), findsOneWidget);

    when(() => profile.getStats()).thenAnswer(
      (_) async => const Right(ProfileStats(vehicleCount: 1, serviceCount: 3, documentCount: 0)),
    );
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Active vehicles'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('"خروج از حساب کاربری" signs out', (tester) async {
    when(() => auth.clearSession()).thenAnswer((_) async => const Right(unit));
    await pumpPage(tester);

    await tester.ensureVisible(find.text('خروج از حساب کاربری'));
    await tester.tap(find.text('خروج از حساب کاربری'));
    await tester.pump();

    verify(() => auth.clearSession()).called(1);
    expect(container.read(authStatusProvider), AuthStatus.signedOut);
  });

  testWidgets('tapping the photo uploads a picked image (existing avatar flow)', (tester) async {
    when(() => auth.uploadAvatar(any())).thenAnswer((_) async => Right(_user));
    await pumpPage(tester);

    await tester.tap(find.byType(ProfileAvatar));
    await tester.pumpAndSettle();
    expect(find.text('حذف تصویر'), findsNothing); // no photo yet
    await tester.tap(find.text('انتخاب از گالری'));
    await tester.pumpAndSettle();

    verify(() => auth.uploadAvatar(any())).called(1);
  });

  testWidgets('an upload failure shows its message in a snack bar', (tester) async {
    when(() => auth.uploadAvatar(any()))
        .thenAnswer((_) async => const Left(AvatarTooLargeFailure('too large')));
    await pumpPage(tester);

    await tester.tap(find.byType(ProfileAvatar));
    await tester.pumpAndSettle();
    await tester.tap(find.text('انتخاب از گالری'));
    await tester.pumpAndSettle();

    expect(find.text('حجم تصویر باید کمتر از ۲ مگابایت باشد'), findsOneWidget);
  });
}
