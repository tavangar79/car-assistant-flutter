import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/service_interval.dart';
import '../repositories/interval_repository.dart';

/// "بازنشانی همه": puts every interval of a vehicle back to its factory default.
class ResetServiceIntervals {
  const ResetServiceIntervals(this._repository);

  final IntervalRepository _repository;

  Future<Either<Failure, List<ServiceInterval>>> call(String vehicleId) =>
      _repository.resetIntervals(vehicleId);
}
