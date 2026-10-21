import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/documents/domain/entities/document_file.dart';
import 'package:car_assistant/features/documents/domain/repositories/document_repository.dart';
import 'package:car_assistant/features/documents/presentation/pages/documents_page.dart';
import 'package:car_assistant/features/documents/presentation/providers/document_file_picker.dart';
import 'package:car_assistant/features/documents/presentation/providers/document_file_saver.dart';
import 'package:car_assistant/features/documents/presentation/providers/document_form_args.dart';
import 'package:car_assistant/features/documents/presentation/providers/document_providers.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/services/presentation/widgets/details/invoice_viewer_page.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicles/vehicle_fixtures.dart';
import '../document_fixtures.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockDocumentFilePicker extends Mock implements DocumentFilePicker {}

class MockDocumentFileSaver extends Mock implements DocumentFileSaver {}

/// A transparent 1x1 PNG, so the image viewer can decode it.
final transparentPng = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, //
  0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F,
  0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00,
  0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

void main() {
  late MockDocumentRepository documents;
  late MockVehicleRepository vehicles;
  late MockDocumentFilePicker picker;
  late MockDocumentFileSaver saver;
  final now = DateTime(2026, 10, 21, 18, 45);

  /// Expiring in 11 days (amber), then the permanent card.
  final dueSoon = insurance(expiresAt: DateTime(2026, 11, 1));

  setUpAll(() {
    registerFallbackValue(DocumentFileSource.pdf);
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(policyFile);
  });

  setUp(() {
    documents = MockDocumentRepository();
    vehicles = MockVehicleRepository();
    picker = MockDocumentFilePicker();
    saver = MockDocumentFileSaver();
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => documents.getDocuments('v1'))
        .thenAnswer((_) async => Right([dueSoon, vehicleCard()]));
    when(() => saver.save(any(), any())).thenAnswer((_) async {});
  });

  /// The documents page at `/`, with stub add and edit routes.
  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DocumentsPage(vehicleId: 'v1'),
        ),
        GoRoute(
          path: '/vehicles/:id/documents/new',
          builder: (context, state) {
            final args = state.extra! as DocumentFormArgs;
            return Text('new ${args.type?.wire} ${args.issuer} ${args.file?.fileName}');
          },
        ),
        GoRoute(
          path: '/vehicles/:id/documents/:documentId',
          builder: (context, state) => Text('edit ${state.pathParameters['documentId']}'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          documentRepositoryProvider.overrideWithValue(documents),
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          documentFilePickerProvider.overrideWithValue(picker),
          documentFileSaverProvider.overrideWithValue(saver),
          clockProvider.overrideWithValue(() => now),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  testWidgets('shows the vehicle, the encryption note, the upload card and the chips', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('کیف مدارک خودرو'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsNWidgets(2)); // app bar and card
    expect(find.text('کیف مدارک و یادآورهای هوشمند تمدید'), findsOneWidget);
    expect(find.text('۲ مدرک ثبت‌شده به‌صورت رمزگذاری‌شده نگهداری می‌شوند.'), findsOneWidget);
    for (final label in ['بارگذاری مدرک جدید', 'دوربین', 'گالری', 'فایل PDF']) {
      expect(find.text(label), findsOneWidget);
    }
    for (final chip in ['همه (۲)', 'بیمه‌ها (۱)', 'معاینه فنی (۰)', 'مدارک هویتی (۱)']) {
      expect(find.text(chip), findsOneWidget);
    }
    // The made-up export bar of the Stitch sample is not built.
    expect(find.textContaining('خروجی پرونده'), findsNothing);
  });

  testWidgets('cards show the badge, status, issuer line, Jalali dates and reminder', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('بیمه شخص ثالث'), findsOneWidget);
    expect(find.text('موعد نزدیک — ۱۱ روز مانده'), findsOneWidget);
    expect(find.text('بیمه ایران — شماره: 124/987432'), findsOneWidget);
    expect(find.text('صدور: ۱۴۰۲/۰۹/۱۰'), findsOneWidget);
    expect(find.text('انقضا: ۱۴۰۵/۰۸/۱۰'), findsOneWidget);
    expect(find.text('یادآور تمدید فعال است'), findsOneWidget);
    expect(find.text('مشاهده اصل فایل'), findsNWidgets(2));

    expect(find.text('۲ تصویر'), findsOneWidget);
    expect(find.text('کارت هوشمند خودرو'), findsOneWidget);
    expect(find.text('دائمی / بدون انقضا'), findsOneWidget);
  });

  testWidgets('an expired card offers a renewal prefilled with its type and issuer', (
    tester,
  ) async {
    when(() => documents.getDocuments('v1'))
        .thenAnswer((_) async => Right([insurance(expiresAt: DateTime(2026, 7, 28))]));
    await pumpPage(tester);

    expect(find.text('منقضی شده — ۸۵ روز گذشته'), findsOneWidget);
    expect(find.text('یادآور تمدید فعال است'), findsNothing);
    expect(find.text('مشاهده اصل فایل'), findsNothing);

    await tapText(tester, 'ثبت تمدید جدید');

    expect(find.text('new third_party_insurance بیمه ایران null'), findsOneWidget);
  });

  testWidgets('chips filter by group', (tester) async {
    await pumpPage(tester);

    await tapText(tester, 'مدارک هویتی (۱)');
    expect(find.text('کارت هوشمند خودرو'), findsOneWidget);
    expect(find.text('بیمه شخص ثالث'), findsNothing);

    await tapText(tester, 'معاینه فنی (۰)');
    expect(find.text('مدرکی در این دسته وجود ندارد'), findsOneWidget);
  });

  testWidgets('a picked upload opens the add form with the file', (tester) async {
    when(() => picker.pick(DocumentFileSource.pdf)).thenAnswer((_) async => pdfUpload);
    await pumpPage(tester);

    await tapText(tester, 'فایل PDF');

    expect(find.text('new null null policy.pdf'), findsOneWidget);
  });

  testWidgets('a failed pick shows a message and stays', (tester) async {
    when(() => picker.pick(any())).thenThrow(Exception('no camera'));
    await pumpPage(tester);

    await tapText(tester, 'دوربین');

    expect(find.text('انتخاب فایل ممکن نشد'), findsOneWidget);
    expect(find.text('کیف مدارک خودرو'), findsOneWidget);
  });

  testWidgets('tapping a card opens it for editing', (tester) async {
    await pumpPage(tester);

    await tapText(tester, 'کارت هوشمند خودرو');

    expect(find.text('edit d2'), findsOneWidget);
  });

  testWidgets('"مشاهده اصل فایل" fetches the PDF with auth and hands it to the platform', (
    tester,
  ) async {
    when(() => documents.fetchFile(fileUrl)).thenAnswer((_) async => Right(Uint8List(3)));
    await pumpPage(tester);

    await tapText(tester, 'مشاهده اصل فایل');

    verify(() => saver.save(any(), policyFile)).called(1);
  });

  testWidgets('an image file opens in the viewer', (tester) async {
    final DocumentFile front = vehicleCard().files.first;
    when(() => documents.fetchFile(front.url)).thenAnswer((_) async => Right(transparentPng));
    when(() => documents.getDocuments('v1')).thenAnswer((_) async => Right([vehicleCard()]));
    await pumpPage(tester);

    await tapText(tester, 'مشاهده اصل فایل');

    expect(find.byType(InvoiceViewerPage), findsOneWidget);
  });

  testWidgets('a failed file load shows a message', (tester) async {
    when(() => documents.fetchFile(any())).thenAnswer((_) async => const Left(Failure('x')));
    await pumpPage(tester);

    await tapText(tester, 'مشاهده اصل فایل');

    expect(find.text('باز کردن فایل ممکن نشد'), findsOneWidget);
  });

  testWidgets('an empty wallet says so', (tester) async {
    when(() => documents.getDocuments('v1')).thenAnswer((_) async => const Right([]));
    await pumpPage(tester);

    expect(find.text('هنوز مدرکی برای این خودرو ثبت نشده است'), findsOneWidget);
    expect(find.text('همه (۰)'), findsOneWidget);
  });

  testWidgets('a load error offers a retry', (tester) async {
    when(() => documents.getDocuments('v1')).thenAnswer((_) async => const Left(Failure('x')));
    await pumpPage(tester);

    expect(find.text('دریافت مدارک ممکن نشد'), findsOneWidget);

    when(() => documents.getDocuments('v1')).thenAnswer((_) async => Right([dueSoon]));
    await tester.tap(find.text('تلاش دوباره'));
    await tester.pumpAndSettle();

    expect(find.text('بیمه شخص ثالث'), findsOneWidget);
  });
}
