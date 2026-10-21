import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_failures.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_update.dart';
import 'package:car_assistant/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../odometer_fixtures.dart';

class MockOdometerRepository extends Mock implements OdometerRepository {}

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockOdometerRepository odometer;
  late MockVehicleRepository vehicles;
  late ProviderContainer container;

  setUp(() {
    odometer = MockOdometerRepository();
    vehicles = MockVehicleRepository();
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([tara]));
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => odometer.getReadings('v1')).thenAnswer((_) async => const Right([]));
    container = ProviderContainer.test(
      overrides: [
        odometerRepositoryProvider.overrideWithValue(odometer),
        vehicleRepositoryProvider.overrideWithValue(vehicles),
      ],
    );
    // Keep the auto-dispose providers alive for the whole test.
    container.listen(odometerControllerProvider, (_, _) {});
  });

  Future<bool> submit(int km) =>
      container.read(odometerControllerProvider.notifier).submit(tara, mileageKm: km);

  test('saves and refreshes the vehicle list, the vehicle and its readings', () async {
    container.listen(vehiclesProvider, (_, _) {});
    container.listen(vehicleProvider('v1'), (_, _) {});
    container.listen(odometerReadingsProvider('v1'), (_, _) {});
    await container.read(vehiclesProvider.future);
    await container.read(vehicleProvider('v1').future);
    await container.read(odometerReadingsProvider('v1').future);
    when(() => odometer.recordReading('v1', mileageKm: 34850))
        .thenAnswer((_) async => Right(OdometerUpdate(reading: reading, vehicle: tara)));

    expect(await submit(34850), isTrue);
    expect(container.read(odometerControllerProvider).hasError, isFalse);

    await container.read(vehiclesProvider.future);
    await container.read(vehicleProvider('v1').future);
    await container.read(odometerReadingsProvider('v1').future);
    verify(() => vehicles.getVehicles()).called(2);
    verify(() => vehicles.getVehicle('v1')).called(2);
    verify(() => odometer.getReadings('v1')).called(2);
  });

  test('a value below the current mileage ends in MileageBelowCurrentFailure', () async {
    expect(await submit(100), isFalse);

    expect(
      container.read(odometerControllerProvider).error,
      const MileageBelowCurrentFailure(34500),
    );
    verifyNever(() => odometer.recordReading(any(), mileageKm: any(named: 'mileageKm')));
  });

  test('a server failure ends in error, and clearError forgets it', () async {
    when(() => odometer.recordReading('v1', mileageKm: 35000))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    expect(await submit(35000), isFalse);
    expect(container.read(odometerControllerProvider).error, const NetworkFailure());

    container.read(odometerControllerProvider.notifier).clearError();
    expect(container.read(odometerControllerProvider).hasError, isFalse);
  });
}
