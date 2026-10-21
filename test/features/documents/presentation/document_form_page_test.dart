import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/documents/domain/entities/document_failures.dart';
import 'package:car_assistant/features/documents/domain/entities/document_input.dart';
import 'package:car_assistant/features/documents/domain/entities/document_type.dart';
import 'package:car_assistant/features/documents/domain/repositories/document_repository.dart';
import 'package:car_assistant/features/documents/presentation/pages/document_form_page.dart';
import 'package:car_assistant/features/documents/presentation/providers/document_form_args.dart';
import 'package:car_assistant/features/documents/presentation/providers/document_providers.dart';
import 'package:car_assistant/features/expenses/presentation/providers/attachment_picker.dart';
import 'package:car_assistant/features/expenses/presentation/providers/expense_providers.dart';
import 'package:car_assistant/features/notifications/domain/repositories/notification_repository.dart';
import 'package:car_assistant/features/notifications/presentation/providers/notification_providers.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/profile/domain/entities/profile_stats.dart';
import 'package:car_assistant/features/profile/domain/repositories/profile_repository.dart';
import 'package:car_assistant/features/profile/presentation/providers/profile_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../document_fixtures.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockAttachmentPicker extends Mock implements AttachmentPicker {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late MockDocumentRepository documents;
  late MockAttachmentPicker picker;
  late MockProfileRepository profile;
  late MockNotificationRepository notifications;
  final now = DateTime(2026, 10, 21, 18, 45);

  setUpAll(() {
    registerFallbackValue(const DocumentInput(type: DocumentType.inspection));
    registerFallbackValue(pdfUpload);
  });

  setUp(() {
    documents = MockDocumentRepository();
    picker = MockAttachmentPicker();
    profile = MockProfileRepository();
    notifications = MockNotificationRepository();
    when(() => documents.getDocuments('v1')).thenAnswer((_) async => Right([insurance()]));
    when(() => documents.createDocument('v1', any()))
        .thenAnswer((_) async => Right(insurance(withFile: false)));
    when(() => documents.updateDocument('v1', 'd1', any()))
        .thenAnswer((_) async => Right(insurance()));
    when(() => documents.uploadFile('v1', 'd1', any())).thenAnswer((_) async => Right(insurance()));
    when(() => profile.getStats()).thenAnswer(
      (_) async => const Right(ProfileStats(vehicleCount: 1, serviceCount: 0, documentCount: 1)),
    );
    when(() => notifications.getUnreadCount()).thenAnswer((_) async => const Right(0));
    when(() => picker.pick()).thenAnswer((_) async => pdfUpload);
  });

  /// Opens the form pushed above a home screen, so a save pops back to it.
  Future<void> openForm(WidgetTester tester, Widget form) async {
    tester.view.physicalSize = const Size(420, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          documentRepositoryProvider.overrideWithValue(documents),
          attachmentPickerProvider.overrideWithValue(picker),
          profileRepositoryProvider.overrideWithValue(profile),
          notificationRepositoryProvider.overrideWithValue(notifications),
          clockProvider.overrideWithValue(() => now),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => form)),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
  }

  DocumentInput sentInput() =>
      verify(() => documents.createDocument('v1', captureAny())).captured.single as DocumentInput;

  testWidgets('add: shows every section of the form', (tester) async {
    await openForm(tester, const DocumentFormPage(vehicleId: 'v1'));

    expect(find.text('ثبت مدرک'), findsNWidgets(2)); // app bar and submit
    for (final label in [
      'نوع مدرک',
      'بیمه شخص ثالث',
      'بیمه بدنه',
      'معاینه فنی',
      'کارت خودرو',
      'برگ سبز (سند مالکیت)',
      'وکالت‌نامه',
      'عنوان مدرک',
      'صادرکننده',
      'شماره مدرک / بیمه‌نامه',
      'تاریخ صدور',
      'انتخاب تاریخ صدور',
      'تعیین موعد انقضا یا تمدید بعدی',
      'یادداشت',
      'فایل‌های مدرک',
      '۰ از ۴',
      'افزودن فایل',
    ]) {
      expect(find.text(label), findsWidgets, reason: label);
    }
    expect(find.byTooltip('حذف مدرک'), findsNothing);
  });

  testWidgets('add: without a type nothing is sent and the grid says so', (tester) async {
    await openForm(tester, const DocumentFormPage(vehicleId: 'v1'));

    await submit(tester);

    expect(find.text('نوع مدرک را انتخاب کنید'), findsOneWidget);
    verifyNever(() => documents.createDocument(any(), any()));
  });

  testWidgets('add: saves the fields, uploads the picked file and closes', (tester) async {
    await openForm(
      tester,
      DocumentFormPage(
        vehicleId: 'v1',
        args: DocumentFormArgs(file: pdfUpload),
      ),
    );
    expect(find.text('policy.pdf'), findsOneWidget);
    expect(find.text('۱ از ۴'), findsOneWidget);

    await tapText(tester, 'بیمه شخص ثالث');
    await tester.enterText(find.byType(TextField).at(1), 'بیمه ایران');
    await submit(tester);

    expect(
      sentInput(),
      const DocumentInput(type: DocumentType.thirdPartyInsurance, issuer: 'بیمه ایران'),
    );
    verify(() => documents.uploadFile('v1', 'd1', pdfUpload)).called(1);
    expect(find.text('مدرک ذخیره شد'), findsOneWidget);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('add: a renewal starts with the type and issuer', (tester) async {
    await openForm(
      tester,
      const DocumentFormPage(
        vehicleId: 'v1',
        args: DocumentFormArgs(type: DocumentType.bodyInsurance, issuer: 'بیمه آسیا'),
      ),
    );

    expect(find.text('بیمه آسیا'), findsOneWidget);
    await submit(tester);

    expect(sentInput(), const DocumentInput(type: DocumentType.bodyInsurance, issuer: 'بیمه آسیا'));
  });

  testWidgets('add: files picked with the expense picker, up to four', (tester) async {
    await openForm(tester, const DocumentFormPage(vehicleId: 'v1'));

    for (var i = 0; i < 4; i++) {
      await tapText(tester, 'افزودن فایل');
    }

    expect(find.text('۴ از ۴'), findsOneWidget);
    expect(find.text('افزودن فایل'), findsNothing);
  });

  testWidgets('add: a saved document whose file fails says so and still closes', (tester) async {
    when(() => documents.uploadFile('v1', 'd1', any()))
        .thenAnswer((_) async => const Left(DocumentFileLimitFailure()));
    await openForm(
      tester,
      DocumentFormPage(
        vehicleId: 'v1',
        args: DocumentFormArgs(type: DocumentType.inspection, file: pdfUpload),
      ),
    );

    await submit(tester);

    expect(find.text('مدرک ذخیره شد، اما بارگذاری فایل انجام نشد'), findsOneWidget);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('add: a server failure keeps the form', (tester) async {
    when(() => documents.createDocument('v1', any()))
        .thenAnswer((_) async => const Left(Failure('x')));
    await openForm(
      tester,
      const DocumentFormPage(
        vehicleId: 'v1',
        args: DocumentFormArgs(type: DocumentType.inspection),
      ),
    );

    await submit(tester);

    expect(find.text('ذخیره مدرک ممکن نشد'), findsOneWidget);
    expect(find.text('open'), findsNothing);
  });

  testWidgets('edit: starts filled, saves with PATCH and closes', (tester) async {
    await openForm(tester, const DocumentFormPage(vehicleId: 'v1', documentId: 'd1'));

    expect(find.text('ویرایش مدرک'), findsOneWidget);
    expect(find.text('بیمه ایران'), findsOneWidget);
    expect(find.text('124/987432'), findsOneWidget);
    expect(find.text('۱۰ آذر ۱۴۰۲'), findsOneWidget);
    expect(find.text('policy.pdf'), findsOneWidget);

    await submit(tester);

    final input =
        verify(() => documents.updateDocument('v1', 'd1', captureAny())).captured.single
            as DocumentInput;
    expect(input.type, DocumentType.thirdPartyInsurance);
    expect(input.expiresAt, DateTime.utc(2024, 11, 30));
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('edit: removing a saved file deletes it at once', (tester) async {
    when(() => documents.deleteFile('v1', 'd1', 'f1'))
        .thenAnswer((_) async => Right(insurance(withFile: false)));
    await openForm(tester, const DocumentFormPage(vehicleId: 'v1', documentId: 'd1'));

    await tester.tap(find.byTooltip('حذف فایل'));
    await tester.pumpAndSettle();

    verify(() => documents.deleteFile('v1', 'd1', 'f1')).called(1);
    expect(find.text('policy.pdf'), findsNothing);
    expect(find.text('۰ از ۴'), findsOneWidget);
  });

  testWidgets('edit: delete asks first, then deletes and closes', (tester) async {
    when(() => documents.deleteDocument('v1', 'd1')).thenAnswer((_) async => const Right(unit));
    await openForm(tester, const DocumentFormPage(vehicleId: 'v1', documentId: 'd1'));

    await tester.tap(find.byTooltip('حذف مدرک'));
    await tester.pumpAndSettle();
    expect(find.text('این مدرک حذف شود؟'), findsOneWidget);

    await tester.tap(find.text('انصراف'));
    await tester.pumpAndSettle();
    verifyNever(() => documents.deleteDocument(any(), any()));

    await tester.tap(find.byTooltip('حذف مدرک'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('حذف'));
    await tester.pumpAndSettle();

    verify(() => documents.deleteDocument('v1', 'd1')).called(1);
    expect(find.text('مدرک حذف شد'), findsOneWidget);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('edit: an unknown document offers a retry', (tester) async {
    await openForm(tester, const DocumentFormPage(vehicleId: 'v1', documentId: 'nope'));

    expect(find.text('دریافت مدارک ممکن نشد'), findsOneWidget);
  });
}
