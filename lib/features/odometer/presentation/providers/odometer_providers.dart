import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/odometer_remote_data_source.dart';
import '../../data/repositories/odometer_repository_impl.dart';
import '../../domain/entities/odometer_reading.dart';
import '../../domain/repositories/odometer_repository.dart';
import '../../domain/usecases/get_odometer_readings.dart';
import '../../domain/usecases/record_odometer_reading.dart';
import 'odometer_controller.dart';

// Dependency wiring for the odometer feature. Override [odometerRepositoryProvider] in tests.

final odometerRepositoryProvider = Provider<OdometerRepository>((ref) {
  return OdometerRepositoryImpl(OdometerRemoteDataSource(ref.watch(dioProvider)));
});

final recordOdometerReadingProvider = Provider<RecordOdometerReading>((ref) {
  return RecordOdometerReading(ref.watch(odometerRepositoryProvider));
});

final getOdometerReadingsProvider = Provider<GetOdometerReadings>((ref) {
  return GetOdometerReadings(ref.watch(odometerRepositoryProvider));
});

/// The current time. Override in tests for a fixed "now".
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// The readings of a vehicle, newest first.
final odometerReadingsProvider = FutureProvider.autoDispose.family<List<OdometerReading>, String>((
  ref,
  vehicleId,
) async {
  final readings = await ref.watch(getOdometerReadingsProvider).call(vehicleId);
  return readings.getOrElse((failure) => throw failure);
});

/// State of the odometer sheet: loading while saving, and the last error.
final odometerControllerProvider = AsyncNotifierProvider.autoDispose<OdometerController, void>(
  OdometerController.new,
);
