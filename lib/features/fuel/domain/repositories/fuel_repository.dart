import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/fuel_log.dart';
import '../entities/new_fuel_log.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class FuelRepository {
  /// The fill-ups of vehicle [vehicleId], newest first (at most 50).
  Future<Either<Failure, List<FuelLog>>> getLogs(String vehicleId);

  /// `InvalidFuelLogFailure` on 400, `FuelLogRejectedFailure` on 422.
  Future<Either<Failure, FuelLog>> createLog(String vehicleId, NewFuelLog log);
}
