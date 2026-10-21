import 'package:fpdart/fpdart.dart';

import '../../../vehicles/domain/entities/vehicle_rules.dart';
import 'fuel_failures.dart';
import 'fuel_field.dart';
import 'fuel_log_draft.dart';
import 'new_fuel_log.dart';

/// The backend's fuel-log rules, checked before sending so the user gets instant feedback.
abstract final class FuelRules {
  static const maxVolume = 1000;
  static const stationMaxLength = 100;
  static const notesMaxLength = 500;
  static const maxMileageKm = VehicleRules.maxMileageKm;

  /// Quick-adjust steps of the odometer, in screen order.
  static const odometerSteps = [50, 100, 500];

  /// [volume] rounded to the 2 decimals the backend accepts.
  static double roundVolume(double volume) => (volume * 100).roundToDouble() / 100;

  /// Checks [draft] for a vehicle currently at [currentKm]; on success returns the log to send.
  /// A date after [now] is rejected (`fueledAt`).
  static Either<InvalidFuelLogFailure, NewFuelLog> validate(
    FuelLogDraft draft, {
    required int currentKm,
    required DateTime now,
  }) {
    final fueledAt = draft.fueledAt(now);
    final odometerKm = draft.odometerKm ?? currentKm;
    final volume = draft.volume;
    final totalCost = draft.totalCost;
    final station = draft.station.trim();
    final notes = draft.notes.trim();
    final invalid = {
      if (fueledAt.isAfter(now)) FuelField.fueledAt,
      if (odometerKm < 0 || odometerKm > maxMileageKm) FuelField.odometerKm,
      if (volume == null || volume <= 0 || volume > maxVolume) FuelField.volume,
      if (totalCost == null || totalCost < 0) FuelField.totalCost,
      if (station.length > stationMaxLength) FuelField.station,
      if (notes.length > notesMaxLength) FuelField.notes,
    };
    if (invalid.isNotEmpty) return Left(InvalidFuelLogFailure(invalid));
    return Right(
      NewFuelLog(
        fueledAt: fueledAt,
        odometerKm: odometerKm,
        fuelType: draft.fuelType,
        volume: roundVolume(volume!),
        totalCost: totalCost!,
        isFullFill: draft.isFullFill,
        station: station.isEmpty ? null : station,
        paymentMethod: draft.paymentMethod,
        notes: notes.isEmpty ? null : notes,
      ),
    );
  }
}
