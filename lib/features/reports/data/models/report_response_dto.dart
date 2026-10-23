import '../../../history/data/models/history_response_dto.dart';
import '../../domain/entities/report.dart';

/// Body of `GET /api/reports`: `{ entries: [HistoryEntry], summary }`, entries oldest first.
class ReportResponseDto {
  const ReportResponseDto({required this.entries, required this.summary});

  factory ReportResponseDto.fromJson(Map<String, dynamic> json) => ReportResponseDto(
    entries: (json['entries'] as List<dynamic>)
        .map((entry) => HistoryEntryDto.fromJson(entry as Map<String, dynamic>))
        .toList(),
    summary: HistorySummaryDto.fromJson(json['summary'] as Map<String, dynamic>),
  );

  final List<HistoryEntryDto> entries;
  final HistorySummaryDto summary;

  Report toEntity() =>
      Report(entries: entries.map((dto) => dto.toEntity()).toList(), summary: summary.toEntity());
}
