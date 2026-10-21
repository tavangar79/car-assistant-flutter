import 'package:car_assistant/features/dashboard/domain/entities/dashboard.dart';
import 'package:car_assistant/features/dashboard/domain/entities/month_cost.dart';
import 'package:car_assistant/features/dashboard/domain/entities/vehicle_cost.dart';
import 'package:car_assistant/features/dashboard/domain/entities/vehicle_summary.dart';

/// The `GET /api/dashboard` sample of API-PHASE4.md T4.4.
final dashboardJson = <String, dynamic>{
  'dashboard': {
    'jalaliYear': 1403,
    'yearTotalCost': 24850000,
    'invoiceCount': 14,
    'attentionCount': 3,
    'vehicles': [
      {'vehicleId': '664f', 'attentionCount': 2, 'yearTotalCost': 12000000},
    ],
    'months': [
      {
        'jalaliYear': 1403,
        'jalaliMonth': 3,
        'from': '2024-05-20T20:30:00.000Z',
        'to': '2024-06-20T20:30:00.000Z',
        'totalCost': 800000,
        'byVehicle': [
          {'vehicleId': '664f', 'totalCost': 800000},
        ],
      },
    ],
  },
};

final dashboard = Dashboard(
  jalaliYear: 1403,
  yearTotalCost: 24850000,
  invoiceCount: 14,
  attentionCount: 3,
  vehicles: const [VehicleSummary(vehicleId: '664f', attentionCount: 2, yearTotalCost: 12000000)],
  months: [
    MonthCost(
      jalaliYear: 1403,
      jalaliMonth: 3,
      from: DateTime.utc(2024, 5, 20, 20, 30),
      to: DateTime.utc(2024, 6, 20, 20, 30),
      totalCost: 800000,
      byVehicle: const [VehicleCost(vehicleId: '664f', totalCost: 800000)],
    ),
  ],
);

/// A month of the Home chart with one cost per vehicle (vehicle ids `v1`, `v2`, …).
MonthCost monthCost(int year, int month, List<int> costs) => MonthCost(
  jalaliYear: year,
  jalaliMonth: month,
  from: DateTime.utc(2026),
  to: DateTime.utc(2026),
  totalCost: costs.fold(0, (sum, cost) => sum + cost),
  byVehicle: [
    for (final (index, cost) in costs.indexed)
      VehicleCost(vehicleId: 'v${index + 1}', totalCost: cost),
  ],
);

/// A dashboard for the garage `v1`, `v2` over اردیبهشت … مهر ۱۴۰۵.
Dashboard homeDashboard({
  int yearTotalCost = 24850000,
  int invoiceCount = 14,
  List<int> attention = const [0, 2],
  List<List<int>>? costs,
}) {
  final perMonth = costs ?? List.generate(6, (_) => [0, 0]);
  return Dashboard(
    jalaliYear: 1405,
    yearTotalCost: yearTotalCost,
    invoiceCount: invoiceCount,
    attentionCount: attention.fold(0, (sum, count) => sum + count),
    vehicles: [
      for (final (index, count) in attention.indexed)
        VehicleSummary(vehicleId: 'v${index + 1}', attentionCount: count, yearTotalCost: 0),
    ],
    months: [
      for (final (index, monthCosts) in perMonth.indexed) monthCost(1405, 2 + index, monthCosts),
    ],
  );
}
