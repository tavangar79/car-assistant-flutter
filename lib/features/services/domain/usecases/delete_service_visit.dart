import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/service_repository.dart';

/// Deletes a visit and its invoice.
class DeleteServiceVisit {
  const DeleteServiceVisit(this._repository);

  final ServiceRepository _repository;

  Future<Either<Failure, Unit>> call(String vehicleId, String serviceId) =>
      _repository.deleteVisit(vehicleId, serviceId);
}
