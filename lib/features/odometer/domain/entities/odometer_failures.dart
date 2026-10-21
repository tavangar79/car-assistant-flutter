import '../../../../core/error/failure.dart';

/// The new reading is lower than the vehicle's current mileage (client check or HTTP 422).
class MileageBelowCurrentFailure extends Failure {
  const MileageBelowCurrentFailure(
    this.currentMileageKm, [
    super.message = 'Mileage is below the current reading',
  ]);

  /// The vehicle's current mileage, the lowest value allowed.
  final int currentMileageKm;

  @override
  List<Object?> get props => [message, currentMileageKm];
}

/// The new reading is above the largest mileage allowed (`VehicleRules.maxMileageKm`).
class MileageTooHighFailure extends Failure {
  const MileageTooHighFailure(this.maxMileageKm, [super.message = 'Mileage is too high']);

  final int maxMileageKm;

  @override
  List<Object?> get props => [message, maxMileageKm];
}
