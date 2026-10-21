import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../intervals/presentation/providers/interval_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import 'odometer_providers.dart';

/// Saves a new odometer reading. The state carries loading and the last error (a
/// `MileageBelowCurrentFailure` or any other `Failure`).
class OdometerController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Records [mileageKm] for [vehicle], taken at [recordedAt] (now when `null`). Returns whether
  /// it was saved. On success the vehicle list, the vehicle details and its readings are refreshed.
  Future<bool> submit(Vehicle vehicle, {required int mileageKm, DateTime? recordedAt}) async {
    state = const AsyncLoading();
    final result = await ref
        .read(recordOdometerReadingProvider)
        .call(vehicle, mileageKm: mileageKm, recordedAt: recordedAt);
    if (!ref.mounted) return false;
    switch (result) {
      case Right():
        ref.invalidate(vehiclesProvider);
        ref.invalidate(vehicleProvider(vehicle.id));
        ref.invalidate(odometerReadingsProvider(vehicle.id));
        ref.invalidate(dueReportProvider(vehicle.id));
        state = const AsyncData(null);
        return true;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return false;
    }
  }

  /// Forgets the last error, e.g. once the user edits the value or picks another vehicle.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
