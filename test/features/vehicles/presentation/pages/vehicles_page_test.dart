import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

Widget buildPage(VehicleRepository repository, {Locale locale = const Locale('en')}) {
  return ProviderScope(
    overrides: [vehicleRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const VehiclesPage(),
    ),
  );
}

void main() {
  late MockVehicleRepository repository;

  setUp(() => repository = MockVehicleRepository());

  const kia = Vehicle(id: '1', make: 'Kia', model: 'Rio', year: 2021, mileageKm: 12500);

  testWidgets('shows the list of vehicles', (tester) async {
    when(() => repository.getVehicles()).thenAnswer((_) async => [kia]);

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();

    expect(find.text('My Vehicles'), findsOneWidget);
    expect(find.text('2021 Kia Rio'), findsOneWidget);
    expect(find.text('12,500 km'), findsOneWidget);
  });

  testWidgets('shows vehicles with Persian digits in fa', (tester) async {
    when(() => repository.getVehicles()).thenAnswer((_) async => [kia]);

    await tester.pumpWidget(buildPage(repository, locale: const Locale('fa')));
    await tester.pumpAndSettle();

    expect(find.text('خودروهای من'), findsOneWidget);
    expect(find.text('Kia Rio مدل ۲۰۲۱'), findsOneWidget);
    expect(find.text('۱۲٬۵۰۰ کیلومتر'), findsOneWidget);
  });

  testWidgets('shows an empty message when there are no vehicles', (tester) async {
    when(() => repository.getVehicles()).thenAnswer((_) async => []);

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();

    expect(find.text('No vehicles yet'), findsOneWidget);
  });

  testWidgets('shows a localized error and retries', (tester) async {
    when(() => repository.getVehicles()).thenThrow(const Failure('Could not reach the server'));

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();
    expect(find.text("Couldn't load your vehicles"), findsOneWidget);

    when(() => repository.getVehicles()).thenAnswer((_) async => []);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('No vehicles yet'), findsOneWidget);
  });
}
