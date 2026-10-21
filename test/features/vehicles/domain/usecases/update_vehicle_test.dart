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
import 'package:car_assistant/features/vehicles/domain/usecases/update_vehicle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockVehicleRepository repository;
  late UpdateVehicle updateVehicle;

  final photo = VehiclePhoto(bytes: Uint8List.fromList([1, 2, 3]), fileName: 'car.jpg');
  final withPhoto = taraWith(photoUrl: '/api/vehicles/v1/photo?v=2');

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
    updateVehicle = UpdateVehicle(repository, currentJalaliYear: () => 1405);
  });

  test('sends the checked vehicle for the given id', () async {
    when(() => repository.updateVehicle('v1', any())).thenAnswer((_) async => const Right(tara));

    final result = await updateVehicle('v1', validDraft);

    expect(result, const Right<Failure, AddVehicleResult>(AddVehicleResult(tara)));
    final sent =
        verify(() => repository.updateVehicle('v1', captureAny())).captured.single as NewVehicle;
    expect(sent.nickname, 'تارا اتوماتیک نقره‌ای');
    expect(sent.vin, validVin);
    verifyNever(() => repository.uploadPhoto(any(), any()));
    verifyNever(() => repository.deletePhoto(any()));
  });

  test('rejects an invalid draft without calling the server', () async {
    const draft = VehicleDraft(nickname: '', plate: plate);

    final result = await updateVehicle('v1', draft);

    expect(result.getLeft().toNullable(), isA<InvalidVehicleFailure>());
    final failure = result.getLeft().toNullable()! as InvalidVehicleFailure;
    expect(failure.fields, contains(VehicleField.nickname));
    verifyZeroInteractions(repository);
  });

  test('returns the server failure, e.g. a taken plate', () async {
    when(() => repository.updateVehicle('v1', any()))
        .thenAnswer((_) async => const Left(PlateTakenFailure()));

    expect(
      await updateVehicle('v1', validDraft),
      const Left<Failure, AddVehicleResult>(PlateTakenFailure()),
    );
  });

  test('uploads a new photo after saving the changes', () async {
    when(() => repository.updateVehicle('v1', any())).thenAnswer((_) async => const Right(tara));
    when(() => repository.uploadPhoto('v1', photo)).thenAnswer((_) async => Right(withPhoto));

    final result = await updateVehicle('v1', validDraft, photo: photo);

    expect(result, Right<Failure, AddVehicleResult>(AddVehicleResult(withPhoto)));
  });

  test('a failed photo upload keeps the saved changes', () async {
    when(() => repository.updateVehicle('v1', any())).thenAnswer((_) async => const Right(tara));
    when(() => repository.uploadPhoto('v1', photo))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await updateVehicle('v1', validDraft, photo: photo);

    expect(
      result,
      const Right<Failure, AddVehicleResult>(
        AddVehicleResult(tara, photoFailure: NetworkFailure()),
      ),
    );
  });

  test('deletes the saved photo after saving the changes when it was removed', () async {
    when(() => repository.updateVehicle('v1', any())).thenAnswer((_) async => Right(withPhoto));
    when(() => repository.deletePhoto('v1')).thenAnswer((_) async => const Right(tara));

    final result = await updateVehicle('v1', validDraft, removePhoto: true);

    expect(result, const Right<Failure, AddVehicleResult>(AddVehicleResult(tara)));
    verifyInOrder([
      () => repository.updateVehicle('v1', any()),
      () => repository.deletePhoto('v1'),
    ]);
  });

  test('a new photo replaces the removed one: uploads, never deletes', () async {
    when(() => repository.updateVehicle('v1', any())).thenAnswer((_) async => const Right(tara));
    when(() => repository.uploadPhoto('v1', photo)).thenAnswer((_) async => Right(withPhoto));

    await updateVehicle('v1', validDraft, photo: photo, removePhoto: true);

    verify(() => repository.uploadPhoto('v1', photo)).called(1);
    verifyNever(() => repository.deletePhoto(any()));
  });

  test('a failed photo delete keeps the saved changes', () async {
    when(() => repository.updateVehicle('v1', any())).thenAnswer((_) async => Right(withPhoto));
    when(() => repository.deletePhoto('v1')).thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await updateVehicle('v1', validDraft, removePhoto: true);

    expect(
      result,
      Right<Failure, AddVehicleResult>(
        AddVehicleResult(withPhoto, photoFailure: const NetworkFailure()),
      ),
    );
  });

  test('does not delete the photo when the update fails', () async {
    when(() => repository.updateVehicle('v1', any()))
        .thenAnswer((_) async => const Left(VehicleRejectedFailure('Keep one default')));

    final result = await updateVehicle('v1', validDraft, removePhoto: true);

    expect(
      result,
      const Left<Failure, AddVehicleResult>(VehicleRejectedFailure('Keep one default')),
    );
    verifyNever(() => repository.deletePhoto(any()));
  });

  test('rejects a too large photo before sending anything', () async {
    final big = VehiclePhoto(bytes: Uint8List(VehiclePhoto.maxBytes + 1), fileName: 'big.jpg');

    expect(
      await updateVehicle('v1', validDraft, photo: big),
      const Left<Failure, AddVehicleResult>(VehiclePhotoTooLargeFailure()),
    );
    verifyZeroInteractions(repository);
  });
}
