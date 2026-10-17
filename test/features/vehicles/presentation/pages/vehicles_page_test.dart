import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/core/widgets/main_app_bar.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/features/vehicles/presentation/widgets/empty_garage.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

Widget buildPage(VehicleRepository repository, {Locale locale = const Locale('en')}) {
  return ProviderScope(
    overrides: [vehicleRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
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

  testWidgets('shows the list of vehicles', (tester) async {
    when(() => repository.getVehicles()).thenAnswer((_) async => const Right([tara]));

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();

    expect(find.text('My Garage'), findsOneWidget); // app bar title
    expect(
      find.descendant(of: find.byType(MainAppBar), matching: find.text('1 vehicle')),
      findsOneWidget,
    );
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.text('ایران خودرو تارا • 72 ب 345 Iran 68'), findsOneWidget);
  });

  testWidgets('shows vehicles with Persian digits in fa', (tester) async {
    when(() => repository.getVehicles()).thenAnswer((_) async => const Right([tara]));

    await tester.pumpWidget(buildPage(repository, locale: const Locale('fa')));
    await tester.pumpAndSettle();

    expect(find.text('گاراژ من'), findsOneWidget);
    expect(find.text('ایران خودرو تارا • ۷۲ ب ۳۴۵ ایران ۶۸'), findsOneWidget);
  });

  testWidgets('loads the vehicle photo through the repository (with auth)', (tester) async {
    const url = '/api/vehicles/v1/photo?v=1';
    when(() => repository.getVehicles()).thenAnswer((_) async => Right([taraWith(photoUrl: url)]));
    when(() => repository.fetchPhoto(url)).thenAnswer((_) async => Right(transparentPng));

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();

    verify(() => repository.fetchPhoto(url)).called(1);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('shows the empty garage when there are no vehicles', (tester) async {
    when(() => repository.getVehicles()).thenAnswer((_) async => const Right([]));

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();

    expect(find.byType(EmptyGarage), findsOneWidget);
    expect(find.text('Add a vehicle'), findsOneWidget);
    expect(find.byIcon(Icons.help_outline), findsNothing);
  });

  testWidgets('the empty garage uses Persian digits in fa', (tester) async {
    when(() => repository.getVehicles()).thenAnswer((_) async => const Right([]));

    await tester.pumpWidget(buildPage(repository, locale: const Locale('fa')));
    await tester.pumpAndSettle();

    expect(find.text('یک خودرو اضافه کنید'), findsOneWidget);
    expect(find.text('۰ خودرو'), findsOneWidget);
    expect(find.text('۳ گام اولیه'), findsOneWidget);
  });

  testWidgets('shows a localized error and retries', (tester) async {
    when(() => repository.getVehicles())
        .thenAnswer((_) async => const Left(Failure('Could not reach the server')));

    await tester.pumpWidget(buildPage(repository));
    await tester.pumpAndSettle();
    expect(find.text("Couldn't load your vehicles"), findsOneWidget);

    when(() => repository.getVehicles()).thenAnswer((_) async => const Right([]));
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.byType(EmptyGarage), findsOneWidget);
  });
}
