import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/vehicle_document.dart';
import '../repositories/document_repository.dart';

/// The documents of a vehicle, expiring soonest first.
class GetDocuments {
  const GetDocuments(this._repository);

  final DocumentRepository _repository;

  Future<Either<Failure, List<VehicleDocument>>> call(String vehicleId) =>
      _repository.getDocuments(vehicleId);
}
