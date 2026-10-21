import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_failures.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_log_draft.dart';
import 'package:car_assistant/features/fuel/domain/entities/new_fuel_log.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_type.dart';
import 'package:car_assistant/features/fuel/domain/repositories/fuel_repository.dart';
import 'package:car_assistant/features/fuel/presentation/providers/fuel_providers.dart';
import 'package:car_assistant/features/history/domain/entities/history_query.dart';
import 'package:car_assistant/features/history/domain/entities/history_result.dart';
import 'package:car_assistant/features/history/domain/repositories/history_repository.dart';
import 'package:car_assistant/features/history/presentation/providers/history_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../fuel_fixtures.dart';

class MockFuelRepository extends Mock implements FuelRepository {}

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late MockFuelRepository fuel;
  late MockVehicleRepository vehicles;
  late MockHistoryRepository history;
  late ProviderContainer container;
  const draft = FuelLogDraft(odometerKm: 34850, volume: 48.5, totalCost: 145500);

  setUpAll(() {
    registerFallbackValue(const HistoryQuery());
    registerFallbackValue(
      NewFuelLog(
        fueledAt: DateTime(2026),
        odometerKm: 0,
        fuelType: FuelType.regular,
        volume: 1,
        totalCost: 0,
        isFullFill: true,
      ),
    );
  });

  setUp(() {
    fuel = MockFuelRepository();
    vehicles = MockVehicleRepository();
    history = MockHistoryRepository();
    when(() => history.getHistory(any()))
        .thenAnswer((_) async => const Right(HistoryResult(entries: [])));
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => fuel.getLogs('v1')).thenAnswer((_) async => const Right([]));
    container = ProviderContainer.test(
      overrides: [
        fuelRepositoryProvider.overrideWithValue(fuel),
        vehicleRepositoryProvider.overrideWithValue(vehicles),
        historyRepositoryProvider.overrideWithValue(history),
      ],
    );
    // Keep the auto-dispose providers alive for the whole test.
    container.listen(newFuelControllerProvider, (_, _) {});
  });

  test('saves and refreshes the vehicle and its fill-ups', () async {
    container.listen(vehicleProvider('v1'), (_, _) {});
    container.listen(fuelLogsProvider('v1'), (_, _) {});
    await container.read(vehicleProvider('v1').future);
    await container.read(fuelLogsProvider('v1').future);
    when(() => fuel.createLog('v1', any())).thenAnswer((_) async => Right(contractFuelLog()));

    final saved = await container.read(newFuelControllerProvider.notifier).submit(tara, draft);

    expect(saved, contractFuelLog());
    expect(container.read(newFuelControllerProvider).hasError, isFalse);
    await container.read(vehicleProvider('v1').future);
    await container.read(fuelLogsProvider('v1').future);
    verify(() => vehicles.getVehicle('v1')).called(2);
    verify(() => fuel.getLogs('v1')).called(2);
  });

  test('saves and refreshes the loaded history', () async {
    container.listen(historyControllerProvider, (_, _) {});
    await container.read(historyControllerProvider.future);
    when(() => fuel.createLog('v1', any())).thenAnswer((_) async => Right(contractFuelLog()));

    await container.read(newFuelControllerProvider.notifier).submit(tara, draft);

    await container.read(historyControllerProvider.future);
    verify(() => history.getHistory(any())).called(2);
  });

  test('an invalid draft ends in InvalidFuelLogFailure without a request', () async {
    final saved = await container
        .read(newFuelControllerProvider.notifier)
        .submit(tara, const FuelLogDraft());

    expect(saved, isNull);
    expect(container.read(newFuelControllerProvider).error, isA<InvalidFuelLogFailure>());
    verifyNever(() => fuel.createLog(any(), any()));
  });

  test('a server failure ends in error, and clearError forgets it', () async {
    when(() => fuel.createLog('v1', any())).thenAnswer((_) async => const Left(NetworkFailure()));

    expect(await container.read(newFuelControllerProvider.notifier).submit(tara, draft), isNull);
    expect(container.read(newFuelControllerProvider).error, const NetworkFailure());

    container.read(newFuelControllerProvider.notifier).clearError();
    expect(container.read(newFuelControllerProvider).hasError, isFalse);
  });
}
