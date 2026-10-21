import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../history/presentation/providers/history_providers.dart';
import '../../../intervals/presentation/providers/interval_providers.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/fuel_log.dart';
import '../../domain/entities/fuel_log_draft.dart';
import 'fuel_providers.dart';

/// Saves the fill-up of the fuel form. The state carries loading and the last error (an
/// `InvalidFuelLogFailure`, `FuelLogRejectedFailure` or any other `Failure`).
class NewFuelController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Records [draft] for [vehicle]. Returns the saved log, or `null` when nothing was saved.
  /// On success the vehicle (its mileage may rise), its readings, its due report and its
  /// fill-ups are refreshed.
  Future<FuelLog?> submit(Vehicle vehicle, FuelLogDraft draft) async {
    state = const AsyncLoading();
    final result = await ref.read(createFuelLogProvider).call(vehicle, draft);
    if (!ref.mounted) return null;
    switch (result) {
      case Right(value: final saved):
        ref.invalidate(fuelLogsProvider(vehicle.id));
        ref.invalidate(vehicleProvider(vehicle.id));
        ref.invalidate(vehiclesProvider);
        ref.invalidate(odometerReadingsProvider(vehicle.id));
        ref.invalidate(dueReportProvider(vehicle.id));
        ref.invalidate(dashboardProvider);
        ref.invalidate(historyControllerProvider);
        state = const AsyncData(null);
        return saved;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return null;
    }
  }

  /// Forgets the last error, e.g. once the user edits a field.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
