import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/add_vehicle_result.dart';
import '../entities/new_vehicle.dart';
import '../entities/vehicle.dart';
import '../entities/vehicle_draft.dart';
import '../entities/vehicle_failures.dart';
import '../entities/vehicle_photo.dart';
import '../entities/vehicle_rules.dart';
import '../repositories/vehicle_repository.dart';

/// Adds a vehicle to the garage, then uploads its optional photo.
///
/// The draft and the photo are checked before anything is sent. When the vehicle is saved but
/// the photo upload fails, the result is still a success, with `photoFailure` set.
class AddVehicle {
  const AddVehicle(this._repository, {required this.currentJalaliYear});

  final VehicleRepository _repository;

  /// Today's Jalali year; the newest model year allowed is the next one.
  final int Function() currentJalaliYear;

  Future<Either<Failure, AddVehicleResult>> call(VehicleDraft draft, {VehiclePhoto? photo}) async {
    if (photo != null && photo.bytes.isEmpty) return const Left(InvalidVehiclePhotoFailure());
    if (photo != null && photo.bytes.length > VehiclePhoto.maxBytes) {
      return const Left(VehiclePhotoTooLargeFailure());
    }
    final NewVehicle vehicle;
    switch (VehicleRules.validate(draft, currentJalaliYear: currentJalaliYear())) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final checked):
        vehicle = checked;
    }

    final Vehicle saved;
    switch (await _repository.createVehicle(vehicle)) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final created):
        saved = created;
    }
    if (photo == null) return Right(AddVehicleResult(saved));

    // The vehicle is saved either way; a failed upload only loses the photo.
    final uploaded = await _repository.uploadPhoto(saved.id, photo);
    return Right(
      uploaded.match(
        (failure) => AddVehicleResult(saved, photoFailure: failure),
        AddVehicleResult.new,
      ),
    );
  }
}
