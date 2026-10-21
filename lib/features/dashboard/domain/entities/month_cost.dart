import 'package:equatable/equatable.dart';

import 'vehicle_cost.dart';

/// The cost of one Jalali month: [from] inclusive, [to] exclusive (UTC), with every vehicle of the
/// garage in [byVehicle], garage order (zero costs included).
class MonthCost extends Equatable {
  const MonthCost({
    required this.jalaliYear,
    required this.jalaliMonth,
    required this.from,
    required this.to,
    required this.totalCost,
    required this.byVehicle,
  });

  final int jalaliYear;

  /// 1 (فروردین) … 12 (اسفند).
  final int jalaliMonth;
  final DateTime from;
  final DateTime to;
  final int totalCost;
  final List<VehicleCost> byVehicle;

  @override
  List<Object?> get props => [jalaliYear, jalaliMonth, from, to, totalCost, byVehicle];
}
