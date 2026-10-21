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

/// Saves the edited vehicle [vehicleId], then updates its photo: uploads the new `photo`, or
/// deletes the saved one when `removePhoto` is set and no new photo was picked (the upload
/// replaces it anyway).
///
/// Same rules as `AddVehicle`: the draft and the photo are checked before anything is sent, and
/// when the vehicle is saved but the photo upload or delete fails, the result is a success with
/// `photoFailure` set.
class UpdateVehicle {
  const UpdateVehicle(this._repository, {required this.currentJalaliYear});

  final VehicleRepository _repository;

  /// Today's Jalali year; the newest model year allowed is the next one.
  final int Function() currentJalaliYear;

  Future<Either<Failure, AddVehicleResult>> call(
    String vehicleId,
    VehicleDraft draft, {
    VehiclePhoto? photo,
    bool removePhoto = false,
  }) async {
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
    switch (await _repository.updateVehicle(vehicleId, vehicle)) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final updated):
        saved = updated;
    }
    final Either<Failure, Vehicle> photoResult;
    if (photo != null) {
      photoResult = await _repository.uploadPhoto(saved.id, photo);
    } else if (removePhoto) {
      photoResult = await _repository.deletePhoto(saved.id);
    } else {
      return Right(AddVehicleResult(saved));
    }

    // The changes are saved either way; a failed photo call only loses the photo change.
    return Right(
      photoResult.match(
        (failure) => AddVehicleResult(saved, photoFailure: failure),
        AddVehicleResult.new,
      ),
    );
  }
}
