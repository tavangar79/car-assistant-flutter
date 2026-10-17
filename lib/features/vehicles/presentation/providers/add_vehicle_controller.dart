import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/add_vehicle_result.dart';
import '../../domain/entities/vehicle_draft.dart';
import '../../domain/entities/vehicle_photo.dart';
import 'vehicle_providers.dart';

/// Saves a new vehicle for the add page. The state carries loading and the last error
/// (an `InvalidVehicleFailure`, `PlateTakenFailure`, photo failure or any other `Failure`).
class AddVehicleController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns the result once the vehicle is saved (its `photoFailure` says whether the photo was
  /// not), or `null` when nothing was saved. On success the garage list is refreshed.
  Future<AddVehicleResult?> save(VehicleDraft draft, {VehiclePhoto? photo}) async {
    state = const AsyncLoading();
    final result = await ref.read(addVehicleProvider).call(draft, photo: photo);
    if (!ref.mounted) return null;
    switch (result) {
      case Right(value: final saved):
        ref.invalidate(vehiclesProvider);
        state = const AsyncData(null);
        return saved;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return null;
    }
  }
}
