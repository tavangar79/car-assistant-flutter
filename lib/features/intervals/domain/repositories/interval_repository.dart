import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/due_report.dart';
import '../entities/interval_setting.dart';
import '../entities/service_interval.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class IntervalRepository {
  /// All eight intervals of vehicle [vehicleId], catalog order.
  Future<Either<Failure, List<ServiceInterval>>> getIntervals(String vehicleId);

  /// Sets the listed intervals; returns all eight. `InvalidIntervalsFailure` on 400.
  Future<Either<Failure, List<ServiceInterval>>> setIntervals(
    String vehicleId,
    List<IntervalSetting> settings,
  );

  /// Removes every override; returns all eight at their defaults.
  Future<Either<Failure, List<ServiceInterval>>> resetIntervals(String vehicleId);

  /// The due computation of vehicle [vehicleId], worst first.
  Future<Either<Failure, DueReport>> getDue(String vehicleId);
}
