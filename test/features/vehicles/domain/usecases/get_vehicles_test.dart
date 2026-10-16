import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/domain/usecases/get_vehicles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockVehicleRepository repository;
  late GetVehicles getVehicles;

  const older = Vehicle(id: '1', make: 'Honda', model: 'Civic', year: 2015, mileageKm: 90000);
  const newer = Vehicle(id: '2', make: 'Toyota', model: 'Corolla', year: 2022, mileageKm: 1000);

  setUp(() {
    repository = MockVehicleRepository();
    getVehicles = GetVehicles(repository);
  });

  test('returns vehicles sorted newest first', () async {
    when(() => repository.getVehicles()).thenAnswer((_) async => [older, newer]);

    final result = await getVehicles();

    expect(result, [newer, older]);
  });
}
