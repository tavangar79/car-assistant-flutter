import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicles {
  const GetVehicles(this._repository);

  final VehicleRepository _repository;

  /// The user's vehicles, newest model year first.
  Future<Either<Failure, List<Vehicle>>> call() async {
    final vehicles = await _repository.getVehicles();
    return vehicles.map((list) => [...list]..sort((a, b) => b.year.compareTo(a.year)));
  }
}
