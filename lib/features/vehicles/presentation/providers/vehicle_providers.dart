import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/http_client_provider.dart';
import '../../data/datasources/vehicle_remote_data_source.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/usecases/get_vehicles.dart';

// Dependency wiring for the vehicles feature. Override
// [vehicleRepositoryProvider] in tests to avoid real HTTP calls.

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final remote = VehicleRemoteDataSource(
    client: ref.watch(httpClientProvider),
    baseUrl: AppConfig.apiBaseUrl,
  );
  return VehicleRepositoryImpl(remote);
});

final getVehiclesProvider = Provider<GetVehicles>((ref) {
  return GetVehicles(ref.watch(vehicleRepositoryProvider));
});

final vehiclesProvider = FutureProvider<List<Vehicle>>((ref) {
  return ref.watch(getVehiclesProvider).call();
});
