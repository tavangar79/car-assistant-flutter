import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/odometer_reading.dart';
import '../entities/odometer_update.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class OdometerRepository {
  /// Saves a reading of [mileageKm] for vehicle [vehicleId], taken at [recordedAt] (the server's
  /// "now" when `null`). `MileageBelowCurrentFailure` on 422.
  Future<Either<Failure, OdometerUpdate>> recordReading(
    String vehicleId, {
    required int mileageKm,
    DateTime? recordedAt,
  });

  /// The readings of vehicle [vehicleId], newest first (at most 50).
  Future<Either<Failure, List<OdometerReading>>> getReadings(String vehicleId);
}
