import '../../domain/entities/month_cost.dart';
import 'vehicle_cost_dto.dart';

/// `{ "jalaliYear", "jalaliMonth", "from", "to", "totalCost", "byVehicle": [...] }`.
class MonthCostDto {
  const MonthCostDto({
    required this.jalaliYear,
    required this.jalaliMonth,
    required this.from,
    required this.to,
    required this.totalCost,
    required this.byVehicle,
  });

  factory MonthCostDto.fromJson(Map<String, dynamic> json) => MonthCostDto(
    jalaliYear: (json['jalaliYear'] as num).toInt(),
    jalaliMonth: (json['jalaliMonth'] as num).toInt(),
    from: json['from'] as String,
    to: json['to'] as String,
    totalCost: (json['totalCost'] as num).toInt(),
    byVehicle: [
      for (final item in json['byVehicle'] as List<dynamic>)
        VehicleCostDto.fromJson(item as Map<String, dynamic>),
    ],
  );

  final int jalaliYear;
  final int jalaliMonth;

  /// ISO-8601 UTC, inclusive.
  final String from;

  /// ISO-8601 UTC, exclusive.
  final String to;
  final int totalCost;
  final List<VehicleCostDto> byVehicle;

  MonthCost toEntity() => MonthCost(
    jalaliYear: jalaliYear,
    jalaliMonth: jalaliMonth,
    from: DateTime.parse(from),
    to: DateTime.parse(to),
    totalCost: totalCost,
    byVehicle: [for (final item in byVehicle) item.toEntity()],
  );
}
