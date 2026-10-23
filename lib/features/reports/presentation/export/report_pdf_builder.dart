import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../expenses/presentation/widgets/expense_formats.dart';
import '../../../services/domain/entities/service_category.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/entities/report.dart';
import 'report_pdf_text.dart';
import 'report_rows.dart';

/// An invoice or expense attachment of the report. [image] holds the bytes of a JPEG/PNG; other
/// files (or images that could not be loaded) are listed by [fileName] only.
class ReportAttachment {
  const ReportAttachment({required this.fileName, required this.date, this.image});

  final String fileName;

  /// The local date of the record the file belongs to.
  final DateTime date;
  final Uint8List? image;
}

/// The fonts of the PDF: the app's Vazirmatn, so Persian is shaped right to left.
class ReportPdfFonts {
  const ReportPdfFonts({required this.regular, required this.bold});

  final pw.Font regular;
  final pw.Font bold;
}

/// The report as an RTL A4 (landscape) PDF with locale digits: a header (app name, the range
/// [from]–[to] in Jalali, the vehicles and [generatedAt]), the summary, one table per vehicle with
/// the CSV columns and a total row, then the [attachments] (images on their own pages, other files
/// by name). A `null` [from] is "every record".
Future<Uint8List> buildReportPdf(
  Report report, {
  required List<Vehicle> vehicles,
  required List<ServiceCategory> catalog,
  required AppLocalizations l10n,
  required ReportPdfFonts fonts,
  required DateTime? from,
  required DateTime? to,
  required DateTime generatedAt,
  List<ReportAttachment> attachments = const [],
}) {
  final locale = l10n.localeName;
  String digits(String text) => localizeDigits(text, locale);
  String date(DateTime value) => formatJalaliNumeric(value.toLocal(), locale);
  String amount(int value) => NumberFormat.decimalPattern(locale).format(value);

  final rows = reportRows(report.entries, vehicles: vehicles, catalog: catalog, l10n: l10n);
  final vehicleIds = [
    ...{for (final row in rows) row.vehicleId},
  ];
  final shownVehicles = [
    for (final vehicle in vehicles)
      if (vehicleIds.isEmpty || vehicleIds.contains(vehicle.id)) vehicle,
  ];

  final document = pw.Document(
    theme: pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold),
  );
  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      textDirection: pw.TextDirection.rtl,
      margin: const pw.EdgeInsets.all(28),
      build: (context) => [
        _header(
          l10n,
          range: l10n.reportPdfRange(
            from == null ? l10n.reportPeriodAll : date(from),
            date(to ?? generatedAt),
          ),
          vehicles: shownVehicles.map((vehicle) => vehicle.nickname).join('، '),
          generatedAt: date(generatedAt),
        ),
        pw.SizedBox(height: 12),
        _summary(l10n, report, amount: amount, digits: digits),
        for (final vehicleId in vehicleIds) ...[
          pw.SizedBox(height: 16),
          _vehicleTable(
            l10n,
            rows.where((row) => row.vehicleId == vehicleId).toList(),
            date: date,
            amount: amount,
            digits: digits,
          ),
        ],
      ],
    ),
  );
  if (attachments.isNotEmpty) {
    _addAttachments(document, l10n, attachments, date: date);
  }
  return document.save();
}

pw.Widget _header(
  AppLocalizations l10n, {
  required String range,
  required String vehicles,
  required String generatedAt,
}) => pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.start,
  children: [
    pdfText(l10n.appTitle, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
    pw.SizedBox(height: 4),
    pdfText(l10n.reportExportTitle, style: const pw.TextStyle(fontSize: 13)),
    pw.SizedBox(height: 8),
    pdfText(range),
    if (vehicles.isNotEmpty) pdfText(l10n.reportPdfVehicles(vehicles)),
    pdfText(l10n.reportPdfGeneratedAt(generatedAt)),
  ],
);

pw.Widget _summary(
  AppLocalizations l10n,
  Report report, {
  required String Function(int) amount,
  required String Function(String) digits,
}) {
  final summary = report.summary;
  pw.Widget cell(String label, String value) => pw.Expanded(
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pdfText(label, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
        pdfText(value, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
      ],
    ),
  );
  return pw.Container(
    padding: const pw.EdgeInsets.all(10),
    decoration: const pw.BoxDecoration(
      color: PdfColors.grey100,
      borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
    ),
    child: pw.Row(
      children: [
        cell(l10n.reportPdfEntryCount, amount(summary.entryCount)),
        cell(l10n.reportPdfTotalCost, l10n.reportPdfToman(amount(summary.totalCost))),
        cell(l10n.reportPdfServiceCount, amount(summary.serviceCount)),
        cell(
          l10n.reportPdfFuelVolume,
          digits(NumberFormat('0.#', 'en').format(summary.fuelVolume)),
        ),
      ],
    ),
  );
}

