import '../../domain/entities/fuel_log.dart';
import '../../domain/entities/fuel_payment_method.dart';
import '../../domain/entities/fuel_type.dart';

/// JSON shape of a fill-up (the `FuelLog` object of every response).
class FuelLogDto {
  const FuelLogDto({
    required this.id,
    required this.vehicleId,
    required this.fueledAt,
    required this.odometerKm,
    required this.fuelType,
    required this.volume,
    required this.totalCost,
    required this.isFullFill,
    required this.station,
    required this.paymentMethod,
    required this.notes,
    required this.economy,
    required this.createdAt,
    required this.updatedAt,
    this.locked = false,
  });

  factory FuelLogDto.fromJson(Map<String, dynamic> json) => FuelLogDto(
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    fueledAt: DateTime.parse(json['fueledAt'] as String),
    odometerKm: json['odometerKm'] as int,
    fuelType: json['fuelType'] as String,
    volume: (json['volume'] as num).toDouble(),
    totalCost: json['totalCost'] as int,
    isFullFill: json['isFullFill'] as bool,
    station: json['station'] as String?,
    paymentMethod: json['paymentMethod'] as String?,
    notes: json['notes'] as String?,
    economy: (json['economy'] as num?)?.toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    // Phase 6; absent from older servers.
    locked: json['locked'] as bool? ?? false,
  );

  final String id;
  final String vehicleId;
  final DateTime fueledAt;
  final int odometerKm;
  final String fuelType;
  final double volume;
  final int totalCost;
  final bool isFullFill;
  final String? station;
  final String? paymentMethod;
  final String? notes;
  final double? economy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool locked;

  FuelLog toEntity() => FuelLog(
    id: id,
    vehicleId: vehicleId,
    fueledAt: fueledAt,
    odometerKm: odometerKm,
    fuelType: FuelType.fromWire(fuelType),
    volume: volume,
    totalCost: totalCost,
    isFullFill: isFullFill,
    station: station,
    paymentMethod: switch (paymentMethod) {
      final method? => FuelPaymentMethod.fromWire(method),
      null => null,
    },
    notes: notes,
    economy: economy,
    createdAt: createdAt,
    updatedAt: updatedAt,
    locked: locked,
  );
}
