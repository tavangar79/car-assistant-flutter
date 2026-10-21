import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/fuel_log.dart';
import '../repositories/fuel_repository.dart';

/// The fill-ups of a vehicle, newest first.
class GetFuelLogs {
  const GetFuelLogs(this._repository);

  final FuelRepository _repository;

  Future<Either<Failure, List<FuelLog>>> call(String vehicleId) => _repository.getLogs(vehicleId);
}
