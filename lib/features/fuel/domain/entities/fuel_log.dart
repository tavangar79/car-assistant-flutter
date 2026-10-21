import 'package:equatable/equatable.dart';

import 'fuel_payment_method.dart';
import 'fuel_type.dart';

/// One fill-up of a vehicle. [economy] (litres per 100 km) is computed by the server from the
/// previous full fill and is `null` when it can't be.
class FuelLog extends Equatable {
  const FuelLog({
    required this.id,
    required this.vehicleId,
    required this.fueledAt,
    required this.odometerKm,
    required this.fuelType,
    required this.volume,
    required this.totalCost,
    required this.isFullFill,
    required this.createdAt,
    required this.updatedAt,
    this.station,
    this.paymentMethod,
    this.notes,
    this.economy,
  });

  final String id;
  final String vehicleId;
  final DateTime fueledAt;
  final int odometerKm;
  final FuelType fuelType;

  /// Litres (cubic metres for CNG), at most 2 decimals.
  final double volume;

  /// Toman.
  final int totalCost;
  final bool isFullFill;
  final String? station;
  final FuelPaymentMethod? paymentMethod;
  final String? notes;
  final double? economy;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    vehicleId,
    fueledAt,
    odometerKm,
    fuelType,
    volume,
    totalCost,
    isFullFill,
    station,
    paymentMethod,
    notes,
    economy,
    createdAt,
    updatedAt,
  ];
}
