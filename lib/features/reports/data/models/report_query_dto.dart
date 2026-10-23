import '../../domain/entities/report_query.dart';

/// The query string of `GET /api/reports`. Absent values are left out; dates go out as ISO-8601
/// UTC.
class ReportQueryDto {
  const ReportQueryDto(this.query);

  final ReportQuery query;

  Map<String, dynamic> toQueryParameters() => {
    if (query.vehicleIds.isNotEmpty) 'vehicleIds': query.vehicleIds.join(','),
    'types': query.types.map((type) => type.wire).join(','),
    if (query.from case final from?) 'from': from.toUtc().toIso8601String(),
    if (query.to case final to?) 'to': to.toUtc().toIso8601String(),
  };
}
