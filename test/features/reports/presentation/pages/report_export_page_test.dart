import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/history/domain/entities/history_summary.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/reports/domain/entities/report.dart';
import 'package:car_assistant/features/reports/domain/entities/report_failures.dart';
import 'package:car_assistant/features/reports/domain/entities/report_query.dart';
import 'package:car_assistant/features/reports/presentation/pages/report_export_page.dart';
import 'package:car_assistant/features/reports/presentation/providers/report_providers.dart';
import 'package:car_assistant/features/services/domain/repositories/service_repository.dart';
import 'package:car_assistant/features/services/presentation/providers/service_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../history/history_fixtures.dart';
import '../../../services/service_fixtures.dart';
import '../../../vehicles/vehicle_fixtures.dart';
import '../../report_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

void main() {
  final now = DateTime(2024, 11, 15, 18, 30); // ۲۵ آبان ۱۴۰۳
  final peugeot = taraWith(id: 'v2', nickname: 'پژو ۲۰۶', isDefault: false);
  final report = Report(
    entries: [expenseEntry(), fuelEntry(), serviceEntry()],
    summary: const HistorySummary(
      totalCost: 18450000,
      serviceCount: 8,
      fuelVolume: 240.5,
      entryCount: 24,
    ),
  );
  late MockReportRepository reports;
  late MockVehicleRepository vehicles;
  late MockServiceRepository services;
  late FakeReportFileSaver saver;

  setUpAll(() => registerFallbackValue(const ReportQuery()));

  setUp(() {
    reports = MockReportRepository();
    vehicles = MockVehicleRepository();
    services = MockServiceRepository();
    saver = FakeReportFileSaver();
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([tara, peugeot]));
    when(() => services.getCatalog(vehicleId: any(named: 'vehicleId')))
        .thenAnswer((_) async => const Right(serviceCatalog));
    when(() => reports.getReport(any())).thenAnswer((_) async => Right(report));
  });

  Future<void> openPage(WidgetTester tester, {String? vehicleId}) async {
    tester.view
      ..physicalSize = const Size(420, 2000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reportRepositoryProvider.overrideWithValue(reports),
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          serviceRepositoryProvider.overrideWithValue(services),
          reportFileSaverProvider.overrideWithValue(saver),
          reportFontsLoaderProvider.overrideWithValue(testFonts),
          clockProvider.overrideWithValue(() => now),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ReportExportPage(vehicleId: vehicleId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  ReportQuery lastQuery() =>
      verify(() => reports.getReport(captureAny())).captured.last as ReportQuery;

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  FilledButton button(WidgetTester tester, String label) => tester.widget<FilledButton>(
    find.ancestor(of: find.text(label), matching: find.byType(FilledButton)),
  );

  testWidgets('opens on the passed vehicle, this year, every type, and shows the preview', (
    tester,
  ) async {
    await openPage(tester, vehicleId: 'v2');

    expect(find.text('خروجی گزارش'), findsOneWidget);
    expect(find.text('پژو ۲۰۶'), findsWidgets);
    expect(find.text('همه خودروها (۲)'), findsOneWidget);
    expect(find.text('سال جاری (۱۴۰۳)'), findsOneWidget);
    expect(find.text('۰۱ فروردین ۱۴۰۳'), findsOneWidget);
    expect(find.text('۲۵ آبان ۱۴۰۳'), findsOneWidget);
    expect(find.textContaining('۲۴', findRichText: true), findsOneWidget);
    expect(find.textContaining('۱۸٬۴۵۰٬۰۰۰', findRichText: true), findsOneWidget);
    expect(
      lastQuery(),
      ReportQuery(vehicleIds: const ['v2'], from: DateTime(2024, 3, 20), to: now),
    );
    expect(button(tester, 'دریافت خروجی PDF رسمی').onPressed, isNotNull);
    expect(button(tester, 'دریافت فایل اکسل (Excel / CSV)').onPressed, isNotNull);
  });

  testWidgets('without a vehicle it opens on the default one', (tester) async {
    await openPage(tester);

    expect(lastQuery().vehicleIds, ['v1']);
  });

  testWidgets('every vehicle and every record send no vehicle and no dates', (tester) async {
    await openPage(tester);

    await tapText(tester, 'همه خودروها (۲)');
    await tapText(tester, 'کل سوابق');

    expect(lastQuery(), const ReportQuery());
    // The start of every record is the oldest record of the preview.
    expect(find.text('۲۷ آبان ۱۴۰۳'), findsOneWidget);
  });

  testWidgets('a type box changes the query; no type disables the downloads', (tester) async {
    await openPage(tester);

    await tapText(tester, 'سوابق سوخت‌گیری');
    expect(lastQuery().types, [HistoryType.service, HistoryType.expense]);

    await tapText(tester, 'انتخاب همه');
    await tapText(tester, 'انتخاب همه');

    expect(find.text('حداقل یک مورد را برای گزارش انتخاب کنید'), findsOneWidget);
    expect(button(tester, 'دریافت خروجی PDF رسمی').onPressed, isNull);
    expect(button(tester, 'دریافت فایل اکسل (Excel / CSV)').onPressed, isNull);
  });

  testWidgets('the CSV download saves the file and shows the toast', (tester) async {
    await openPage(tester);

    await tapText(tester, 'دریافت فایل اکسل (Excel / CSV)');

    expect(saver.saved.single.$1, 'car-report-1403-08-25.csv');
    expect(find.text('فایل اکسل محاسباتی آماده بارگیری گردید.'), findsOneWidget);
  });

  testWidgets('a too-large report says so and disables the downloads', (tester) async {
    when(() => reports.getReport(any()))
        .thenAnswer((_) async => const Left(ReportTooLargeFailure()));

    await openPage(tester);

    expect(find.text('بازه گزارش بیش از حد بزرگ است'), findsOneWidget);
    expect(button(tester, 'دریافت خروجی PDF رسمی').onPressed, isNull);
  });

  testWidgets('a failed preview can be retried', (tester) async {
    when(() => reports.getReport(any())).thenAnswer((_) async => const Left(Failure('boom')));
    await openPage(tester);
    expect(find.text('محاسبه پیش‌نمایش ممکن نشد'), findsOneWidget);

    when(() => reports.getReport(any())).thenAnswer((_) async => Right(report));
    await tapText(tester, 'تلاش دوباره');

    expect(find.textContaining('۱۸٬۴۵۰٬۰۰۰', findRichText: true), findsOneWidget);
  });
}
