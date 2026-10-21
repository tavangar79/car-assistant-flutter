import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entities/odometer_failures.dart';
import '../../domain/entities/odometer_reading.dart';
import '../../domain/entities/odometer_update.dart';
import '../../domain/repositories/odometer_repository.dart';
import '../datasources/odometer_remote_data_source.dart';
import '../models/record_odometer_request_dto.dart';

class OdometerRepositoryImpl implements OdometerRepository {
  const OdometerRepositoryImpl(this._remote);

  final OdometerRemoteDataSource _remote;

  @override
  Future<Either<Failure, OdometerUpdate>> recordReading(
    String vehicleId, {
    required int mileageKm,
    DateTime? recordedAt,
  }) => apiCall(
    () async => (await _remote.recordReading(
      vehicleId,
      RecordOdometerRequestDto(mileageKm: mileageKm, recordedAt: recordedAt),
    )).toEntity(),
    onStatus: (status, error) => switch ((status, error?.details['currentMileageKm'])) {
      (422, final num current) => MileageBelowCurrentFailure(
        current.toInt(),
        error?.message ?? 'Mileage is below the current reading',
      ),
      _ => null,
    },
  );

  @override
  Future<Either<Failure, List<OdometerReading>>> getReadings(String vehicleId) => apiCall(
    () async => (await _remote.fetchReadings(vehicleId)).map((dto) => dto.toEntity()).toList(),
  );
}
