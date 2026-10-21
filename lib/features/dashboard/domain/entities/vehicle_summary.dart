import 'package:equatable/equatable.dart';

/// One vehicle's row on the dashboard: its due-soon/overdue count and this Jalali year's cost.
class VehicleSummary extends Equatable {
  const VehicleSummary({
    required this.vehicleId,
    required this.attentionCount,
    required this.yearTotalCost,
  });

  final String vehicleId;
  final int attentionCount;
  final int yearTotalCost;

  @override
  List<Object?> get props => [vehicleId, attentionCount, yearTotalCost];
}
