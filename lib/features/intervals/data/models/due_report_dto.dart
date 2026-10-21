import '../../domain/entities/due_item.dart';
import '../../domain/entities/due_report.dart';
import '../../domain/entities/due_status.dart';

/// Body of `GET /api/vehicles/:id/due`: `{ asOf, mileageKm, items: [...] }`.
class DueReportDto {
  const DueReportDto({required this.asOf, required this.mileageKm, required this.items});

  factory DueReportDto.fromJson(Map<String, dynamic> json) => DueReportDto(
    asOf: DateTime.parse(json['asOf'] as String),
    mileageKm: json['mileageKm'] as int,
    items: (json['items'] as List<dynamic>)
        .map((item) => DueItemDto.fromJson(item as Map<String, dynamic>))
        .toList(),
  );

  final DateTime asOf;
  final int mileageKm;
  final List<DueItemDto> items;

  DueReport toEntity() => DueReport(
    asOf: asOf,
    mileageKm: mileageKm,
    items: items.map((dto) => dto.toEntity()).toList(),
  );
}

class DueItemDto {
  const DueItemDto({
    required this.intervalId,
    required this.title,
    required this.description,
    required this.icon,
    required this.coversItemIds,
    required this.status,
    required this.baselineKm,
    required this.baselineDate,
    required this.baselineServiceId,
    required this.dueKm,
    required this.dueDate,
    required this.remainingKm,
    required this.remainingDays,
  });

  factory DueItemDto.fromJson(Map<String, dynamic> json) => DueItemDto(
    intervalId: json['intervalId'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    icon: json['icon'] as String,
    coversItemIds: (json['coversItemIds'] as List<dynamic>).cast<String>(),
    status: json['status'] as String,
    baselineKm: json['baselineKm'] as int,
    baselineDate: DateTime.parse(json['baselineDate'] as String),
    baselineServiceId: json['baselineServiceId'] as String?,
    dueKm: json['dueKm'] as int,
    dueDate: DateTime.parse(json['dueDate'] as String),
    remainingKm: json['remainingKm'] as int,
    remainingDays: json['remainingDays'] as int,
  );

  final String intervalId;
  final String title;
  final String description;
  final String icon;
  final List<String> coversItemIds;

  /// `overdue | due_soon | upcoming | ok`.
  final String status;
  final int baselineKm;
  final DateTime baselineDate;
  final String? baselineServiceId;
  final int dueKm;
  final DateTime dueDate;
  final int remainingKm;
  final int remainingDays;

  DueItem toEntity() => DueItem(
    intervalId: intervalId,
    title: title,
    description: description,
    icon: icon,
    coversItemIds: coversItemIds,
    status: DueStatus.fromApi(status),
    baselineKm: baselineKm,
    baselineDate: baselineDate,
    baselineServiceId: baselineServiceId,
    dueKm: dueKm,
    dueDate: dueDate,
    remainingKm: remainingKm,
    remainingDays: remainingDays,
  );
}
