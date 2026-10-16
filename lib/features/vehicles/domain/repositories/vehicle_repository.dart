import '../entities/vehicle.dart';

/// Contract owned by the domain layer; implemented in the data layer.
/// Implementations throw [Failure] on error.
abstract interface class VehicleRepository {
  Future<List<Vehicle>> getVehicles();
}
