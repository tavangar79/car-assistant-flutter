import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:car_assistant/features/history/domain/entities/history_summary.dart';
import 'package:car_assistant/features/reports/domain/entities/report.dart';
import 'package:car_assistant/features/reports/presentation/export/report_csv_builder.dart';
import 'package:car_assistant/features/reports/presentation/export/report_file_name.dart';
import 'package:car_assistant/features/reports/presentation/export/report_pdf_builder.dart';
import 'package:car_assistant/features/reports/presentation/export/report_rows.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../history/history_fixtures.dart';
import '../../report_fixtures.dart';
import '../../../services/service_fixtures.dart';
import '../../../vehicles/vehicle_fixtures.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('fa'));

  group('reportRows', () {
    test('builds the description of each record type with ASCII digits', () {
      final rows = reportRows(
        fixtureReport().entries,
        vehicles: const [tara],
        catalog: serviceCatalog,
        l10n: l10n,
      );

      expect(rows.map((row) => row.description), [
        'بیمه شخص ثالث - تمدید بیمه‌نامه شخص ثالث ۱۲ ماهه ایران',
        'سوپر - 48.5 لیتر - جایگاه اختصاصی ۲۴ یادگار امام (تهران)',
        'روغن موتور، فیلتر روغن - اتوسرویس البرز',
      ]);
      expect(rows.map((row) => row.km), [null, 34850, 34850]);
      expect(rows.map((row) => row.amount), [5850000, 145500, 2130000]);
      expect(rows.every((row) => row.vehicle == tara), isTrue);
    });

    test('an item missing from the catalog shows its id', () {
      final rows = reportRows([serviceEntry()], vehicles: const [], catalog: const [], l10n: l10n);

      expect(rows.single.description, 'engine_oil، oil_filter - اتوسرویس البرز');
      expect(rows.single.vehicle, isNull);
    });
  });

  group('buildReportCsv', () {
    String csvText(Report report) {
      final bytes = buildReportCsv(
        report,
        vehicles: const [tara],
        catalog: serviceCatalog,
        l10n: l10n,
      );
      expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF], reason: 'UTF-8 BOM');
      return utf8.decode(bytes.sublist(3));
    }

    test('writes the header, one row per record with ASCII digits, and the total', () {
      final lines = csvText(fixtureReport()).split('\r\n');

      expect(lines, [
        'تاریخ,خودرو,پلاک,نوع,شرح,کیلومتر,مبلغ (تومان)',
        '1403/08/27,تارا اتوماتیک نقره‌ای,72 ب 345 ایران 68,هزینه,'
            'بیمه شخص ثالث - تمدید بیمه‌نامه شخص ثالث ۱۲ ماهه ایران,,5850000',
        '1404/08/24,تارا اتوماتیک نقره‌ای,72 ب 345 ایران 68,سوخت,'
            'سوپر - 48.5 لیتر - جایگاه اختصاصی ۲۴ یادگار امام (تهران),34850,145500',
        '1405/07/28,تارا اتوماتیک نقره‌ای,72 ب 345 ایران 68,سرویس,'
            'روغن موتور، فیلتر روغن - اتوسرویس البرز,34850,2130000',
        'جمع کل,,,,,,8125500',
        '',
      ]);
    });

    test('quotes a cell with a comma or a quote (RFC 4180)', () {
      final report = Report(entries: [quotedExpenseEntry()], summary: fixtureReport().summary);

      expect(csvText(report), contains(',"عوارض و طرح - عوارض ""آزادراه"", تهران",,300000'));
    });

    test('an empty report has the header and the total only', () {
      final report = Report(
        entries: const [],
        summary: const HistorySummary(totalCost: 0, serviceCount: 0, fuelVolume: 0, entryCount: 0),
      );

      expect(csvText(report).split('\r\n'), hasLength(3));
    });
  });

  group('buildReportPdf', () {
    late ReportPdfFonts fonts;

    setUpAll(() {
      pw.Font font(String path) => pw.Font.ttf(File(path).readAsBytesSync().buffer.asByteData());
      fonts = ReportPdfFonts(
        regular: font('assets/fonts/Vazirmatn-Regular.ttf'),
        bold: font('assets/fonts/Vazirmatn-Bold.ttf'),
      );
    });

    Future<Uint8List> build({List<ReportAttachment> attachments = const []}) => buildReportPdf(
      fixtureReport(),
      vehicles: const [tara],
      catalog: serviceCatalog,
      l10n: l10n,
      fonts: fonts,
      from: null,
      to: null,
      generatedAt: DateTime(2024, 11, 15, 18, 30),
      attachments: attachments,
    );

    int pageCount(Uint8List pdf) =>
        RegExp(r'/Type\s*/Page\b').allMatches(latin1.decode(pdf)).length;

    test('makes a PDF document', () async {
      final pdf = await build();

      expect(latin1.decode(pdf.sublist(0, 5)), '%PDF-');
      expect(pageCount(pdf), 1);
    });

    test('adds a page per image and one page listing the other files', () async {
      final pdf = await build(
        attachments: [
          ReportAttachment(fileName: 'فاکتور.png', date: DateTime(2024, 1, 1), image: onePixelPng),
          ReportAttachment(fileName: 'بیمه‌نامه.pdf', date: DateTime(2024, 1, 2)),
          // Bytes that are not an image are listed by name too.
          ReportAttachment(
            fileName: 'broken.jpg',
            date: DateTime(2024, 1, 3),
            image: Uint8List.fromList([1, 2, 3]),
          ),
        ],
      );

      expect(pageCount(pdf), 3);
    });
  });

  test('reportFileName uses the Jalali day with ASCII digits', () {
    final now = DateTime(2024, 11, 15, 18, 30); // ۲۵ آبان ۱۴۰۳

    expect(reportFileName(now, ReportFormat.pdf), 'car-report-1403-08-25.pdf');
    expect(reportFileName(now, ReportFormat.csv), 'car-report-1403-08-25.csv');
  });
}
