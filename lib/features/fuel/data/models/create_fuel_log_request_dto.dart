import '../../domain/entities/new_fuel_log.dart';

/// Body of `POST /api/vehicles/:id/fuel`: dates in ISO-8601 UTC, `null` for absent optionals.
class CreateFuelLogRequestDto {
  const CreateFuelLogRequestDto(this.log);

  final NewFuelLog log;

  Map<String, dynamic> toJson() => {
    'fueledAt': log.fueledAt.toUtc().toIso8601String(),
    'odometerKm': log.odometerKm,
    'fuelType': log.fuelType.wire,
    'volume': log.volume,
    'totalCost': log.totalCost,
    'isFullFill': log.isFullFill,
    'station': log.station,
    'paymentMethod': log.paymentMethod?.wire,
    'notes': log.notes,
  };
}
