import 'dart:typed_data';

import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/vehicles/domain/entities/add_vehicle_result.dart';
import 'package:car_assistant/features/vehicles/domain/entities/new_vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_draft.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_failures.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_field.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_photo.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockVehicleRepository repository;
  late ProviderContainer container;

  final photo = VehiclePhoto(bytes: Uint8List.fromList([1, 2, 3]), fileName: 'car.jpg');

  setUpAll(() {
    registerFallbackValue(
      const NewVehicle(
        nickname: 'x',
        plate: plate,
        makeId: 'm',
        modelId: 'm',
        yearJalali: 1400,
        mileageKm: 0,
      ),
    );
    registerFallbackValue(photo);
  });

  setUp(() {
    repository = MockVehicleRepository();
    container = ProviderContainer.test(
      overrides: [
        vehicleRepositoryProvider.overrideWithValue(repository),
        currentJalaliYearProvider.overrideWithValue(1405),
      ],
    );
    // Keep the auto-dispose providers alive for the whole test.
    container.listen(addVehicleControllerProvider, (_, _) {});
  });

  Future<AddVehicleResult?> save(VehicleDraft draft, {VehiclePhoto? photo}) =>
      container.read(addVehicleControllerProvider.notifier).save(draft, photo: photo);

  Object? lastError() => container.read(addVehicleControllerProvider).error;

  test('saves, ends in data and refreshes the garage list', () async {
    when(() => repository.getVehicles()).thenAnswer((_) async => const Right([]));
    container.listen(vehiclesProvider, (_, _) {});
    await container.read(vehiclesProvider.future);
    when(() => repository.createVehicle(any())).thenAnswer((_) async => const Right(tara));
    when(() => repository.getVehicles()).thenAnswer((_) async => const Right([tara]));

    final result = await save(validDraft);

    expect(result, const AddVehicleResult(tara));
    expect(container.read(addVehicleControllerProvider), const AsyncData<void>(null));
    expect(await container.read(vehiclesProvider.future), [tara]);
  });

  test('client validation fails without calling the server', () async {
    const draft = VehicleDraft(nickname: '', plate: plate);

    expect(await save(draft), isNull);

    final failure = lastError()! as InvalidVehicleFailure;
    expect(failure.fields, containsAll([VehicleField.nickname, VehicleField.make]));
    verifyZeroInteractions(repository);
  });

  test('keeps a server 400 with its fields as the error', () async {
    when(() => repository.createVehicle(any()))
        .thenAnswer((_) async => const Left(InvalidVehicleFailure({VehicleField.model})));

    expect(await save(validDraft), isNull);

    expect(lastError(), const InvalidVehicleFailure({VehicleField.model}));
  });

  test('keeps a 409 as PlateTakenFailure', () async {
    when(() => repository.createVehicle(any()))
        .thenAnswer((_) async => const Left(PlateTakenFailure()));

    expect(await save(validDraft), isNull);

    expect(lastError(), const PlateTakenFailure());
  });

  test('a network failure becomes the error state', () async {
    when(() => repository.createVehicle(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    expect(await save(validDraft), isNull);

    expect(lastError(), const NetworkFailure());
  });

  test('a failed photo upload still counts as saved', () async {
    when(() => repository.createVehicle(any())).thenAnswer((_) async => const Right(tara));
    when(() => repository.uploadPhoto('v1', photo))
        .thenAnswer((_) async => const Left(InvalidVehiclePhotoFailure()));

    final result = await save(validDraft, photo: photo);

    expect(result?.photoFailure, const InvalidVehiclePhotoFailure());
    expect(container.read(addVehicleControllerProvider).hasError, isFalse);
  });
}
