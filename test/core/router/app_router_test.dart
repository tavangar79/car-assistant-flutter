import 'package:car_assistant/app.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  testWidgets('app starts on the vehicles page in RTL', (tester) async {
    final repository = MockVehicleRepository();
    when(() => repository.getVehicles()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [vehicleRepositoryProvider.overrideWithValue(repository)],
        child: const CarAssistantApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VehiclesPage), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(VehiclesPage))), TextDirection.rtl);
  });
}
