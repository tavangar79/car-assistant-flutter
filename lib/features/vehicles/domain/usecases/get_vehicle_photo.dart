import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/vehicle_repository.dart';

/// Loads the photo bytes for a `Vehicle.photoUrl`.
class GetVehiclePhoto {
  const GetVehiclePhoto(this._repository);

  final VehicleRepository _repository;

  Future<Either<Failure, Uint8List>> call(String photoUrl) => _repository.fetchPhoto(photoUrl);
}
