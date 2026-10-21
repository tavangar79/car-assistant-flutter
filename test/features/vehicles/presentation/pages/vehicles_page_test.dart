import 'dart:async';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/router/app_routes.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/core/widgets/main_app_bar.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_reading.dart';
import 'package:car_assistant/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/odometer/presentation/widgets/odometer_sheet.dart';
import 'package:car_assistant/features/vehicles/domain/entities/new_vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/features/vehicles/presentation/widgets/empty_garage.dart';
import 'package:car_assistant/features/vehicles/presentation/widgets/garage/garage_vehicle_card.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../odometer/odometer_fixtures.dart';
import '../../vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockOdometerRepository extends Mock implements OdometerRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late MockOdometerRepository odometer;
  // The latest fixture reading is 2026-10-20 15:15 UTC: "yesterday" for this clock.
  final now = DateTime(2026, 10, 21, 20);
  final peugeot = taraWith(id: 'v2', nickname: 'پژو ۲۰۷i سقف شیشه‌ای', isDefault: false);

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
    vehicles = MockVehicleRepository();
    odometer = MockOdometerRepository();
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([tara, peugeot]));
    when(() => odometer.getReadings('v1')).thenAnswer((_) async => Right([reading]));
    when(() => odometer.getReadings('v2')).thenAnswer((_) async => const Right([]));
  });

  /// Opens the Garage tab at `/`, with stand-in pages for every place it can go.
  Future<void> openPage(
    WidgetTester tester, {
    Locale locale = const Locale('fa'),
    bool settle = true,
  }) async {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const VehiclesPage()),
        GoRoute(
          path: '/vehicles/:id',
          builder: (context, state) => Text('details ${state.pathParameters['id']}'),
        ),
        GoRoute(
          path: AppRoutes.editVehiclePath,
          builder: (context, state) => Text('editing ${(state.extra! as Vehicle).id}'),
        ),
        GoRoute(path: AppRoutes.addVehiclePath, builder: (context, state) => const Text('adding')),
        GoRoute(path: AppRoutes.historyPath, builder: (context, state) => const Text('history')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          odometerRepositoryProvider.overrideWithValue(odometer),
          clockProvider.overrideWithValue(() => now),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
        ),
      ),
    );
    settle ? await tester.pumpAndSettle() : await tester.pump();
  }

  Finder inCard(String vehicleId, Finder matching) => find.descendant(
    of: find.byWidgetPredicate((w) => w is GarageVehicleCard && w.vehicle.id == vehicleId),
    matching: matching,
  );

  testWidgets('shows a card per vehicle with the counts in Persian', (tester) async {
    await openPage(tester);

    expect(find.descendant(of: find.byType(MainAppBar), matching: find.text('گاراژ من')), findsOne);
    expect(find.descendant(of: find.byType(MainAppBar), matching: find.text('۲ خودرو')), findsOne);
    expect(find.byTooltip('تاریخچه رویدادها'), findsOneWidget);
    expect(find.text('خودروهای من'), findsOneWidget);
    expect(find.text('۲ خودرو فعال'), findsOneWidget);
    expect(find.byType(GarageVehicleCard), findsNWidgets(2));
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.text('پژو ۲۰۷i سقف شیشه‌ای'), findsOneWidget);
    expect(
      inCard('v1', find.text('مدل ۱۴۰۲ • ایران خودرو • تارا • V4 اتوماتیک - فول آپشن')),
      findsOne,
    );
    expect(
      inCard(
        'v1',
        find.byWidgetPredicate((w) => w is Semantics && w.properties.label == '۷۲ ب ۳۴۵ ایران ۶۸'),
      ),
      findsOneWidget,
      reason: 'the plate is read as one line',
    );
    expect(find.text('مدیریت و امکانات گاراژ'), findsOneWidget);
  });

  testWidgets('shows the mileage and when it was last read; "—" without readings', (tester) async {
    await openPage(tester);

    expect(inCard('v1', find.text('۳۴٬۵۰۰')), findsOneWidget);
    expect(inCard('v1', find.text('آخرین ثبت: دیروز')), findsOneWidget);
    expect(inCard('v2', find.text('آخرین ثبت: —')), findsOneWidget);
  });

  testWidgets('counts days since the latest reading', (tester) async {
    final older = OdometerReading(
      id: 'r2',
      vehicleId: 'v1',
      mileageKm: 34000,
      recordedAt: DateTime(2026, 10, 18, 9),
      createdAt: DateTime(2026, 10, 18, 9),
    );
    when(() => odometer.getReadings('v1')).thenAnswer((_) async => Right([older]));

    await openPage(tester, locale: const Locale('en'));

    expect(inCard('v1', find.text('Last update: 3 days ago')), findsOneWidget);
  });

  testWidgets('shows no made-up service status, only "can\'t be calculated"', (tester) async {
    await openPage(tester);

    expect(find.text('وضعیت سرویس‌ها'), findsNWidgets(2));
    expect(find.text('قابل محاسبه نیست'), findsNWidgets(2));
    expect(find.text('سالم'), findsNothing);
  });

  testWidgets('marks the default vehicle and offers "set as default" on the others', (
    tester,
  ) async {
    await openPage(tester);

    expect(inCard('v1', find.text('خودروی پیش‌فرض')), findsOneWidget);
    expect(inCard('v1', find.text('انتخاب به عنوان پیش‌فرض')), findsNothing);
    expect(inCard('v2', find.text('انتخاب به عنوان پیش‌فرض')), findsOneWidget);
  });

  testWidgets('"set as default" saves the vehicle as default and reloads the garage', (
    tester,
  ) async {
    when(() => vehicles.updateVehicle('v2', any()))
        .thenAnswer((_) async => Right(taraWith(id: 'v2', isDefault: true)));
    await openPage(tester);
    clearInteractions(vehicles);

    await tester.tap(find.text('انتخاب به عنوان پیش‌فرض'));
    await tester.pumpAndSettle();

    final sent = verify(() => vehicles.updateVehicle('v2', captureAny())).captured.single;
    expect((sent as NewVehicle).isDefault, isTrue);
    verify(() => vehicles.getVehicles()).called(1);
  });

  testWidgets('a failed "set as default" shows a message', (tester) async {
    when(() => vehicles.updateVehicle(any(), any()))
        .thenAnswer((_) async => const Left(Failure('boom')));
    await openPage(tester);

    await tester.tap(find.text('انتخاب به عنوان پیش‌فرض'));
    await tester.pumpAndSettle();

    expect(find.text('تغییر خودروی پیش‌فرض ممکن نشد'), findsOneWidget);
  });

  testWidgets('tapping a card opens that vehicle', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('پژو ۲۰۷i سقف شیشه‌ای'));
    await tester.pumpAndSettle();

    expect(find.text('details v2'), findsOneWidget);
  });

  testWidgets('the options menu opens the edit page for that vehicle', (tester) async {
    await openPage(tester);

    await tester.tap(inCard('v2', find.byTooltip('تنظیمات خودرو')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ویرایش خودرو'));
    await tester.pumpAndSettle();

    expect(find.text('editing v2'), findsOneWidget);
  });

  testWidgets('"ثبت کیلومتر" opens the odometer sheet for that vehicle', (tester) async {
    await openPage(tester);

    await tester.tap(inCard('v2', find.text('ثبت کیلومتر')));
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate((w) => w is OdometerSheet && w.vehicleId == 'v2'),
      findsOneWidget,
    );
  });

  testWidgets('shortcuts and tools without a page yet do nothing', (tester) async {
    await openPage(tester);

    await tester.tap(inCard('v1', find.text('ثبت سرویس')));
    await tester.tap(inCard('v1', find.text('دفترچه سوابق')));
    await tester.tap(find.text('انتقال مالکیت خودرو'));
    await tester.pumpAndSettle();

    expect(find.byType(VehiclesPage), findsOneWidget);
    expect(find.byType(OdometerSheet), findsNothing);
  });

  testWidgets('the header button adds a vehicle', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('افزودن خودرو'));
    await tester.pumpAndSettle();

    expect(find.text('adding'), findsOneWidget);
  });

  testWidgets('the app bar history button opens the history', (tester) async {
    await openPage(tester);

    await tester.tap(find.byTooltip('تاریخچه رویدادها'));
    await tester.pumpAndSettle();
    expect(find.text('history'), findsOneWidget);
  });

  testWidgets('shows a spinner while loading', (tester) async {
    final pending = Completer<Either<Failure, List<Vehicle>>>();
    when(() => vehicles.getVehicles()).thenAnswer((_) => pending.future);
    await openPage(tester, settle: false);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    pending.complete(const Right([]));
    await tester.pumpAndSettle();
  });

  testWidgets('shows the empty garage when there are no vehicles', (tester) async {
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([]));

    await openPage(tester);

    expect(find.byType(EmptyGarage), findsOneWidget);
    expect(find.byType(GarageVehicleCard), findsNothing);
    expect(find.text('یک خودرو اضافه کنید'), findsOneWidget);
    expect(find.descendant(of: find.byType(MainAppBar), matching: find.text('۰ خودرو')), findsOne);
    expect(find.byTooltip('تاریخچه رویدادها'), findsNothing);
    expect(find.text('۳ گام اولیه'), findsOneWidget);
  });

  testWidgets('shows a localized error and retries', (tester) async {
    when(() => vehicles.getVehicles())
        .thenAnswer((_) async => const Left(Failure('Could not reach the server')));

    await openPage(tester, locale: const Locale('en'));
    expect(find.text("Couldn't load your vehicles"), findsOneWidget);

    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([]));
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.byType(EmptyGarage), findsOneWidget);
  });
}
