import 'package:equatable/equatable.dart';

/// One vehicle's cost (integer toman) inside a dashboard month.
class VehicleCost extends Equatable {
  const VehicleCost({required this.vehicleId, required this.totalCost});

  final String vehicleId;
  final int totalCost;

  @override
  List<Object?> get props => [vehicleId, totalCost];
}
