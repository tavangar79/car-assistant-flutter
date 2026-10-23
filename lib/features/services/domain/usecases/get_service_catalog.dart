import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/service_category.dart';
import '../repositories/service_repository.dart';

/// The service catalog: resolved for [vehicleId] when given (wizard, visit details), else the
/// title lookup used wherever several vehicles are shown.
class GetServiceCatalog {
  const GetServiceCatalog(this._repository);

  final ServiceRepository _repository;

  Future<Either<Failure, List<ServiceCategory>>> call({String? vehicleId}) =>
      _repository.getCatalog(vehicleId: vehicleId);
}
