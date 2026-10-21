import '../../domain/entities/vehicle_cost.dart';

/// `{ "vehicleId", "totalCost" }` inside `months[].byVehicle`.
class VehicleCostDto {
  const VehicleCostDto({required this.vehicleId, required this.totalCost});

  factory VehicleCostDto.fromJson(Map<String, dynamic> json) => VehicleCostDto(
    vehicleId: json['vehicleId'] as String,
    totalCost: (json['totalCost'] as num).toInt(),
  );

  final String vehicleId;
  final int totalCost;

  VehicleCost toEntity() => VehicleCost(vehicleId: vehicleId, totalCost: totalCost);
}
