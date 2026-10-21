import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/catalog_make.dart';
import '../entities/new_vehicle.dart';
import '../entities/vehicle.dart';
import '../entities/vehicle_photo.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class VehicleRepository {
  /// The user's vehicles: default first, then newest first.
  Future<Either<Failure, List<Vehicle>>> getVehicles();

  /// The user's vehicle [vehicleId]; a generic `Failure` (HTTP 404) when it is not theirs.
  Future<Either<Failure, Vehicle>> getVehicle(String vehicleId);

  /// The makes, models and trims a user can pick.
  Future<Either<Failure, List<CatalogMake>>> getCatalog();

  /// Saves [vehicle] in the user's garage.
  /// `InvalidVehicleFailure` on 400, `PlateTakenFailure` on 409.
  Future<Either<Failure, Vehicle>> createVehicle(NewVehicle vehicle);

  /// Replaces every field of vehicle [vehicleId] with [vehicle] and returns the updated vehicle.
  /// `InvalidVehicleFailure` on 400, `PlateTakenFailure` on 409, `VehicleRejectedFailure` on 422
  /// (e.g. unsetting the only default vehicle).
  Future<Either<Failure, Vehicle>> updateVehicle(String vehicleId, NewVehicle vehicle);

  /// Sets the photo of vehicle [vehicleId] and returns the updated vehicle.
  /// `InvalidVehiclePhotoFailure` on 400, `VehiclePhotoTooLargeFailure` on 413.
  Future<Either<Failure, Vehicle>> uploadPhoto(String vehicleId, VehiclePhoto photo);

  /// Removes the photo of vehicle [vehicleId] and returns the vehicle without it.
  Future<Either<Failure, Vehicle>> deletePhoto(String vehicleId);

  /// The image bytes at [photoUrl] (a `Vehicle.photoUrl`).
  Future<Either<Failure, Uint8List>> fetchPhoto(String photoUrl);
}
