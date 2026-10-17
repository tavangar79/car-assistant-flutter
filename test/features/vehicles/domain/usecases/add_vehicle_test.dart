import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/vehicles/domain/entities/add_vehicle_result.dart';
import 'package:car_assistant/features/vehicles/domain/entities/new_vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_draft.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_failures.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_field.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_photo.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/domain/usecases/add_vehicle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockVehicleRepository repository;
  late AddVehicle addVehicle;

  final photo = VehiclePhoto(bytes: Uint8List.fromList([1, 2, 3]), fileName: 'car.jpg');
  final withPhoto = taraWith(photoUrl: '/api/vehicles/v1/photo?v=1');

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
    addVehicle = AddVehicle(repository, currentJalaliYear: () => 1405);
  });

  test('sends the checked vehicle: nickname trimmed, VIN uppercased', () async {
    when(() => repository.createVehicle(any())).thenAnswer((_) async => const Right(tara));

    final result = await addVehicle(validDraft);

    expect(result, const Right<Failure, AddVehicleResult>(AddVehicleResult(tara)));
    final sent = verify(() => repository.createVehicle(captureAny())).captured.single as NewVehicle;
    expect(sent.nickname, 'تارا اتوماتیک نقره‌ای');
    expect(sent.vin, validVin);
    verifyNever(() => repository.uploadPhoto(any(), any()));
  });

  test('rejects an invalid draft without calling the server', () async {
    const draft = VehicleDraft(
      nickname: ' ',
      plate: plate,
      vin: 'IRIK9021484839211',
      yearJalali: 1407,
      mileageKm: 2000001,
    );

    final result = await addVehicle(draft);

    expect(
      result,
      const Left<Failure, AddVehicleResult>(
        InvalidVehicleFailure({
          VehicleField.nickname,
          VehicleField.vin,
          VehicleField.make,
          VehicleField.model,
          VehicleField.year,
          VehicleField.mileage,
        }),
      ),
    );
    verifyZeroInteractions(repository);
  });

  test('rejects a photo over 5 MB before saving anything', () async {
    final big = VehiclePhoto(bytes: Uint8List(VehiclePhoto.maxBytes + 1), fileName: 'big.jpg');

    final result = await addVehicle(validDraft, photo: big);

    expect(result, const Left<Failure, AddVehicleResult>(VehiclePhotoTooLargeFailure()));
    verifyZeroInteractions(repository);
  });

  test('saves, then uploads the photo', () async {
    when(() => repository.createVehicle(any())).thenAnswer((_) async => const Right(tara));
    when(() => repository.uploadPhoto('v1', photo)).thenAnswer((_) async => Right(withPhoto));

    final result = await addVehicle(validDraft, photo: photo);

    expect(result, Right<Failure, AddVehicleResult>(AddVehicleResult(withPhoto)));
  });

  test('still succeeds when only the photo upload fails', () async {
    when(() => repository.createVehicle(any())).thenAnswer((_) async => const Right(tara));
    when(() => repository.uploadPhoto('v1', photo))
        .thenAnswer((_) async => const Left(VehiclePhotoTooLargeFailure()));

    final result = await addVehicle(validDraft, photo: photo);

    expect(
      result,
      const Right<Failure, AddVehicleResult>(
        AddVehicleResult(tara, photoFailure: VehiclePhotoTooLargeFailure()),
      ),
    );
  });

  test('does not upload the photo when saving fails', () async {
    when(() => repository.createVehicle(any()))
        .thenAnswer((_) async => const Left(PlateTakenFailure()));

    final result = await addVehicle(validDraft, photo: photo);

    expect(result, const Left<Failure, AddVehicleResult>(PlateTakenFailure()));
    verifyNever(() => repository.uploadPhoto(any(), any()));
  });

  test('passes network failures through', () async {
    when(() => repository.createVehicle(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    expect(await addVehicle(validDraft), const Left<Failure, AddVehicleResult>(NetworkFailure()));
  });
}
