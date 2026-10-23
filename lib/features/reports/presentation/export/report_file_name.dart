import 'package:shamsi_date/shamsi_date.dart';

/// The two export formats and their file details.
enum ReportFormat {
  pdf('pdf', 'application/pdf'),
  csv('csv', 'text/csv');

  const ReportFormat(this.extension, this.mimeType);

  final String extension;
  final String mimeType;
}

/// `car-report-<Jalali yyyy-mm-dd>.<ext>` for the local day of [now], e.g.
/// `car-report-1403-08-25.pdf`.
String reportFileName(DateTime now, ReportFormat format) {
  final day = Jalali.fromDateTime(now.toLocal());
  String two(int n) => n.toString().padLeft(2, '0');
  return 'car-report-${day.year}-${two(day.month)}-${two(day.day)}.${format.extension}';
}
