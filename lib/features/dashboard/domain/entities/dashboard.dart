import 'package:equatable/equatable.dart';

import 'month_cost.dart';
import 'vehicle_summary.dart';

/// The garage dashboard ("داشبورد کلی گاراژ") across all of the user's vehicles.
class Dashboard extends Equatable {
  const Dashboard({
    required this.jalaliYear,
    required this.yearTotalCost,
    required this.invoiceCount,
    required this.attentionCount,
    required this.vehicles,
    required this.months,
  });

  /// The current Jalali year (Tehran time).
  final int jalaliYear;

  /// The cost of every record since the start of [jalaliYear] ("هزینه کل امسال").
  final int yearTotalCost;

  /// Services with an invoice plus expenses with an attachment, all time.
  final int invoiceCount;

  /// Due-soon and overdue items over all vehicles ("مورد فوری").
  final int attentionCount;

  /// Garage order.
  final List<VehicleSummary> vehicles;

  /// The last 6 Jalali months including the current one, oldest first.
  final List<MonthCost> months;

  /// The first vehicle (garage order) with something due, or `null` when nothing is.
  String? get firstVehicleNeedingAttention {
    for (final vehicle in vehicles) {
      if (vehicle.attentionCount > 0) return vehicle.vehicleId;
    }
    return null;
  }

  /// Whether any chart month has a cost.
  bool get hasMonthCosts => months.any((month) => month.totalCost > 0);

  @override
  List<Object?> get props => [
    jalaliYear,
    yearTotalCost,
    invoiceCount,
    attentionCount,
    vehicles,
    months,
  ];
}
