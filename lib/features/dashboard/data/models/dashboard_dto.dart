import '../../domain/entities/dashboard.dart';
import 'month_cost_dto.dart';
import 'vehicle_summary_dto.dart';

/// `GET /api/dashboard` → `{ "dashboard": { "jalaliYear", "yearTotalCost", "invoiceCount",
/// "attentionCount", "vehicles": [...], "months": [...] } }`.
class DashboardDto {
  const DashboardDto({
    required this.jalaliYear,
    required this.yearTotalCost,
    required this.invoiceCount,
    required this.attentionCount,
    required this.vehicles,
    required this.months,
  });

  /// Parses the `{ "dashboard": … }` envelope.
  factory DashboardDto.fromEnvelope(Map<String, dynamic> json) =>
      DashboardDto.fromJson(json['dashboard'] as Map<String, dynamic>);

  factory DashboardDto.fromJson(Map<String, dynamic> json) => DashboardDto(
    jalaliYear: (json['jalaliYear'] as num).toInt(),
    yearTotalCost: (json['yearTotalCost'] as num).toInt(),
    invoiceCount: (json['invoiceCount'] as num).toInt(),
    attentionCount: (json['attentionCount'] as num).toInt(),
    vehicles: [
      for (final item in json['vehicles'] as List<dynamic>)
        VehicleSummaryDto.fromJson(item as Map<String, dynamic>),
    ],
    months: [
      for (final item in json['months'] as List<dynamic>)
        MonthCostDto.fromJson(item as Map<String, dynamic>),
    ],
  );

  final int jalaliYear;
  final int yearTotalCost;
  final int invoiceCount;
  final int attentionCount;
  final List<VehicleSummaryDto> vehicles;
  final List<MonthCostDto> months;

  Dashboard toEntity() => Dashboard(
    jalaliYear: jalaliYear,
    yearTotalCost: yearTotalCost,
    invoiceCount: invoiceCount,
    attentionCount: attentionCount,
    vehicles: [for (final item in vehicles) item.toEntity()],
    months: [for (final item in months) item.toEntity()],
  );
}
