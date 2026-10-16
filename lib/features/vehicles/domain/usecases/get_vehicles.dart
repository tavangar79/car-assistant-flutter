import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicles {
  const GetVehicles(this._repository);

  final VehicleRepository _repository;

  Future<List<Vehicle>> call() async {
    final vehicles = await _repository.getVehicles();
    return [...vehicles]..sort((a, b) => b.year.compareTo(a.year));
  }
}
