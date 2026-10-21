import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/odometer_reading.dart';
import '../repositories/odometer_repository.dart';

class GetOdometerReadings {
  const GetOdometerReadings(this._repository);

  final OdometerRepository _repository;

  /// The readings of vehicle [vehicleId] in the server's order: newest first.
  Future<Either<Failure, List<OdometerReading>>> call(String vehicleId) =>
      _repository.getReadings(vehicleId);
}
