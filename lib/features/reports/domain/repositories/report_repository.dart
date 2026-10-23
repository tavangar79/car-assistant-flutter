import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/report.dart';
import '../entities/report_query.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class ReportRepository {
  /// Every service, fill-up and expense matching [query], oldest first, with their totals.
  Future<Either<Failure, Report>> getReport(ReportQuery query);

  /// The bytes of an invoice or attachment, by its relative URL (`invoiceUrl` / `attachmentUrl`).
  Future<Either<Failure, Uint8List>> getFile(String url);
}
