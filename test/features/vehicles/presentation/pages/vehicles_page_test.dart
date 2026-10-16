import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

Widget buildPage(VehicleRepository repository) {
  return ProviderScope(
    overrides: [vehicleRepositoryProvider.overrideWithValue(repository)],
    child: const MaterialApp(home: VehiclesPage()),
  );
}

void main() {
  late MockVehicleRepository repository;

  setUp(() => repository = MockVehicleRepository());

  testWidgets('shows the list of vehicles', (tester) async {
    when(() => repository.getVehicles()).thenAnswer(
      (_) async => [const Vehicle(id: '1', make: 'Kia', model: 'Rio', year: 2021, mileageKm: 500)],
    );

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();

    expect(find.text('2021 Kia Rio'), findsOneWidget);
    expect(find.text('500 km'), findsOneWidget);
  });

  testWidgets('shows an empty message when there are no vehicles', (tester) async {
    when(() => repository.getVehicles()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();

    expect(find.text('No vehicles yet'), findsOneWidget);
  });

  testWidgets('shows the error and retries', (tester) async {
    when(() => repository.getVehicles()).thenThrow(const Failure('Could not reach the server'));

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();
    expect(find.text('Could not reach the server'), findsOneWidget);

    when(() => repository.getVehicles()).thenAnswer((_) async => []);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('No vehicles yet'), findsOneWidget);
  });
}
