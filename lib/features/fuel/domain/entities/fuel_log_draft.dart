import 'package:equatable/equatable.dart';

import 'fuel_payment_method.dart';
import 'fuel_type.dart';

/// What the "ثبت سوخت‌گیری" form holds before it is checked. `FuelRules.validate` turns it into
/// a `NewFuelLog`.
class FuelLogDraft extends Equatable {
  const FuelLogDraft({
    this.fueledDay,
    this.fueledMinutes,
    this.odometerKm,
    this.fuelType = FuelType.regular,
    this.volume,
    this.totalCost,
    this.isFullFill = true,
    this.station = '',
    this.paymentMethod,
    this.notes = '',
  });

  /// The day of the fill-up (local midnight); `null` means today.
  final DateTime? fueledDay;

  /// The time as minutes since midnight; `null` means the current time of day.
  final int? fueledMinutes;

  /// The odometer at the fill-up; `null` means the vehicle's current mileage.
  final int? odometerKm;
  final FuelType fuelType;

  /// Litres (cubic metres for CNG); `null` until typed.
  final double? volume;

  /// Toman; `null` until typed.
  final int? totalCost;
  final bool isFullFill;
  final String station;
  final FuelPaymentMethod? paymentMethod;
  final String notes;

  /// When the fill-up took place: [fueledDay] at [fueledMinutes], today at [now]'s time by default.
  DateTime fueledAt(DateTime now) {
    final day = fueledDay ?? DateTime(now.year, now.month, now.day);
    final minutes = fueledMinutes ?? now.hour * 60 + now.minute;
    return DateTime(day.year, day.month, day.day, minutes ~/ 60, minutes % 60);
  }

  /// Toman per litre (or cubic metre), rounded; `null` without a volume or a cost.
  int? get ratePerUnit {
    final volume = this.volume;
    final cost = totalCost;
    if (volume == null || volume <= 0 || cost == null) return null;
    return (cost / volume).round();
  }

  FuelLogDraft copyWith({
    DateTime? Function()? fueledDay,
    int? Function()? fueledMinutes,
    int? Function()? odometerKm,
    FuelType? fuelType,
    double? Function()? volume,
    int? Function()? totalCost,
    bool? isFullFill,
    String? station,
    FuelPaymentMethod? Function()? paymentMethod,
    String? notes,
  }) => FuelLogDraft(
    fueledDay: fueledDay == null ? this.fueledDay : fueledDay(),
    fueledMinutes: fueledMinutes == null ? this.fueledMinutes : fueledMinutes(),
    odometerKm: odometerKm == null ? this.odometerKm : odometerKm(),
    fuelType: fuelType ?? this.fuelType,
    volume: volume == null ? this.volume : volume(),
    totalCost: totalCost == null ? this.totalCost : totalCost(),
    isFullFill: isFullFill ?? this.isFullFill,
    station: station ?? this.station,
    paymentMethod: paymentMethod == null ? this.paymentMethod : paymentMethod(),
    notes: notes ?? this.notes,
  );

  @override
  List<Object?> get props => [
    fueledDay,
    fueledMinutes,
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
