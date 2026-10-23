import 'dart:typed_data';

import '../../../../l10n/app_localizations.dart';
import '../../../services/domain/entities/service_category.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/report_options.dart';
import '../../domain/repositories/report_repository.dart';
import '../export/report_csv_builder.dart';
import '../export/report_file_name.dart';
import '../export/report_pdf_builder.dart';
import 'report_file_saver.dart';

/// Builds a report file from loaded report data and hands it to the [saver]. For a PDF with
/// images it first downloads each JPEG/PNG invoice and attachment; a file that fails to load is
/// listed by name instead.
class ReportExporter {
  const ReportExporter({
    required this.repository,
    required this.saver,
    required this.loadFonts,
    required this.now,
  });

  final ReportRepository repository;
  final ReportFileSaver saver;
  final Future<ReportPdfFonts> Function() loadFonts;
  final DateTime Function() now;

  /// Throws when the file cannot be built or saved.
  Future<void> export(
    ReportFormat format, {
    required Report report,
    required ReportOptions options,
    required List<Vehicle> vehicles,
    required List<ServiceCategory> catalog,
    required AppLocalizations l10n,
  }) async {
    final generatedAt = now();
    final Uint8List bytes = switch (format) {
      ReportFormat.csv => buildReportCsv(report, vehicles: vehicles, catalog: catalog, l10n: l10n),
      ReportFormat.pdf => await _pdf(report, options, vehicles, catalog, l10n, generatedAt),
    };
    await saver.save(
      bytes,
      fileName: reportFileName(generatedAt, format),
      mimeType: format.mimeType,
    );
  }

  Future<Uint8List> _pdf(
    Report report,
    ReportOptions options,
    List<Vehicle> vehicles,
    List<ServiceCategory> catalog,
    AppLocalizations l10n,
    DateTime generatedAt,
  ) async {
    final (from, to) = options.range(generatedAt);
    return buildReportPdf(
      report,
      vehicles: vehicles,
      catalog: catalog,
      l10n: l10n,
      fonts: await loadFonts(),
      from: from,
      to: to,
      generatedAt: generatedAt,
      attachments: options.includeImages ? await _attachments(report) : const [],
    );
  }

  /// The service invoices and expense attachments of [report], in report order.
  Future<List<ReportAttachment>> _attachments(Report report) async {
    final attachments = <ReportAttachment>[];
    for (final entry in report.entries) {
      final service = entry.service;
      final expense = entry.expense;
      final (fileName, contentType, url) = switch ((service, expense)) {
        (final visit?, _) => (
          visit.invoice?.fileName,
          visit.invoice?.contentType,
          visit.invoiceUrl,
        ),
        (_, final paid?) => (
          paid.attachment?.fileName,
          paid.attachment?.contentType,
          paid.attachmentUrl,
        ),
        _ => (null, null, null),
      };
      if (fileName == null || url == null) continue;
      final image = _isImage(contentType) ? (await repository.getFile(url)).toNullable() : null;
      attachments.add(
        ReportAttachment(fileName: fileName, date: entry.occurredAt.toLocal(), image: image),
      );
    }
    return attachments;
  }

  static bool _isImage(String? contentType) =>
      contentType == 'image/jpeg' || contentType == 'image/png';
}
