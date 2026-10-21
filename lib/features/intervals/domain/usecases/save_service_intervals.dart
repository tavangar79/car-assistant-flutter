import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/interval_failures.dart';
import '../entities/interval_rules.dart';
import '../entities/interval_setting.dart';
import '../entities/service_interval.dart';
import '../repositories/interval_repository.dart';

/// Saves the intervals of a vehicle. Values outside the limits are rejected before anything is
/// sent, naming the intervals at fault.
class SaveServiceIntervals {
  const SaveServiceIntervals(this._repository);

  final IntervalRepository _repository;

  Future<Either<Failure, List<ServiceInterval>>> call(
    String vehicleId,
    List<IntervalSetting> settings,
  ) {
    final invalid = {
      for (final setting in settings)
        if (!IntervalRules.isValid(setting)) setting.id,
    };
    if (settings.isEmpty || invalid.isNotEmpty) {
      return Future.value(Left(InvalidIntervalsFailure(invalid)));
    }
    return _repository.setIntervals(vehicleId, settings);
  }
}
