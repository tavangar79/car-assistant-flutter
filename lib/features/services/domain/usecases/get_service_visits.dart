import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/service_visit.dart';
import '../repositories/service_repository.dart';

/// The visits of a vehicle, newest first.
class GetServiceVisits {
  const GetServiceVisits(this._repository);

  final ServiceRepository _repository;

  Future<Either<Failure, List<ServiceVisit>>> call(String vehicleId) =>
      _repository.getVisits(vehicleId);
}
