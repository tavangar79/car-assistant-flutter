import '../../domain/entities/history_query.dart';

/// The query string of `GET /api/history`. Absent values are left out; `hasAttachment` is only
/// sent as `true`. Dates go out as ISO-8601 UTC.
class HistoryQueryDto {
  const HistoryQueryDto(this.query);

  final HistoryQuery query;

  Map<String, dynamic> toQueryParameters() => {
    if (query.vehicleIds.isNotEmpty) 'vehicleIds': query.vehicleIds.join(','),
    'type': query.type.wire,
    if (query.categories.isNotEmpty) 'categories': query.categories.join(','),
    if (query.attachmentsOnly) 'hasAttachment': 'true',
    if (query.from case final from?) 'from': from.toUtc().toIso8601String(),
    if (query.to case final to?) 'to': to.toUtc().toIso8601String(),
    'cursor': ?query.cursor,
    'limit': '${query.limit}',
  };
}
