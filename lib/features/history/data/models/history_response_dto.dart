import '../../../expenses/data/models/expense_dto.dart';
import '../../../fuel/data/models/fuel_log_dto.dart';
import '../../../services/data/models/service_visit_dto.dart';
import '../../domain/entities/history_entry.dart';
import '../../domain/entities/history_result.dart';
import '../../domain/entities/history_summary.dart';
import '../../domain/entities/history_type.dart';

/// Body of `GET /api/history`: `{ entries: [HistoryEntry], nextCursor, summary }`.
class HistoryResponseDto {
  const HistoryResponseDto({
    required this.entries,
    required this.nextCursor,
    required this.summary,
  });

  factory HistoryResponseDto.fromJson(Map<String, dynamic> json) => HistoryResponseDto(
    entries: (json['entries'] as List<dynamic>)
        .map((entry) => HistoryEntryDto.fromJson(entry as Map<String, dynamic>))
        .toList(),
    nextCursor: json['nextCursor'] as String?,
    summary: switch (json['summary']) {
      final Map<String, dynamic> summary => HistorySummaryDto.fromJson(summary),
      _ => null,
    },
  );

  final List<HistoryEntryDto> entries;
  final String? nextCursor;
  final HistorySummaryDto? summary;

  HistoryResult toEntity() => HistoryResult(
    entries: entries.map((dto) => dto.toEntity()).toList(),
    nextCursor: nextCursor,
    summary: summary?.toEntity(),
  );
}

/// One entry: `{ type, id, vehicleId, occurredAt, cost, hasAttachment, service, fuelLog,
/// expense }`, with the full Service / FuelLog / Expense JSON of its type and `null` for the others.
class HistoryEntryDto {
  const HistoryEntryDto({
    required this.type,
    required this.id,
    required this.vehicleId,
    required this.occurredAt,
    required this.cost,
    required this.hasAttachment,
    required this.service,
    required this.fuelLog,
    required this.expense,
  });

  factory HistoryEntryDto.fromJson(Map<String, dynamic> json) => HistoryEntryDto(
    type: json['type'] as String,
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    occurredAt: DateTime.parse(json['occurredAt'] as String),
    cost: json['cost'] as int,
    hasAttachment: json['hasAttachment'] as bool,
    service: switch (json['service']) {
      final Map<String, dynamic> service => ServiceVisitDto.fromJson(service),
      _ => null,
    },
    fuelLog: switch (json['fuelLog']) {
      final Map<String, dynamic> fuelLog => FuelLogDto.fromJson(fuelLog),
      _ => null,
    },
    expense: switch (json['expense']) {
      final Map<String, dynamic> expense => ExpenseDto.fromJson(expense),
      _ => null,
    },
  );

  final String type;
  final String id;
  final String vehicleId;
  final DateTime occurredAt;
  final int cost;
  final bool hasAttachment;
  final ServiceVisitDto? service;
  final FuelLogDto? fuelLog;
  final ExpenseDto? expense;

  HistoryEntry toEntity() => HistoryEntry(
    type: HistoryType.fromWire(type),
    id: id,
    vehicleId: vehicleId,
    occurredAt: occurredAt,
    cost: cost,
    hasAttachment: hasAttachment,
    service: service?.toEntity(),
    fuelLog: fuelLog?.toEntity(),
    expense: expense?.toEntity(),
  );
}

/// `{ totalCost, serviceCount, fuelVolume, entryCount }`.
class HistorySummaryDto {
  const HistorySummaryDto({
    required this.totalCost,
    required this.serviceCount,
    required this.fuelVolume,
    required this.entryCount,
  });

  factory HistorySummaryDto.fromJson(Map<String, dynamic> json) => HistorySummaryDto(
    totalCost: json['totalCost'] as int,
    serviceCount: json['serviceCount'] as int,
    fuelVolume: (json['fuelVolume'] as num).toDouble(),
    entryCount: json['entryCount'] as int,
  );

  final int totalCost;
  final int serviceCount;
  final double fuelVolume;
  final int entryCount;

  HistorySummary toEntity() => HistorySummary(
    totalCost: totalCost,
    serviceCount: serviceCount,
    fuelVolume: fuelVolume,
    entryCount: entryCount,
  );
}
