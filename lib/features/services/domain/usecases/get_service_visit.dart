import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/service_visit.dart';
import '../repositories/service_repository.dart';

/// One visit, for the details page.
class GetServiceVisit {
  const GetServiceVisit(this._repository);

  final ServiceRepository _repository;

  Future<Either<Failure, ServiceVisit>> call(String vehicleId, String serviceId) =>
      _repository.getVisit(vehicleId, serviceId);
}
