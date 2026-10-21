import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/interval_remote_data_source.dart';
import '../../data/repositories/interval_repository_impl.dart';
import '../../domain/entities/due_report.dart';
import '../../domain/entities/service_interval.dart';
import '../../domain/repositories/interval_repository.dart';
import '../../domain/usecases/get_due_report.dart';
import '../../domain/usecases/get_service_intervals.dart';
import '../../domain/usecases/reset_service_intervals.dart';
import '../../domain/usecases/save_service_intervals.dart';
import 'intervals_controller.dart';

// Dependency wiring for the intervals feature. Override [intervalRepositoryProvider] in tests.

final intervalRepositoryProvider = Provider<IntervalRepository>((ref) {
  return IntervalRepositoryImpl(IntervalRemoteDataSource(ref.watch(dioProvider)));
});

final getServiceIntervalsProvider = Provider<GetServiceIntervals>((ref) {
  return GetServiceIntervals(ref.watch(intervalRepositoryProvider));
});

final saveServiceIntervalsProvider = Provider<SaveServiceIntervals>((ref) {
  return SaveServiceIntervals(ref.watch(intervalRepositoryProvider));
});

final resetServiceIntervalsProvider = Provider<ResetServiceIntervals>((ref) {
  return ResetServiceIntervals(ref.watch(intervalRepositoryProvider));
});

final getDueReportProvider = Provider<GetDueReport>((ref) {
  return GetDueReport(ref.watch(intervalRepositoryProvider));
});

/// The eight intervals of a vehicle, catalog order.
final serviceIntervalsProvider = FutureProvider.autoDispose.family<List<ServiceInterval>, String>((
  ref,
  vehicleId,
) async {
  final intervals = await ref.watch(getServiceIntervalsProvider).call(vehicleId);
  return intervals.getOrElse((failure) => throw failure);
});

/// The due computation of a vehicle. Invalidate it after an odometer update, a visit or an
/// interval change.
final dueReportProvider = FutureProvider.autoDispose.family<DueReport, String>((
  ref,
  vehicleId,
) async {
  final report = await ref.watch(getDueReportProvider).call(vehicleId);
  return report.getOrElse((failure) => throw failure);
});

/// State of the intervals page writes: loading while saving or resetting, and the last error.
final intervalsControllerProvider = AsyncNotifierProvider.autoDispose<IntervalsController, void>(
  IntervalsController.new,
);
