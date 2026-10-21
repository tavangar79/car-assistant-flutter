import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/service_interval.dart';
import '../repositories/interval_repository.dart';

/// The eight intervals of a vehicle, for the settings page.
class GetServiceIntervals {
  const GetServiceIntervals(this._repository);

  final IntervalRepository _repository;

  Future<Either<Failure, List<ServiceInterval>>> call(String vehicleId) =>
      _repository.getIntervals(vehicleId);
}
