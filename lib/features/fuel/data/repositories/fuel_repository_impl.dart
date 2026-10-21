import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/network/api_error_dto.dart';
import '../../domain/entities/fuel_failures.dart';
import '../../domain/entities/fuel_field.dart';
import '../../domain/entities/fuel_log.dart';
import '../../domain/entities/new_fuel_log.dart';
import '../../domain/repositories/fuel_repository.dart';
import '../datasources/fuel_remote_data_source.dart';
import '../models/create_fuel_log_request_dto.dart';

class FuelRepositoryImpl implements FuelRepository {
  const FuelRepositoryImpl(this._remote);

  final FuelRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<FuelLog>>> getLogs(String vehicleId) => apiCall(
    () async => (await _remote.fetchLogs(vehicleId)).map((dto) => dto.toEntity()).toList(),
  );

  @override
  Future<Either<Failure, FuelLog>> createLog(String vehicleId, NewFuelLog log) => apiCall(
    () async => (await _remote.createLog(vehicleId, CreateFuelLogRequestDto(log))).toEntity(),
    onStatus: _logFailure,
  );

  static Failure? _logFailure(int status, ApiErrorDto? error) => switch (status) {
    400 => InvalidFuelLogFailure(
      fieldsOf(error?.details.keys ?? const []),
      error?.message ?? 'Invalid fuel log',
    ),
    422 => FuelLogRejectedFailure(error?.message ?? 'Fuel log rejected'),
    _ => null,
  };

  /// Maps the field names of a 400 `details` body to form fields. Unknown names are ignored.
  static Set<FuelField> fieldsOf(Iterable<String> paths) => {
    for (final path in paths) ?_fieldOf(path.split('.').first),
  };

  static FuelField? _fieldOf(String key) => switch (key) {
    'fueledAt' => FuelField.fueledAt,
    'odometerKm' => FuelField.odometerKm,
    'fuelType' => FuelField.fuelType,
    'volume' => FuelField.volume,
    'totalCost' => FuelField.totalCost,
    'isFullFill' => FuelField.isFullFill,
    'station' => FuelField.station,
    'paymentMethod' => FuelField.paymentMethod,
    'notes' => FuelField.notes,
    _ => null,
  };
}
