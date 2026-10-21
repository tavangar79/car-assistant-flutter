import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/due_report.dart';
import '../repositories/interval_repository.dart';

/// The due computation of a vehicle, for the due page and the vehicle details.
class GetDueReport {
  const GetDueReport(this._repository);

  final IntervalRepository _repository;

  Future<Either<Failure, DueReport>> call(String vehicleId) => _repository.getDue(vehicleId);
}
