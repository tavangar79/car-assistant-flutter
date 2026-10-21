import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../entities/fuel_log.dart';
import '../entities/fuel_log_draft.dart';
import '../entities/fuel_rules.dart';
import '../repositories/fuel_repository.dart';

/// Records a fill-up for a [Vehicle]. The draft is checked before anything is sent.
class CreateFuelLog {
  const CreateFuelLog(this._repository, {required this.now});

  final FuelRepository _repository;

  /// The current time; a fill-up after it is rejected.
  final DateTime Function() now;

  Future<Either<Failure, FuelLog>> call(Vehicle vehicle, FuelLogDraft draft) async {
    return switch (FuelRules.validate(draft, currentKm: vehicle.mileageKm, now: now())) {
      Left(value: final failure) => Left(failure),
      Right(value: final log) => _repository.createLog(vehicle.id, log),
    };
  }
}
