import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicle {
  const GetVehicle(this._repository);

  final VehicleRepository _repository;

  /// The user's vehicle [vehicleId].
  Future<Either<Failure, Vehicle>> call(String vehicleId) => _repository.getVehicle(vehicleId);
}
