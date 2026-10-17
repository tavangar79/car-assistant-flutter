import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/vehicle.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class VehicleRepository {
  Future<Either<Failure, List<Vehicle>>> getVehicles();
}
