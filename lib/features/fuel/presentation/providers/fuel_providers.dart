import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../data/datasources/fuel_remote_data_source.dart';
import '../../data/repositories/fuel_repository_impl.dart';
import '../../domain/entities/fuel_log.dart';
import '../../domain/repositories/fuel_repository.dart';
import '../../domain/usecases/create_fuel_log.dart';
import '../../domain/usecases/get_fuel_logs.dart';
import 'new_fuel_controller.dart';

// Dependency wiring for the fuel feature. Override [fuelRepositoryProvider] in tests.

final fuelRepositoryProvider = Provider<FuelRepository>((ref) {
  return FuelRepositoryImpl(FuelRemoteDataSource(ref.watch(dioProvider)));
});

final getFuelLogsProvider = Provider<GetFuelLogs>((ref) {
  return GetFuelLogs(ref.watch(fuelRepositoryProvider));
});

final createFuelLogProvider = Provider<CreateFuelLog>((ref) {
  return CreateFuelLog(ref.watch(fuelRepositoryProvider), now: ref.watch(clockProvider));
});

/// The fill-ups of a vehicle, newest first.
final fuelLogsProvider = FutureProvider.autoDispose.family<List<FuelLog>, String>((
  ref,
  vehicleId,
) async {
  final logs = await ref.watch(getFuelLogsProvider).call(vehicleId);
  return logs.getOrElse((failure) => throw failure);
});

/// State of the fuel form's submit: loading while saving, and the last error.
final newFuelControllerProvider = AsyncNotifierProvider.autoDispose<NewFuelController, void>(
  NewFuelController.new,
);
