import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/entities/vehicle_rules.dart';
import '../entities/odometer_failures.dart';
import '../entities/odometer_update.dart';
import '../repositories/odometer_repository.dart';

/// Records a new odometer reading for [Vehicle]. The odometer only goes up: a value below the
/// vehicle's current mileage, or above `VehicleRules.maxMileageKm`, is rejected before anything
/// is sent.
class RecordOdometerReading {
  const RecordOdometerReading(this._repository);

  final OdometerRepository _repository;

  Future<Either<Failure, OdometerUpdate>> call(
    Vehicle vehicle, {
    required int mileageKm,
    DateTime? recordedAt,
  }) async {
    if (mileageKm < vehicle.mileageKm) {
      return Left(MileageBelowCurrentFailure(vehicle.mileageKm));
    }
    if (mileageKm > VehicleRules.maxMileageKm) {
      return const Left(MileageTooHighFailure(VehicleRules.maxMileageKm));
    }
    return _repository.recordReading(vehicle.id, mileageKm: mileageKm, recordedAt: recordedAt);
  }
}
