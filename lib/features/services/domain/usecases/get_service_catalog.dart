import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/service_category.dart';
import '../repositories/service_repository.dart';

/// The service catalog for the wizard's item grid.
class GetServiceCatalog {
  const GetServiceCatalog(this._repository);

  final ServiceRepository _repository;

  Future<Either<Failure, List<ServiceCategory>>> call() => _repository.getCatalog();
}
