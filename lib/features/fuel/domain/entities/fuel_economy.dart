import 'package:equatable/equatable.dart';

import 'fuel_log.dart';
import 'fuel_type.dart';

/// The consumption preview of the fuel form: the entered fill-up against the vehicle's saved logs.
class FuelEconomyPreview extends Equatable {
  const FuelEconomyPreview({required this.economy, required this.distanceKm, required this.volume});

  /// Litres (cubic metres for CNG) per 100 km, rounded to 2 decimals.
  final double economy;

  /// Distance since the previous full fill.
  final int distanceKm;

  /// Fuel bought since the previous full fill, this fill-up included.
  final double volume;

  @override
  List<Object?> get props => [economy, distanceKm, volume];
}

/// The server's economy formula, applied to a fill-up that is not saved yet:
/// the entered values form the last log, the previous full fill is the nearest full fill of
/// [logs] with a lower odometer.
///
/// `null` unless the entered fill-up is a full fill, a previous full fill exists, every log after
/// it has the same fuel type as it (the entered one included) and the distance is positive.
FuelEconomyPreview? previewFuelEconomy(
  List<FuelLog> logs, {
  required int odometerKm,
  required FuelType fuelType,
  required double? volume,
  required bool isFullFill,
}) {
  if (!isFullFill || volume == null || volume <= 0) return null;
  final sorted = [...logs.where((log) => log.odometerKm < odometerKm)]..sort(_byOrder);
  final previousIndex = sorted.lastIndexWhere((log) => log.isFullFill);
  if (previousIndex < 0) return null;
  final previous = sorted[previousIndex];
  final between = sorted.sublist(previousIndex + 1);
  if (fuelType != previous.fuelType || between.any((log) => log.fuelType != previous.fuelType)) {
    return null;
  }
  final distanceKm = odometerKm - previous.odometerKm;
  if (distanceKm <= 0) return null;
  final total = between.fold(volume, (sum, log) => sum + log.volume);
  return FuelEconomyPreview(
    economy: _round2(total / distanceKm * 100),
    distanceKm: distanceKm,
    volume: _round2(total),
  );
}

/// Ascending by `fueledAt`, then `odometerKm`, then `createdAt` (the server's order).
int _byOrder(FuelLog a, FuelLog b) {
  final byDate = a.fueledAt.compareTo(b.fueledAt);
  if (byDate != 0) return byDate;
  final byKm = a.odometerKm.compareTo(b.odometerKm);
  if (byKm != 0) return byKm;
  return a.createdAt.compareTo(b.createdAt);
}

double _round2(double value) => (value * 100).roundToDouble() / 100;
