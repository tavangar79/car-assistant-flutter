import '../../domain/entities/vehicle_summary.dart';

/// `{ "vehicleId", "attentionCount", "yearTotalCost" }` inside `dashboard.vehicles`.
class VehicleSummaryDto {
  const VehicleSummaryDto({
    required this.vehicleId,
    required this.attentionCount,
    required this.yearTotalCost,
  });

  factory VehicleSummaryDto.fromJson(Map<String, dynamic> json) => VehicleSummaryDto(
    vehicleId: json['vehicleId'] as String,
    attentionCount: (json['attentionCount'] as num).toInt(),
    yearTotalCost: (json['yearTotalCost'] as num).toInt(),
  );

  final String vehicleId;
  final int attentionCount;
  final int yearTotalCost;

  VehicleSummary toEntity() => VehicleSummary(
    vehicleId: vehicleId,
    attentionCount: attentionCount,
    yearTotalCost: yearTotalCost,
  );
}
