import 'dart:async';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/router/app_routes.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/home/presentation/pages/home_page.dart';
import 'package:car_assistant/features/home/presentation/widgets/home_app_bar.dart';
import 'package:car_assistant/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/odometer/presentation/widgets/odometer_sheet.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/features/vehicles/presentation/widgets/empty_garage.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockOdometerRepository extends Mock implements OdometerRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late MockOdometerRepository odometer;
  final peugeot = taraWith(id: 'v2', nickname: 'پژو ۲۰۷i', isDefault: false);
  // ۲۹ مهر ۱۴۰۵.
  var now = DateTime(2026, 10, 21, 10);

  setUp(() {
    now = DateTime(2026, 10, 21, 10);
    vehicles = MockVehicleRepository();
    odometer = MockOdometerRepository();
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([tara, peugeot]));
    when(() => odometer.getReadings(any())).thenAnswer((_) async => const Right([]));
  });

  /// Opens Home at `/`, with stand-in pages for every place it can go.
  Future<void> openPage(
    WidgetTester tester, {
    Locale locale = const Locale('fa'),
    bool settle = true,
  }) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: AppRoutes.vehiclesPath, builder: (context, state) => const Text('garage')),
        GoRoute(
          path: '/vehicles/:id',
          builder: (context, state) => Text('details ${state.pathParameters['id']}'),
        ),
        GoRoute(path: AppRoutes.historyPath, builder: (context, state) => const Text('history')),
        GoRoute(path: AppRoutes.addVehiclePath, builder: (context, state) => const Text('adding')),
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

  testWidgets('shows the app bar and the garage strip with real counts', (tester) async {
    await openPage(tester);

    expect(find.descendant(of: find.byType(HomeAppBar), matching: find.text('خانه')), findsOne);
    expect(find.text('مدیریت خودرو'), findsOneWidget);
    expect(find.byTooltip('اعلانات'), findsOneWidget);
    expect(find.text('گاراژ من'), findsOneWidget);
    expect(find.text('۲ خودرو'), findsOneWidget);
    expect(find.text('مدیریت'), findsOneWidget);
    // Each nickname is in the strip and in the chart legend.
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsNWidgets(2));
    expect(find.text('پژو ۲۰۷i'), findsNWidgets(2));
  });

  testWidgets('summary tiles show "—" (read as "can\'t be calculated"), never made-up numbers', (
    tester,
  ) async {
    await openPage(tester);

    for (final title in ['هزینه کل امسال', 'فاکتورها', 'نیازمند رسیدگی']) {
      expect(find.text(title), findsOneWidget);
    }
    expect(find.text('—'), findsNWidgets(3));
    expect(
      find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'قابل محاسبه نیست'),
      findsNWidgets(3),
    );
    expect(find.text('تومان'), findsOneWidget);
    expect(find.textContaining('٪'), findsNothing);
    expect(find.textContaining('%'), findsNothing);
  });

  testWidgets('the spend chart shows the last six Jalali months and no costs yet', (tester) async {
    await openPage(tester);

    expect(find.text('هزینه ۶ ماه اخیر'), findsOneWidget);
    expect(find.text('اردیبهشت — مهر ۱۴۰۵'), findsOneWidget);
    for (final month in ['اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور', 'مهر']) {
      expect(find.text(month), findsOneWidget);
    }
    expect(find.text('هنوز هزینه‌ای ثبت نشده است'), findsOneWidget);
  });

  testWidgets('the chart range names both years when it crosses Nowruz', (tester) async {
    now = DateTime(2026, 5, 1); // ۱۱ اردیبهشت ۱۴۰۵

    await openPage(tester);

    expect(find.text('آذر ۱۴۰۴ — اردیبهشت ۱۴۰۵'), findsOneWidget);
  });

  testWidgets('loads the vehicle photos through the repository (with auth)', (tester) async {
    const url = '/api/vehicles/v1/photo?v=1';
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([taraWith(photoUrl: url)]));
    when(() => vehicles.fetchPhoto(url)).thenAnswer((_) async => Right(transparentPng));

    await openPage(tester);

    verify(() => vehicles.fetchPhoto(url)).called(1);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('"بروزرسانی کیلومتر" opens the odometer sheet for the default vehicle', (
    tester,
  ) async {
    when(() => vehicles.getVehicles()).thenAnswer(
      (_) async => Right([taraWith(isDefault: false), taraWith(id: 'v2', isDefault: true)]),
    );
    await openPage(tester);

    expect(find.text('انتخاب خودرو و ثبت سریع کیلومترشمار فعلی'), findsOneWidget);
    await tester.tap(find.text('بروزرسانی کیلومتر'));
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate((w) => w is OdometerSheet && w.vehicleId == 'v2'),
      findsOneWidget,
    );
  });

  testWidgets('a vehicle chip opens that vehicle', (tester) async {
    await openPage(tester);

    final chip = find.text('پژو ۲۰۷i').first;
    await tester.ensureVisible(chip); // the strip scrolls sideways
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();

    expect(find.text('details v2'), findsOneWidget);
  });

  testWidgets('"مدیریت" opens the garage', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('مدیریت'));
    await tester.pumpAndSettle();

    expect(find.text('garage'), findsOneWidget);
  });

  testWidgets('a summary tile opens the history', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('نیازمند رسیدگی'));
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

  testWidgets('shows the empty garage without vehicles; its button adds one', (tester) async {
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([]));
    await openPage(tester);

    expect(find.byType(EmptyGarage), findsOneWidget);
    expect(find.text('هزینه کل امسال'), findsNothing);

    await tester.tap(find.text('افزودن خودرو'));
    await tester.pumpAndSettle();
    expect(find.text('adding'), findsOneWidget);
  });

  testWidgets('shows a localized error and retries', (tester) async {
    when(() => vehicles.getVehicles())
        .thenAnswer((_) async => const Left(Failure('Could not reach the server')));
    await openPage(tester, locale: const Locale('en'));
    expect(find.text("Couldn't load your vehicles"), findsOneWidget);

    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([tara]));
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Total cost this year'), findsOneWidget);
  });
}
