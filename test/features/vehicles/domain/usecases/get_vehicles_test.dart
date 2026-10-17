import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/domain/usecases/get_vehicle_catalog.dart';
import 'package:car_assistant/features/vehicles/domain/usecases/get_vehicles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockVehicleRepository repository;

  setUp(() => repository = MockVehicleRepository());

  test('GetVehicles keeps the server order (default first, then newest)', () async {
    final other = taraWith(id: 'v2');
    when(() => repository.getVehicles()).thenAnswer((_) async => Right([tara, other]));

    final result = await GetVehicles(repository).call();

    expect(result.getOrElse((f) => throw f), [tara, other]);
  });

  test('GetVehicleCatalog returns the catalog', () async {
    when(() => repository.getCatalog()).thenAnswer((_) async => const Right(catalog));

    final result = await GetVehicleCatalog(repository).call();

    expect(result.getOrElse((f) => throw f), catalog);
  });
}
