import '../../../../core/error/failure.dart';

/// 422: more records match than one report may hold.
class ReportTooLargeFailure extends Failure {
  const ReportTooLargeFailure() : super('Report range too large');
}
