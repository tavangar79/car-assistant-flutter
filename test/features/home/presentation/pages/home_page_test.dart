import 'dart:async';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/router/app_routes.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/dashboard/domain/entities/dashboard.dart';
import 'package:car_assistant/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:car_assistant/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:car_assistant/features/history/domain/entities/history_filter.dart';
import 'package:car_assistant/features/history/domain/entities/history_period.dart';
import 'package:car_assistant/features/history/presentation/providers/history_providers.dart';
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

import '../../../dashboard/dashboard_fixtures.dart';
import '../../../vehicles/vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockOdometerRepository extends Mock implements OdometerRepository {}

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late MockOdometerRepository odometer;
  late MockDashboardRepository dashboards;
  final peugeot = taraWith(id: 'v2', nickname: 'پژو ۲۰۷i', isDefault: false);

  void answerDashboard(Dashboard dashboard) =>
      when(() => dashboards.getDashboard()).thenAnswer((_) async => Right(dashboard));

  setUp(() {
    vehicles = MockVehicleRepository();
    odometer = MockOdometerRepository();
    dashboards = MockDashboardRepository();
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([tara, peugeot]));
    when(() => odometer.getReadings(any())).thenAnswer((_) async => const Right([]));
    answerDashboard(homeDashboard());
  });

  /// Opens Home at `/`, with stand-in pages for every place it can go.
  Future<void> openPage(
    WidgetTester tester, {
    Locale locale = const Locale('fa'),
    bool settle = true,
  }) async {
    tester.view.physicalSize = const Size(420, 1800);
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
        GoRoute(
          path: '/vehicles/:id/due',
          builder: (context, state) => Text('due ${state.pathParameters['id']}'),
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
          dashboardRepositoryProvider.overrideWithValue(dashboards),
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

  testWidgets('summary tiles show the dashboard figures in Persian digits', (tester) async {
    await openPage(tester);

    for (final title in ['هزینه کل امسال', 'فاکتورها', 'نیازمند رسیدگی']) {
      expect(find.text(title), findsOneWidget);
    }
    expect(find.text('۲۴٬۸۵۰٬۰۰۰'), findsOneWidget);
    expect(find.text('تومان'), findsOneWidget);
    expect(find.text('۱۴'), findsOneWidget);
    expect(find.text('۲'), findsOneWidget);
    expect(find.text('—'), findsNothing);
  });

  testWidgets('without costs the chart shows the six server months and the empty message', (
    tester,
  ) async {
    await openPage(tester);

    expect(find.text('هزینه ۶ ماه اخیر'), findsOneWidget);
    expect(find.text('اردیبهشت — مهر ۱۴۰۵'), findsOneWidget);
    for (final month in ['اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور', 'مهر']) {
      expect(find.text(month), findsOneWidget);
    }
    expect(find.text('هنوز هزینه‌ای ثبت نشده است'), findsOneWidget);
    expect(find.textContaining('(مجموع)'), findsNothing);
  });

  testWidgets('the chart range names both years when it crosses Nowruz', (tester) async {
    answerDashboard(
      Dashboard(
        jalaliYear: 1405,
        yearTotalCost: 0,
        invoiceCount: 0,
        attentionCount: 0,
        vehicles: homeDashboard().vehicles,
        months: [
          for (final (year, month) in [
            (1404, 9),
            (1404, 10),
            (1404, 11),
            (1404, 12),
            (1405, 1),
            (1405, 2),
          ])
            monthCost(year, month, [0, 0]),
        ],
      ),
    );

    await openPage(tester);

    expect(find.text('آذر ۱۴۰۴ — اردیبهشت ۱۴۰۵'), findsOneWidget);
  });

  testWidgets('with costs it shows the latest month breakdown; tapping a bar picks a month', (
    tester,
  ) async {
    answerDashboard(
      homeDashboard(
        costs: [
          [0, 0],
          [0, 0],
          [0, 0],
          [0, 0],
          [500000, 0],
          [2400000, 1650000],
        ],
      ),
    );
    await openPage(tester);

    expect(find.text('هنوز هزینه‌ای ثبت نشده است'), findsNothing);
    expect(find.text('مهر ۱۴۰۵ (مجموع)'), findsOneWidget);
    expect(find.text('۴٬۰۵۰٬۰۰۰ تومان'), findsOneWidget);
    expect(find.text('۲٬۴۰۰٬۰۰۰ تومان'), findsOneWidget);
    expect(find.text('۱٬۶۵۰٬۰۰۰ تومان'), findsOneWidget);
    // Strip, breakdown and legend.
    expect(find.text('پژو ۲۰۷i'), findsNWidgets(3));

    await tester.tap(find.bySemanticsLabel(RegExp('^شهریور ۱۴۰۵')));
    await tester.pumpAndSettle();

    expect(find.text('شهریور ۱۴۰۵ (مجموع)'), findsOneWidget);
    expect(find.text('۵۰۰٬۰۰۰ تومان'), findsNWidgets(2)); // the total and تارا
    expect(find.text('۰ تومان'), findsOneWidget); // پژو
  });

  /// The applied history filter, read from the page's provider scope.
  HistoryFilter historyFilter(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.text('history'))).read(historyFilterProvider);

  testWidgets('"هزینه کل امسال" opens the history filtered to the current year', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('هزینه کل امسال'));
    await tester.pumpAndSettle();

    expect(find.text('history'), findsOneWidget);
    expect(historyFilter(tester), HistoryFilter.initial.withPeriod(HistoryPeriod.currentYear));
  });

  testWidgets('"فاکتورها" opens the history with attachments only', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('فاکتورها'));
    await tester.pumpAndSettle();

    expect(find.text('history'), findsOneWidget);
    expect(historyFilter(tester), HistoryFilter.initial.copyWith(attachmentsOnly: true));
  });

  testWidgets('"نیازمند رسیدگی" opens the due page of the first vehicle with items', (
    tester,
  ) async {
    await openPage(tester);

    await tester.tap(find.text('نیازمند رسیدگی'));
    await tester.pumpAndSettle();

    expect(find.text('due v2'), findsOneWidget);
  });

  testWidgets('"نیازمند رسیدگی" does nothing when nothing is due', (tester) async {
    answerDashboard(homeDashboard(attention: [0, 0]));
    await openPage(tester);

    await tester.tap(find.text('نیازمند رسیدگی'));
    await tester.pumpAndSettle();

    expect(find.text('نیازمند رسیدگی'), findsOneWidget);
    expect(find.textContaining('due'), findsNothing);
  });

  testWidgets('a dashboard error keeps the strip, shows a localized message and retries', (
    tester,
  ) async {
    when(() => dashboards.getDashboard()).thenAnswer((_) async => const Left(Failure('HTTP 500')));
    await openPage(tester, locale: const Locale('en'));

    expect(find.text("Couldn't load the dashboard"), findsOneWidget);
    expect(find.text('Total cost this year'), findsNothing);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget); // the strip still shows

    answerDashboard(homeDashboard());
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Total cost this year'), findsOneWidget);
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
