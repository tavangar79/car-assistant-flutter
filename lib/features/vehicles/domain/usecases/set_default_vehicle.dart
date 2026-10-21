import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/new_vehicle.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

/// Makes [Vehicle] the user's default vehicle: saves it unchanged with `isDefault` set. The server
/// unsets the previous default. A vehicle that already is the default is returned as it is.
class SetDefaultVehicle {
  const SetDefaultVehicle(this._repository);

  final VehicleRepository _repository;

  Future<Either<Failure, Vehicle>> call(Vehicle vehicle) async {
    if (vehicle.isDefault) return Right(vehicle);
    return _repository.updateVehicle(
      vehicle.id,
      NewVehicle(
        nickname: vehicle.nickname,
        plate: vehicle.plate,
        vin: vehicle.vin,
        makeId: vehicle.make.id,
        modelId: vehicle.model.id,
        trimId: vehicle.trim?.id,
        yearJalali: vehicle.yearJalali,
        mileageKm: vehicle.mileageKm,
        color: vehicle.color,
        isDefault: true,
      ),
    );
  }
}
