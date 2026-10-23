import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/error/failure.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../data/datasources/report_remote_data_source.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/report_options.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/usecases/get_report.dart';
import '../export/report_pdf_builder.dart';
import 'report_exporter.dart';
import 'report_file_saver.dart';
import 'report_options_notifier.dart';

// Dependency wiring for the report export. Override [reportRepositoryProvider],
// [reportFileSaverProvider] and [reportFontsLoaderProvider] in tests.

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(ReportRemoteDataSource(ref.watch(dioProvider)));
});

final getReportProvider = Provider<GetReport>((ref) {
  return GetReport(ref.watch(reportRepositoryProvider), now: ref.watch(clockProvider));
});

final reportFileSaverProvider = Provider<ReportFileSaver>((ref) => const ReportFileSaver());

/// Loads the app's Vazirmatn font for the PDF.
final reportFontsLoaderProvider = Provider<Future<ReportPdfFonts> Function()>((ref) {
  Future<pw.Font> load(String asset) async => pw.Font.ttf(await rootBundle.load(asset));
  return () async => ReportPdfFonts(
    regular: await load('assets/fonts/Vazirmatn-Regular.ttf'),
    bold: await load('assets/fonts/Vazirmatn-Bold.ttf'),
  );
});

final reportExporterProvider = Provider<ReportExporter>((ref) {
  return ReportExporter(
    repository: ref.watch(reportRepositoryProvider),
    saver: ref.watch(reportFileSaverProvider),
    loadFonts: ref.watch(reportFontsLoaderProvider),
    now: ref.watch(clockProvider),
  );
});

/// The choices of the export page, keyed by the vehicle it opened on (`null`: every vehicle).
final reportOptionsProvider = NotifierProvider.autoDispose
    .family<ReportOptionsNotifier, ReportOptions, String?>(ReportOptionsNotifier.new);

/// How long the choices must stay unchanged before the preview is fetched.
const reportPreviewDebounce = Duration(milliseconds: 400);

/// The report data for the current choices (the preview line reads its summary, the download
/// buttons build the files from it). Debounced; the images box does not refetch it.
final reportPreviewProvider = FutureProvider.autoDispose.family<Report, String?>((ref, key) async {
  final options = ref.watch(reportOptionsProvider(key).select((o) => o.withImages(false)));
  final getReport = ref.watch(getReportProvider);
  var disposed = false;
  ref.onDispose(() => disposed = true);
  await Future<void>.delayed(reportPreviewDebounce);
  if (disposed) throw const Failure('Preview superseded');
  final result = await getReport(options);
  return result.getOrElse((failure) => throw failure);
});
