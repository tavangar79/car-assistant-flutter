import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';
import 'package:car_assistant/features/reports/domain/entities/report_options.dart';
import 'package:car_assistant/features/reports/presentation/export/report_file_name.dart';
import 'package:car_assistant/features/reports/presentation/providers/report_exporter.dart';
import 'package:car_assistant/features/reports/presentation/providers/report_options_notifier.dart';
import 'package:car_assistant/features/reports/presentation/providers/report_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../services/service_fixtures.dart';
import '../../vehicles/vehicle_fixtures.dart';
import '../report_fixtures.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('fa'));
  final now = DateTime(2024, 11, 15, 18, 30); // ۲۵ آبان ۱۴۰۳
  late MockReportRepository repository;
  late FakeReportFileSaver saver;
  late ReportExporter exporter;

  setUp(() {
    repository = MockReportRepository();
    saver = FakeReportFileSaver();
    exporter = ReportExporter(
      repository: repository,
      saver: saver,
      loadFonts: testFonts,
      now: () => now,
    );
  });

  Future<void> export(ReportFormat format, ReportOptions options) => exporter.export(
    format,
    report: fixtureReport(),
    options: options,
    vehicles: const [tara],
    catalog: serviceCatalog,
    l10n: l10n,
  );

  test('a CSV is saved as car-report-<Jalali day>.csv with a BOM', () async {
    await export(ReportFormat.csv, const ReportOptions());

    final (name, mime, bytes) = saver.saved.single;
    expect(name, 'car-report-1403-08-25.csv');
    expect(mime, 'text/csv');
    expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
    verifyZeroInteractions(repository);
  });

  test('a PDF without images downloads no attachment', () async {
    await export(ReportFormat.pdf, const ReportOptions());

    final (name, mime, _) = saver.saved.single;
    expect(name, 'car-report-1403-08-25.pdf');
    expect(mime, 'application/pdf');
    verifyZeroInteractions(repository);
  });

  test('a PDF with images downloads only the image attachments', () async {
    when(() => repository.getFile(any())).thenAnswer((_) async => Right(onePixelPng));

    await export(ReportFormat.pdf, const ReportOptions(includeImages: true));

    // The service invoice is a JPEG; the expense attachment is a PDF and is listed by name.
    verify(() => repository.getFile('/api/vehicles/v1/services/s1/invoice?v=1')).called(1);
    verifyNoMoreInteractions(repository);
    expect(saver.saved, hasLength(1));
  });

  test('a failed image download still saves the PDF', () async {
    when(() => repository.getFile(any())).thenAnswer((_) async => const Left(Failure('gone')));

    await export(ReportFormat.pdf, const ReportOptions(includeImages: true));

    expect(saver.saved, hasLength(1));
  });

  group('ReportOptionsNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    ReportOptionsNotifier notifier() => container.read(reportOptionsProvider('v1').notifier);
    ReportOptions options() => container.read(reportOptionsProvider('v1'));

    test('starts on the vehicle, this year, every type and no images', () {
      container.listen(reportOptionsProvider('v1'), (_, _) {});
      expect(options(), const ReportOptions(vehicleId: 'v1'));
    });

    test('switches between the vehicle and every vehicle', () {
      container.listen(reportOptionsProvider('v1'), (_, _) {});
      notifier().setAllVehicles(true);
      expect(options().vehicleId, isNull);
      notifier().setAllVehicles(false);
      expect(options().vehicleId, 'v1');
    });

    test('toggles a type', () {
      container.listen(reportOptionsProvider('v1'), (_, _) {});
      notifier().toggleType(HistoryType.fuel);
      expect(options().types, {HistoryType.service, HistoryType.expense});
      notifier().toggleType(HistoryType.fuel);
      expect(options().types, ReportOptions.allTypes);
    });

    test('"انتخاب همه" checks every box, then clears them all', () {
      container.listen(reportOptionsProvider('v1'), (_, _) {});
      notifier().toggleAll();
      expect(options().types, ReportOptions.allTypes);
      expect(options().includeImages, isTrue);

      notifier().toggleAll();
      expect(options().types, isEmpty);
      expect(options().includeImages, isFalse);
      expect(options().canExport, isFalse);
    });
  });
}
