import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/catalog_make.dart';
import '../repositories/vehicle_repository.dart';

/// Loads the makes, models and trims for the vehicle form.
class GetVehicleCatalog {
  const GetVehicleCatalog(this._repository);

  final VehicleRepository _repository;

  Future<Either<Failure, List<CatalogMake>>> call() => _repository.getCatalog();
}
