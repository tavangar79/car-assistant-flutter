import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/vehicles/domain/entities/new_vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/domain/usecases/set_default_vehicle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockVehicleRepository repository;
  late SetDefaultVehicle setDefault;
  final other = taraWith(id: 'v2', isDefault: false);

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
  });

  setUp(() {
    repository = MockVehicleRepository();
    setDefault = SetDefaultVehicle(repository);
  });

  test('saves the vehicle unchanged with isDefault set', () async {
    final saved = taraWith(id: 'v2', isDefault: true);
    when(() => repository.updateVehicle(any(), any())).thenAnswer((_) async => Right(saved));

    final result = await setDefault(other);

    expect(result, Right(saved));
    final sent = verify(() => repository.updateVehicle('v2', captureAny())).captured.single;
    expect(
      sent,
      NewVehicle(
        nickname: tara.nickname,
        plate: tara.plate,
        vin: tara.vin,
        makeId: 'iran-khodro',
        modelId: 'tara',
        trimId: 'tara-v4-at',
        yearJalali: 1402,
        mileageKm: 34500,
        color: tara.color,
        isDefault: true,
      ),
    );
  });

  test('passes a failure through', () async {
    when(() => repository.updateVehicle(any(), any()))
        .thenAnswer((_) async => const Left(Failure('boom')));

    expect(await setDefault(other), const Left<Failure, Vehicle>(Failure('boom')));
  });

  test('does nothing for the default vehicle', () async {
    expect(await setDefault(tara), const Right<Failure, Vehicle>(tara));
    verifyNever(() => repository.updateVehicle(any(), any()));
  });
}
