import 'dart:async';
import 'dart:convert';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/avatar_file.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/pages/complete_profile_page.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:car_assistant/features/auth/presentation/providers/avatar_picker.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

/// Returns [file] (or throws [error]) instead of opening the gallery.
class FakeAvatarPicker implements AvatarPicker {
  FakeAvatarPicker({this.file, this.error});

  final AvatarFile? file;
  final Object? error;
  AvatarSource? lastSource;

  @override
  Future<AvatarFile?> pick(AvatarSource source) async {
    lastSource = source;
    if (error case final error?) throw error;
    return file;
  }
}

const _phone = '09121236789';
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);
final _incomplete = User(
  id: 'u1',
  phone: _phone,
  createdAt: DateTime.utc(2026),
  isProfileComplete: false,
);

void main() {
  late MockAuthRepository repository;
  late FakeAvatarPicker picker;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(DateTime(2000));
    registerFallbackValue(AvatarFile(bytes: _png, fileName: 'f.png'));
  });

  setUp(() {
    repository = MockAuthRepository();
    picker = FakeAvatarPicker(
      file: AvatarFile(bytes: _png, fileName: 'me.png'),
    );
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        avatarPickerProvider.overrideWithValue(picker),
      ],
    );
    container.read(authStatusProvider.notifier).signIn(_incomplete);
  });

  tearDown(() => container.dispose());

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390 * 3, 1600 * 3)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const CompleteProfilePage(),
        ),
      ),
    );
    await tester.pump();
  }

  Finder field(int index) => find.byType(TextField).at(index);

  /// Opens the Jalali picker and confirms its default (30 years ago today). Returns that date.
  Future<DateTime> pickDefaultBirthDate(WidgetTester tester) async {
    await tester.tap(find.text('انتخاب تاریخ'));
    await tester.pumpAndSettle();
    expect(find.text('انتخاب تاریخ تولد (تقویم جلالی)'), findsOneWidget);
    await tester.tap(find.text('تأیید تاریخ تولد'));
    await tester.pumpAndSettle();
    final now = DateTime.now();
    return DateTime(now.year - 30, now.month, now.day);
  }

  void stubUpdate(Future<Either<Failure, User>> Function() answer) => when(
    () => repository.updateProfile(
      firstName: any(named: 'firstName'),
      lastName: any(named: 'lastName'),
      birthDate: any(named: 'birthDate'),
    ),
  ).thenAnswer((_) => answer());

  testWidgets('shows the Stitch content with the verified phone', (tester) async {
    await pumpPage(tester);

    expect(find.text('تکمیل اطلاعات کاربری'), findsOneWidget);
    expect(find.text('تکمیل اطلاعات حساب'), findsOneWidget);
    expect(find.text('بارگذاری تصویر پرسنلی اختیاری است'), findsOneWidget);
    expect(find.text('نام'), findsOneWidget);
    expect(find.text('نام خانوادگی'), findsOneWidget);
    expect(find.text('تاریخ تولد'), findsOneWidget);
    expect(find.text('۰۹۱۲ ••• ۶۷۸۹'), findsOneWidget);
    expect(find.text('تأیید شده'), findsOneWidget);
    expect(find.text('امنیت و حریم شخصی سوابق'), findsOneWidget);
    expect(find.text('تأیید و ذخیره اطلاعات'), findsOneWidget);
    expect(find.textContaining('مرحله'), findsNothing); // no step counter in the real flow
  });

  testWidgets('shows initials from the typed names', (tester) async {
    await pumpPage(tester);

    await tester.enterText(field(0), 'علی');
    await tester.enterText(field(1), 'محمدی');
    await tester.pump();

    expect(find.text('ع.م'), findsOneWidget);
  });

  testWidgets('validates every field before calling the API', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('تأیید و ذخیره اطلاعات'));
    await tester.pump();

    expect(find.text('نام را وارد کنید (حداکثر ۵۰ حرف)'), findsOneWidget);
    expect(find.text('نام خانوادگی را وارد کنید (حداکثر ۵۰ حرف)'), findsOneWidget);
    expect(find.text('تاریخ تولد معتبر انتخاب کنید'), findsOneWidget);
    verifyNever(
      () => repository.updateProfile(
        firstName: any(named: 'firstName'),
        lastName: any(named: 'lastName'),
        birthDate: any(named: 'birthDate'),
      ),
    );

    await tester.enterText(field(0), 'علی');
    await tester.pump();
    expect(find.text('نام را وارد کنید (حداکثر ۵۰ حرف)'), findsNothing);
  });

  testWidgets('picks a Jalali date and saves trimmed names, then signs in fully', (tester) async {
    final complete = User(
      id: 'u1',
      phone: _phone,
      createdAt: DateTime.utc(2026),
      firstName: 'علی',
      lastName: 'محمدی',
      birthDate: DateTime(1991, 11, 12),
      isProfileComplete: true,
    );
    stubUpdate(() async => Right(complete));
    await pumpPage(tester);

    await tester.enterText(field(0), ' علی ');
    await tester.enterText(field(1), 'محمدی');
    final birthDate = await pickDefaultBirthDate(tester);
    expect(find.text('انتخاب تاریخ'), findsNothing); // shows the chosen Jalali date instead

    await tester.tap(find.text('تأیید و ذخیره اطلاعات'));
    await tester.pump();

    verify(
      () => repository.updateProfile(firstName: 'علی', lastName: 'محمدی', birthDate: birthDate),
    ).called(1);
    expect(container.read(authStatusProvider), AuthStatus.signedIn);
  });

  testWidgets('shows a server 400 and a generic failure inline', (tester) async {
    stubUpdate(() async => const Left(InvalidProfileFailure(message: 'bad')));
    await pumpPage(tester);
    await tester.enterText(field(0), 'علی');
    await tester.enterText(field(1), 'محمدی');
    await pickDefaultBirthDate(tester);

    await tester.tap(find.text('تأیید و ذخیره اطلاعات'));
    await tester.pump();
    expect(find.text('اطلاعات واردشده معتبر نیست، دوباره بررسی کنید'), findsOneWidget);

    stubUpdate(() async => const Left(Failure('HTTP 500')));
    await tester.tap(find.text('تأیید و ذخیره اطلاعات'));
    await tester.pump();
    expect(find.text('مشکلی پیش آمد، دوباره تلاش کنید'), findsOneWidget);
    expect(container.read(authStatusProvider), AuthStatus.profileIncomplete);
  });

  testWidgets('uploads a picked photo right away and shows progress', (tester) async {
    final upload = Completer<Either<Failure, User>>();
    when(() => repository.uploadAvatar(any())).thenAnswer((_) => upload.future);
    when(() => repository.fetchAvatar(any())).thenAnswer((_) async => Right(_png));
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.photo_camera));
    await tester.pumpAndSettle();
    await tester.tap(find.text('انتخاب از گالری'));
    await tester.pump(); // the spinner keeps animating while the upload is pending
    await tester.pump(const Duration(milliseconds: 500));

    expect(picker.lastSource, AvatarSource.gallery);
    verify(() => repository.uploadAvatar(picker.file!)).called(1);
    expect(find.bySemanticsLabel('در حال بارگذاری تصویر...'), findsOneWidget);

    const avatarUrl = '/api/auth/me/avatar?v=1';
    upload.complete(
      Right(
        User(
          id: 'u1',
          phone: _phone,
          createdAt: DateTime.utc(2026),
          avatarUrl: avatarUrl,
          isProfileComplete: false,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.bySemanticsLabel('در حال بارگذاری تصویر...'), findsNothing);
    expect(container.read(currentUserProvider)?.avatarUrl, avatarUrl);
    expect(container.read(authStatusProvider), AuthStatus.profileIncomplete);
  });

  testWidgets('shows an upload error inline', (tester) async {
    when(() => repository.uploadAvatar(any()))
        .thenAnswer((_) async => const Left(AvatarTooLargeFailure()));
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.photo_camera));
    await tester.pumpAndSettle();
    await tester.tap(find.text('گرفتن عکس'));
    await tester.pumpAndSettle();

    expect(picker.lastSource, AvatarSource.camera);
    expect(find.text('حجم تصویر باید کمتر از ۲ مگابایت باشد'), findsOneWidget);
    expect(find.byType(Image), findsNothing); // the preview is dropped
  });

  testWidgets('shows an error when the gallery cannot be opened', (tester) async {
    picker = FakeAvatarPicker(error: Exception('denied'));
    container.dispose();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        avatarPickerProvider.overrideWithValue(picker),
      ],
    );
    container.read(authStatusProvider.notifier).signIn(_incomplete);
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.photo_camera));
    await tester.pumpAndSettle();
    await tester.tap(find.text('انتخاب از گالری'));
    await tester.pumpAndSettle();

    expect(find.text('دسترسی به تصویر ممکن نشد'), findsOneWidget);
    verifyNever(() => repository.uploadAvatar(any()));
  });
}
