import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/interval_setting.dart';
import '../../domain/entities/service_interval.dart';
import 'interval_providers.dart';

/// Saves or resets the intervals of a vehicle. The state carries loading and the last error
/// (an `InvalidIntervalsFailure` or any other `Failure`). After a write the intervals and the
/// due items are refreshed.
class IntervalsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> save(String vehicleId, List<IntervalSetting> settings) =>
      _run(vehicleId, () => ref.read(saveServiceIntervalsProvider).call(vehicleId, settings));

  Future<bool> reset(String vehicleId) =>
      _run(vehicleId, () => ref.read(resetServiceIntervalsProvider).call(vehicleId));

  Future<bool> _run(
    String vehicleId,
    Future<Either<Failure, List<ServiceInterval>>> Function() write,
  ) async {
    state = const AsyncLoading();
    final result = await write();
    if (!ref.mounted) return false;
    switch (result) {
      case Right():
        ref.invalidate(serviceIntervalsProvider(vehicleId));
        ref.invalidate(dueReportProvider(vehicleId));
        ref.invalidate(dashboardProvider);
        state = const AsyncData(null);
        return true;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return false;
    }
  }

  /// Forgets the last error, e.g. once the user edits a value.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
