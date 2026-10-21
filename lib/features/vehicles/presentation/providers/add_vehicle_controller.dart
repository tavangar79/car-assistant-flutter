import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/add_vehicle_result.dart';
import '../../domain/entities/vehicle_draft.dart';
import '../../domain/entities/vehicle_photo.dart';
import 'vehicle_providers.dart';

/// Saves the vehicle of the add / edit page. The state carries loading and the last error
/// (an `InvalidVehicleFailure`, `PlateTakenFailure`, photo failure or any other `Failure`).
class AddVehicleController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Adds a new vehicle, or updates vehicle [vehicleId] when it is given ([removePhoto] then
  /// deletes its saved photo unless a new [photo] replaces it).
  /// Returns the result once the vehicle is saved (its `photoFailure` says whether the photo was
  /// not), or `null` when nothing was saved. On success the garage list and the vehicle details are
  /// refreshed.
  Future<AddVehicleResult?> save(
    VehicleDraft draft, {
    VehiclePhoto? photo,
    String? vehicleId,
    bool removePhoto = false,
  }) async {
    state = const AsyncLoading();
    final result = vehicleId == null
        ? await ref.read(addVehicleProvider).call(draft, photo: photo)
        : await ref
              .read(updateVehicleProvider)
              .call(vehicleId, draft, photo: photo, removePhoto: removePhoto);
    if (!ref.mounted) return null;
    switch (result) {
      case Right(value: final saved):
        ref.invalidate(vehiclesProvider);
        ref.invalidate(vehicleProvider);
        state = const AsyncData(null);
        return saved;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return null;
    }
  }
}
