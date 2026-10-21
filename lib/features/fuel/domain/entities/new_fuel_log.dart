import 'package:equatable/equatable.dart';

import 'fuel_payment_method.dart';
import 'fuel_type.dart';

/// A checked fill-up, ready to send (`POST /api/vehicles/:id/fuel`).
class NewFuelLog extends Equatable {
  const NewFuelLog({
    required this.fueledAt,
    required this.odometerKm,
    required this.fuelType,
    required this.volume,
    required this.totalCost,
    required this.isFullFill,
    this.station,
    this.paymentMethod,
    this.notes,
  });

  final DateTime fueledAt;
  final int odometerKm;
  final FuelType fuelType;
  final double volume;
  final int totalCost;
  final bool isFullFill;
  final String? station;
  final FuelPaymentMethod? paymentMethod;
  final String? notes;

  @override
  List<Object?> get props => [
    fueledAt,
    odometerKm,
    fuelType,
    volume,
    totalCost,
    isFullFill,
    station,
    paymentMethod,
    notes,
  ];
}
