import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/network/api_error_dto.dart';
import '../../domain/entities/catalog_make.dart';
import '../../domain/entities/new_vehicle.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_failures.dart';
import '../../domain/entities/vehicle_field.dart';
import '../../domain/entities/vehicle_photo.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_data_source.dart';
import '../models/create_vehicle_request_dto.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  const VehicleRepositoryImpl(this._remote);

  final VehicleRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<Vehicle>>> getVehicles() =>
      apiCall(() async => (await _remote.fetchVehicles()).map((dto) => dto.toEntity()).toList());

  @override
  Future<Either<Failure, Vehicle>> getVehicle(String vehicleId) =>
      apiCall(() async => (await _remote.fetchVehicle(vehicleId)).toEntity());

  @override
  Future<Either<Failure, List<CatalogMake>>> getCatalog() =>
      apiCall(() async => (await _remote.fetchCatalog()).toEntity());

  @override
  Future<Either<Failure, Vehicle>> createVehicle(NewVehicle vehicle) => apiCall(
    () async => (await _remote.createVehicle(CreateVehicleRequestDto(vehicle))).toEntity(),
    onStatus: _vehicleFailure,
  );

  @override
  Future<Either<Failure, Vehicle>> updateVehicle(String vehicleId, NewVehicle vehicle) => apiCall(
    () async =>
        (await _remote.updateVehicle(vehicleId, CreateVehicleRequestDto(vehicle))).toEntity(),
    onStatus: (status, error) => switch (status) {
      422 => VehicleRejectedFailure(error?.message ?? 'Vehicle update rejected'),
      _ => _vehicleFailure(status, error),
    },
  );

  /// The failure of a rejected create or update.
  static Failure? _vehicleFailure(int status, ApiErrorDto? error) => switch (status) {
    400 => InvalidVehicleFailure(
      fieldsOf(error?.details.keys ?? const []),
      error?.message ?? 'Invalid vehicle',
    ),
    409 => PlateTakenFailure(error?.message ?? 'Plate already registered'),
    _ => null,
  };

  @override
  Future<Either<Failure, Vehicle>> uploadPhoto(String vehicleId, VehiclePhoto photo) => apiCall(
    () async => (await _remote.uploadPhoto(vehicleId, photo)).toEntity(),
    onStatus: (status, error) => switch (status) {
      400 => InvalidVehiclePhotoFailure(error?.message ?? 'Invalid image'),
      413 => VehiclePhotoTooLargeFailure(error?.message ?? 'Image too large'),
      _ => null,
    },
  );

  @override
  Future<Either<Failure, Vehicle>> deletePhoto(String vehicleId) =>
      apiCall(() async => (await _remote.deletePhoto(vehicleId)).toEntity());

  @override
  Future<Either<Failure, Uint8List>> fetchPhoto(String photoUrl) =>
      apiCall(() => _remote.fetchPhoto(photoUrl));

  /// Maps the dotted field paths of a 400 `details` body (`plate.letter`, `makeId`, …) to form fields.
  /// Unknown paths are ignored.
  static Set<VehicleField> fieldsOf(Iterable<String> paths) => {
    for (final path in paths) ?_fieldOf(path.split('.').first),
  };

  static VehicleField? _fieldOf(String key) => switch (key) {
    'nickname' => VehicleField.nickname,
    'plate' => VehicleField.plate,
    'vin' => VehicleField.vin,
    'makeId' => VehicleField.make,
    'modelId' => VehicleField.model,
    'trimId' => VehicleField.trim,
    'yearJalali' => VehicleField.year,
    'mileageKm' => VehicleField.mileage,
    'color' => VehicleField.color,
    'photo' => VehicleField.photo,
    _ => null,
  };
}
