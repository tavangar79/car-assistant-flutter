import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/vehicle_remote_data_source.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../domain/entities/catalog_make.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/usecases/add_vehicle.dart';
import '../../domain/usecases/get_vehicle_catalog.dart';
import '../../domain/usecases/get_vehicle_photo.dart';
import '../../domain/usecases/get_vehicles.dart';
import 'add_vehicle_controller.dart';
import 'vehicle_photo_picker.dart';

// Dependency wiring for the vehicles feature. Override
// [vehicleRepositoryProvider] in tests to avoid real HTTP calls.

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(VehicleRemoteDataSource(ref.watch(dioProvider)));
});

final getVehiclesProvider = Provider<GetVehicles>((ref) {
  return GetVehicles(ref.watch(vehicleRepositoryProvider));
});

final getVehicleCatalogProvider = Provider<GetVehicleCatalog>((ref) {
  return GetVehicleCatalog(ref.watch(vehicleRepositoryProvider));
});

final getVehiclePhotoProvider = Provider<GetVehiclePhoto>((ref) {
  return GetVehiclePhoto(ref.watch(vehicleRepositoryProvider));
});

/// Today's Jalali year. Override in tests for a fixed year range.
final currentJalaliYearProvider = Provider<int>((ref) => Jalali.now().year);

final addVehicleProvider = Provider<AddVehicle>((ref) {
  final year = ref.watch(currentJalaliYearProvider);
  return AddVehicle(ref.watch(vehicleRepositoryProvider), currentJalaliYear: () => year);
});

final vehiclePhotoPickerProvider = Provider<VehiclePhotoPicker>(
  (ref) => const VehiclePhotoPicker(),
);

/// User-scoped: auto-disposed once the vehicles page is gone (e.g. after logout), so the next user
/// never sees the previous user's list. A failure becomes the provider's error state.
final vehiclesProvider = FutureProvider.autoDispose<List<Vehicle>>((ref) async {
  final vehicles = await ref.watch(getVehiclesProvider).call();
  return vehicles.getOrElse((failure) => throw failure);
});

/// The makes, models and trims for the vehicle form.
final vehicleCatalogProvider = FutureProvider.autoDispose<List<CatalogMake>>((ref) async {
  final catalog = await ref.watch(getVehicleCatalogProvider).call();
  return catalog.getOrElse((failure) => throw failure);
});

/// The photo bytes for a `Vehicle.photoUrl` (each upload gets a new URL, so no stale cache).
final vehiclePhotoBytesProvider = FutureProvider.autoDispose.family<Uint8List, String>((
  ref,
  url,
) async {
  return (await ref.watch(getVehiclePhotoProvider).call(url)).getOrElse((failure) => throw failure);
});

/// State of the add-vehicle page: loading while saving, and the last error.
final addVehicleControllerProvider = AsyncNotifierProvider.autoDispose<AddVehicleController, void>(
  AddVehicleController.new,
);
