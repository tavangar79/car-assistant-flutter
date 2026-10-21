import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/shell/presentation/widgets/quick_actions_sheet.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late List<String> calls;

  setUp(() {
    vehicles = MockVehicleRepository();
    calls = [];
  });

  Future<void> openSheet(WidgetTester tester, List<Vehicle> garage) async {
    tester.view.physicalSize = const Size(420, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right(garage));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [vehicleRepositoryProvider.overrideWithValue(vehicles)],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => QuickActionsSheet.show(
                  context,
                  onUpdateOdometer: (vehicle) => calls.add('odometer ${vehicle.id}'),
                  onAddService: (vehicle) => calls.add('service ${vehicle.id}'),
                  onAddVehicle: () => calls.add('add vehicle'),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the default vehicle as the active one and every entry', (tester) async {
    final other = taraWith(id: 'v2', nickname: 'دنا پلاس', isDefault: false);
    await openSheet(tester, [other, tara]);

    expect(find.text('اقدامات سریع'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.text('دنا پلاس'), findsNothing);
    expect(find.text('خودروی فعال'), findsOneWidget);
    expect(find.text('عملیات برای این خودرو ثبت می‌شود'), findsOneWidget);
    for (final title in [
      'بروزرسانی کیلومترشمار',
      'ثبت سرویس و تعمیرات',
      'ثبت سوخت‌گیری',
      'ثبت هزینه متفرقه',
      'افزودن خودروی جدید',
    ]) {
      expect(find.text(title), findsOneWidget);
    }
  });

  testWidgets('the odometer entry closes the sheet and opens it for the active vehicle', (
    tester,
  ) async {
    await openSheet(tester, [tara]);

    await tester.tap(find.text('بروزرسانی کیلومترشمار'));
    await tester.pumpAndSettle();

    expect(find.byType(QuickActionsSheet), findsNothing);
    expect(calls, ['odometer v1']);
  });

  testWidgets('the service entry closes the sheet and opens the wizard for the active vehicle', (
    tester,
  ) async {
    await openSheet(tester, [tara]);

    await tester.tap(find.text('ثبت سرویس و تعمیرات'));
    await tester.pumpAndSettle();

    expect(find.byType(QuickActionsSheet), findsNothing);
    expect(calls, ['service v1']);
  });

  testWidgets('fuel and expense are disabled for now', (tester) async {
    await openSheet(tester, [tara]);

    for (final title in ['ثبت سوخت‌گیری', 'ثبت هزینه متفرقه']) {
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
    }

    expect(find.byType(QuickActionsSheet), findsOneWidget);
    expect(calls, isEmpty);
  });

  testWidgets(
    'without a vehicle the odometer and service entries are disabled; add vehicle works',
    (tester) async {
      await openSheet(tester, []);

      expect(find.text('خودروی فعال'), findsNothing);
      await tester.tap(find.text('بروزرسانی کیلومترشمار'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ثبت سرویس و تعمیرات'));
      await tester.pumpAndSettle();
      expect(calls, isEmpty);

      await tester.tap(find.text('افزودن خودروی جدید'));
      await tester.pumpAndSettle();

      expect(find.byType(QuickActionsSheet), findsNothing);
      expect(calls, ['add vehicle']);
    },
  );

  test('the active vehicle is the default one, else the first', () {
    final first = taraWith(id: 'v2', isDefault: false);
    expect(QuickActionsSheet.activeVehicle([first, tara]), tara);
    expect(QuickActionsSheet.activeVehicle([first]), first);
    expect(QuickActionsSheet.activeVehicle([]), isNull);
  });
}
