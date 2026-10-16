import 'package:car_assistant/app.dart';
import 'package:car_assistant/features/splash/presentation/pages/splash_page.dart';
import 'package:car_assistant/features/splash/presentation/providers/splash_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  const delay = Duration(milliseconds: 500);

  testWidgets('app starts on the splash page in RTL, then shows vehicles', (tester) async {
    final repository = MockVehicleRepository();
    when(() => repository.getVehicles()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(repository),
          splashDelayProvider.overrideWithValue(delay),
          packageInfoProvider.overrideWith(
            (ref) async => PackageInfo(
              appName: 'car_assistant',
              packageName: 'car_assistant',
              version: '1.0.0',
              buildNumber: '1',
            ),
          ),
        ],
        child: const CarAssistantApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(SplashPage), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(SplashPage))), TextDirection.rtl);

    await tester.pump(delay);
    await tester.pumpAndSettle();

    expect(find.byType(SplashPage), findsNothing);
    expect(find.byType(VehiclesPage), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(VehiclesPage))), TextDirection.rtl);
  });
}