/// One vehicle's rows. `pw.Table` ignores the text direction, so the columns are reversed to
/// read right to left.
pw.Widget _vehicleTable(
  AppLocalizations l10n,
  List<ReportRow> rows, {
  required String Function(DateTime) date,
  required String Function(int) amount,
  required String Function(String) digits,
}) {
  final vehicle = rows.first.vehicle;
  final plate = switch (vehicle?.plate) {
    final plate? => digits(
      l10n.vehiclePlateText(plate.twoDigits, plate.letter, plate.threeDigits, plate.provinceCode),
    ),
    null => '',
  };
  final total = rows.fold(0, (sum, row) => sum + row.amount);
  const bold = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9);
  const regular = pw.TextStyle(fontSize: 9);
  pw.TableRow line(List<String> cells, {pw.TextStyle style = regular, PdfColor? color}) =>
      pw.TableRow(
        decoration: color == null ? null : pw.BoxDecoration(color: color),
        children: [
          for (final cell in cells.reversed)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              child: pdfText(cell, style: style, textAlign: pw.TextAlign.right),
            ),
        ],
      );
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pdfText(
        [vehicle?.nickname ?? '', plate].where((part) => part.isNotEmpty).join(' • '),
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 6),
      pw.Table(
        border: const pw.TableBorder(
          horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
          bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
          top: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
        ),
        // Reversed like the cells: amount, km, description, type, plate, vehicle, date.
        columnWidths: const {
          0: pw.FlexColumnWidth(1.6),
          1: pw.FlexColumnWidth(1.1),
          2: pw.FlexColumnWidth(4),
          3: pw.FlexColumnWidth(0.9),
          4: pw.FlexColumnWidth(1.8),
          5: pw.FlexColumnWidth(1.6),
          6: pw.FlexColumnWidth(1.2),
        },
        children: [
          line(
            [
              l10n.reportColumnDate,
              l10n.reportColumnVehicle,
              l10n.reportColumnPlate,
              l10n.reportColumnType,
              l10n.reportColumnDescription,
              l10n.reportColumnKm,
              l10n.reportColumnAmount,
            ],
            style: bold,
            color: PdfColors.grey200,
          ),
          for (final row in rows)
            line([
              date(row.date),
              row.vehicle?.nickname ?? '',
              plate,
              reportTypeLabel(row.type, l10n),
              digits(row.description),
              row.km == null ? '' : amount(row.km!),
              amount(row.amount),
            ]),
          line(
            [l10n.reportTotalRow, '', '', '', '', '', amount(total)],
            style: bold,
            color: PdfColors.grey100,
          ),
        ],
      ),
    ],
  );
}

/// The images on pages of their own, then the other files by name.
void _addAttachments(
  pw.Document document,
  AppLocalizations l10n,
  List<ReportAttachment> attachments, {
  required String Function(DateTime) date,
}) {
  final images = <(ReportAttachment, pw.ImageProvider)>[];
  final others = <ReportAttachment>[];
  for (final attachment in attachments) {
    final image = _decode(attachment.image);
    if (image == null) {
      others.add(attachment);
    } else {
      images.add((attachment, image));
    }
  }
  pw.Widget caption(ReportAttachment attachment) =>
      pdfText('${date(attachment.date)} • ${attachment.fileName}');
  for (final (attachment, image) in images) {
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pdfText(
              l10n.reportContentImages,
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
            ),
            caption(attachment),
            pw.SizedBox(height: 8),
            pw.Expanded(
              child: pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
            ),
          ],
        ),
      ),
    );
  }
  if (others.isEmpty) return;
  document.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pdfText(
            l10n.reportPdfOtherFiles,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          for (final attachment in others) caption(attachment),
        ],
      ),
    ),
  );
}

/// The image, or `null` when there are no bytes or they are not a known image format.
pw.ImageProvider? _decode(Uint8List? bytes) {
  if (bytes == null) return null;
  try {
    return pw.MemoryImage(bytes);
  } catch (_) {
    return null;
  }
}
