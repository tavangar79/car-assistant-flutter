import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicles {
  const GetVehicles(this._repository);

  final VehicleRepository _repository;

  /// The user's vehicles in the server's order: default first, then newest first.
  Future<Either<Failure, List<Vehicle>>> call() => _repository.getVehicles();
}
