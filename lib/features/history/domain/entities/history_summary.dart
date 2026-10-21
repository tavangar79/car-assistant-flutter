import 'package:equatable/equatable.dart';

/// Totals over the whole filtered history (not just one page).
class HistorySummary extends Equatable {
  const HistorySummary({
    required this.totalCost,
    required this.serviceCount,
    required this.fuelVolume,
    required this.entryCount,
  });

  /// Toman.
  final int totalCost;
  final int serviceCount;

  /// Litres of the non-CNG fill-ups, rounded to 1 decimal.
  final double fuelVolume;
  final int entryCount;

  @override
  List<Object?> get props => [totalCost, serviceCount, fuelVolume, entryCount];
}
