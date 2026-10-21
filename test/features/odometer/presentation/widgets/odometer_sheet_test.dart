import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_failures.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_update.dart';
import 'package:car_assistant/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/odometer/presentation/widgets/odometer_sheet.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:car_assistant/features/intervals/presentation/widgets/due_success_card.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../odometer_fixtures.dart';

class MockOdometerRepository extends Mock implements OdometerRepository {}

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockOdometerRepository odometer;
  late MockVehicleRepository vehicles;
  final now = DateTime(2026, 10, 21, 18, 45); // 29 Mehr 1405
  final dena = taraWith(id: 'v2', nickname: 'دنا پلاس', isDefault: false);

  setUp(() {
    odometer = MockOdometerRepository();
    vehicles = MockVehicleRepository();
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([tara, dena]));
    when(() => odometer.getReadings(any())).thenAnswer((_) async => const Right([]));
  });

  /// Opens the sheet for `tara` (v1) from a button, in Persian.
  Future<void> openSheet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          odometerRepositoryProvider.overrideWithValue(odometer),
          clockProvider.overrideWithValue(() => now),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => OdometerSheet.show(context, vehicleId: 'v1'),
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

  Finder input() => find.byType(TextField);

  String inputText(WidgetTester tester) => tester.widget<TextField>(input()).controller!.text;

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  testWidgets('starts from the preselected vehicle and its last reading', (tester) async {
    await openSheet(tester);

    expect(find.text('بروزرسانی کیلومترشمار'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.text('دنا پلاس'), findsOneWidget);
    expect(find.text('آخرین ثبت: ۳۴٬۵۰۰ کیلومتر'), findsOneWidget);
    expect(inputText(tester), '۳۴٬۵۰۰');
    // No reading yet: the distance has no date.
    expect(find.textContaining('+۰ کیلومتر پیمایش از آخرین به‌روزرسانی'), findsOneWidget);
    expect(find.textContaining('('), findsNothing);
    expect(find.text('امروز، ۲۹ مهر ۱۴۰۵ — ۱۸:۴۵'), findsOneWidget);
    for (final step in ['+۵۰۰', '+۱٬۰۰۰', '+۲٬۰۰۰', '-۵۰۰']) {
      expect(find.text(step), findsOneWidget);
    }
  });

  testWidgets('shows the date of the latest reading after the distance', (tester) async {
    when(() => odometer.getReadings('v1')).thenAnswer((_) async => Right([reading]));

    await openSheet(tester);

    expect(find.textContaining('پیمایش از آخرین به‌روزرسانی ('), findsOneWidget);
    expect(find.textContaining('مهر ۱۴۰۵)'), findsOneWidget);
  });

  testWidgets('quick buttons adjust the value and reset puts the last reading back', (
    tester,
  ) async {
    await openSheet(tester);

    await tapText(tester, '+۱٬۰۰۰');
    await tapText(tester, '+۵۰۰');
    expect(inputText(tester), '۳۶٬۰۰۰');
    expect(find.textContaining('+۱٬۵۰۰ کیلومتر'), findsOneWidget);

    await tapText(tester, 'بازنشانی');
    expect(inputText(tester), '۳۴٬۵۰۰');
  });

  testWidgets('typing accepts any digits and shows them in Persian', (tester) async {
    await openSheet(tester);

    await tester.enterText(input(), '34850');
    await tester.pump();

    expect(inputText(tester), '۳۴٬۸۵۰');
    expect(find.textContaining('+۳۵۰ کیلومتر'), findsOneWidget);
  });

  testWidgets('a value below the last reading shows an error and is not sent', (tester) async {
    await openSheet(tester);

    await tapText(tester, '-۵۰۰');
    expect(find.text('کارکرد نمی‌تواند کمتر از آخرین ثبت (۳۴٬۵۰۰ کیلومتر) باشد'), findsOneWidget);

    await tapText(tester, 'تأیید و ثبت کارکرد');

    verifyNever(() => odometer.recordReading(any(), mileageKm: any(named: 'mileageKm')));
    expect(find.byType(OdometerSheet), findsOneWidget);
  });

  testWidgets('saves the reading, closes and confirms', (tester) async {
    when(() => odometer.recordReading('v1', mileageKm: 35000))
        .thenAnswer((_) async => Right(OdometerUpdate(reading: reading, vehicle: tara)));
    await openSheet(tester);

    await tapText(tester, '+۵۰۰');
    await tapText(tester, 'تأیید و ثبت کارکرد');

    verify(() => odometer.recordReading('v1', mileageKm: 35000)).called(1);
    expect(find.byType(OdometerSheet), findsNothing);
    expect(find.text('کارکرد با موفقیت ثبت شد'), findsOneWidget);
  });

  testWidgets('a 422 from the server shows the same inline error', (tester) async {
    when(() => odometer.recordReading('v1', mileageKm: 35000))
        .thenAnswer((_) async => const Left(MileageBelowCurrentFailure(36000)));
    await openSheet(tester);

    await tapText(tester, '+۵۰۰');
    await tapText(tester, 'تأیید و ثبت کارکرد');

    expect(find.text('کارکرد نمی‌تواند کمتر از آخرین ثبت (۳۶٬۰۰۰ کیلومتر) باشد'), findsOneWidget);
    expect(find.byType(OdometerSheet), findsOneWidget);
  });

  testWidgets('another failure shows a message and keeps the sheet open', (tester) async {
    when(() => odometer.recordReading('v1', mileageKm: 34500))
        .thenAnswer((_) async => const Left(NetworkFailure()));
    await openSheet(tester);

    await tapText(tester, 'تأیید و ثبت کارکرد');

    expect(find.text('ثبت کارکرد ممکن نشد، دوباره تلاش کنید'), findsOneWidget);
    expect(find.byType(OdometerSheet), findsOneWidget);
  });

  testWidgets('picking another vehicle records for it, from its mileage', (tester) async {
    when(() => odometer.recordReading('v2', mileageKm: 34500))
        .thenAnswer((_) async => Right(OdometerUpdate(reading: reading, vehicle: dena)));
    await openSheet(tester);
    await tapText(tester, '+۵۰۰');

    await tapText(tester, 'دنا پلاس');
    expect(inputText(tester), '۳۴٬۵۰۰');
    await tapText(tester, 'تأیید و ثبت کارکرد');

    verify(() => odometer.recordReading('v2', mileageKm: 34500)).called(1);
  });

  testWidgets('an earlier date from the picker is sent with the current time', (tester) async {
    final yesterday = DateTime(2026, 10, 20, 18, 45);
    when(() => odometer.recordReading('v1', mileageKm: 34500, recordedAt: yesterday))
        .thenAnswer((_) async => Right(OdometerUpdate(reading: reading, vehicle: tara)));
    await openSheet(tester);

    await tapText(tester, 'تغییر تاریخ');
    // Roll the day wheel back by one item (29 → 28 Mehr).
    await tester.drag(find.text('۲۹').last, const Offset(0, 44));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تأیید تاریخ'));
    await tester.pumpAndSettle();

    expect(find.text('۲۸ مهر ۱۴۰۵ — ۱۸:۴۵'), findsOneWidget);
    await tapText(tester, 'تأیید و ثبت کارکرد');
    verify(() => odometer.recordReading('v1', mileageKm: 34500, recordedAt: yesterday)).called(1);
  });

  testWidgets('with a router, saving opens the due page with the old and new mileage', (
    tester,
  ) async {
    when(() => odometer.recordReading('v1', mileageKm: 35000))
        .thenAnswer((_) async => Right(OdometerUpdate(reading: reading, vehicle: tara)));
    OdometerUpdateArgs? args;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => OdometerSheet.show(context, vehicleId: 'v1'),
              child: const Text('open'),
            ),
          ),
        ),
        GoRoute(
          path: '/vehicles/:id/due',
          builder: (context, state) {
            args = state.extra as OdometerUpdateArgs?;
            return Scaffold(body: Text('due ${state.pathParameters['id']}'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          odometerRepositoryProvider.overrideWithValue(odometer),
          clockProvider.overrideWithValue(() => now),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tapText(tester, '+۵۰۰');
    await tapText(tester, 'تأیید و ثبت کارکرد');

    expect(find.text('due v1'), findsOneWidget);
    expect(args?.previousKm, 34500);
    expect(args?.newKm, 35000);
  });

  testWidgets('cancel closes the sheet', (tester) async {
    await openSheet(tester);

    await tapText(tester, 'انصراف');

    expect(find.byType(OdometerSheet), findsNothing);
  });
}
