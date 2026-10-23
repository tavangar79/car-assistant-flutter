import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../history/domain/entities/history_summary.dart';
import '../entities/report.dart';
import '../entities/report_options.dart';
import '../repositories/report_repository.dart';

/// The report data for [ReportOptions], the range resolved at `now`. Without a record type there
/// is nothing to ask for, so it answers an empty report without a request.
class GetReport {
  const GetReport(this._repository, {required this.now});

  final ReportRepository _repository;

  /// The clock the range is resolved with.
  final DateTime Function() now;

  Future<Either<Failure, Report>> call(ReportOptions options) async {
    if (!options.canExport) return const Right(empty);
    return _repository.getReport(options.toQuery(now()));
  }

  static const empty = Report(
    entries: [],
    summary: HistorySummary(totalCost: 0, serviceCount: 0, fuelVolume: 0, entryCount: 0),
  );
}
