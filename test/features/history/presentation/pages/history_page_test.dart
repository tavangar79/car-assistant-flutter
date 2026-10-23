import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/router/app_routes.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/history/domain/entities/history_query.dart';
import 'package:car_assistant/features/history/domain/entities/history_result.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';
import 'package:car_assistant/features/history/domain/repositories/history_repository.dart';
import 'package:car_assistant/features/history/presentation/pages/history_page.dart';
import 'package:car_assistant/features/history/presentation/providers/history_providers.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/services/domain/repositories/service_repository.dart';
import 'package:car_assistant/features/services/presentation/providers/service_providers.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../services/service_fixtures.dart';
import '../../../vehicles/vehicle_fixtures.dart';
import '../../history_fixtures.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

void main() {
  final now = DateTime(2026, 10, 21, 18, 45); // ۲۹ مهر ۱۴۰۵
  final addedTara = Vehicle(
    id: tara.id,
    nickname: tara.nickname,
    plate: tara.plate,
    make: tara.make,
    model: tara.model,
    yearJalali: tara.yearJalali,
    mileageKm: tara.mileageKm,
    createdAt: DateTime.utc(2023, 6, 1), // خرداد ۱۴۰۲
  );
  late MockHistoryRepository history;
  late MockVehicleRepository vehicles;
  late MockServiceRepository services;
  late ProviderContainer container;
  late List<String> opened;

  setUpAll(() => registerFallbackValue(const HistoryQuery()));

  void stubFirstPage(Either<Failure, HistoryResult> result) =>
      when(() => history.getHistory(any(that: _withCursor(null)))).thenAnswer((_) async => result);

  setUp(() {
    history = MockHistoryRepository();
    vehicles = MockVehicleRepository();
    services = MockServiceRepository();
    opened = [];
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([addedTara]));
    when(() => services.getCatalog(vehicleId: any(named: 'vehicleId')))
        .thenAnswer((_) async => const Right(serviceCatalog));
    stubFirstPage(Right(historyResult()));
    when(() => history.getHistory(any(that: _withCursor('c1'))))
        .thenAnswer((_) async => const Right(HistoryResult(entries: [])));
  });

  Future<void> openPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    container = ProviderContainer(
      overrides: [
        historyRepositoryProvider.overrideWithValue(history),
        vehicleRepositoryProvider.overrideWithValue(vehicles),
        serviceRepositoryProvider.overrideWithValue(services),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    Widget page(String name) => Scaffold(body: Text(name));
    final router = GoRouter(
      initialLocation: AppRoutes.historyPath,
      routes: [
        GoRoute(
          path: AppRoutes.historyFilterPath,
          builder: (context, state) {
            opened.add('filter');
            return page('filter');
          },
        ),
        GoRoute(
          path: AppRoutes.reportExportPath,
          builder: (context, state) {
            opened.add('report:${state.uri.queryParameters['vehicleId']}');
            return page('report');
          },
        ),
        GoRoute(
          path: AppRoutes.historyPath,
          builder: (context, state) => const HistoryPage(),
          routes: [
            GoRoute(
              path: 'services/:vehicleId/:serviceId',
              builder: (context, state) {
                opened.add(
                  '${state.pathParameters['vehicleId']}/${state.pathParameters['serviceId']}',
                );
                return page('service');
              },
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  HistoryQuery lastFirstPageQuery() =>
      verify(() => history.getHistory(captureAny(that: _withCursor(null)))).captured.last
          as HistoryQuery;

  testWidgets('shows the vehicle, the summary and the records grouped by Jalali month', (
    tester,
  ) async {
    await openPage(tester);

    expect(find.text('تارا اتوماتیک نقره‌ای'), findsWidgets); // chip and ribbon
    expect(find.text('مدل ۱۴۰۲ • کارکرد فعلی ۳۴٬۵۰۰ کیلومتر'), findsOneWidget);
    expect(find.text('مجموع هزینه‌ها'), findsOneWidget);
    expect(find.text('۱۴٬۲۸۰٬۰۰۰'), findsOneWidget);
    expect(find.text('۲۳ مورد ثبت شده'), findsOneWidget);
    expect(find.text('۸ سرویس ثبت‌شده'), findsOneWidget);
    expect(find.text('۲۴۰٫۵ لیتر'), findsOneWidget);
    for (final month in ['مهر ۱۴۰۵', 'آبان ۱۴۰۴', 'آبان ۱۴۰۳']) {
      expect(find.text(month), findsOneWidget);
    }
    expect(find.text('۱ مورد'), findsNWidgets(3));
    // Service: item titles from the catalog, mileage, workshop and the invoice badge.
    expect(find.text('روغن موتور، فیلتر روغن'), findsOneWidget);
    // Titles come from the vehicle-independent title lookup (no vehicleId).
    verify(() => services.getCatalog()).called(greaterThan(0));
    verifyNever(
      () => services.getCatalog(
        vehicleId: any(named: 'vehicleId', that: isNotNull),
      ),
    );
    expect(find.text('۲۸ مهر ۱۴۰۵ • ۳۴٬۸۵۰ کیلومتر'), findsOneWidget);
    expect(find.text('فاکتور'), findsOneWidget);
    // Fuel: full fill, volume and economy.
    expect(find.text('سوپر (باک پر)'), findsOneWidget);
    expect(find.text('۷٫۴۶ لیتر / ۱۰۰ ک‌م'), findsOneWidget);
    // Expense: its title, issuer, expiry and attachment badge.
    expect(find.text('تمدید بیمه‌نامه شخص ثالث ۱۲ ماهه ایران'), findsOneWidget);
    expect(find.text('پیوست'), findsOneWidget);
  });

  testWidgets('the export button opens the report export for the chosen vehicle', (tester) async {
    await openPage(tester);
    container.read(historyFilterProvider.notifier).setVehicles({tara.id});
    await tester.pumpAndSettle();

    await tapText(tester, 'خروجی اکسل/PDF');

    expect(opened, ['report:${tara.id}']);
  });

  testWidgets('loads the next page at the end, then shows when the history starts', (tester) async {
    await openPage(tester);

    verify(() => history.getHistory(any(that: _withCursor('c1')))).called(1);
    expect(find.text('شروع تاریخچه از تاریخ ثبت خودرو (خرداد ۱۴۰۲)'), findsOneWidget);
  });

  testWidgets('a failed next page offers a retry', (tester) async {
    when(() => history.getHistory(any(that: _withCursor('c1'))))
        .thenAnswer((_) async => const Left(Failure('boom')));
    await openPage(tester);

    expect(find.text('دریافت ادامه تاریخچه ممکن نشد'), findsOneWidget);
    await tapText(tester, 'تلاش دوباره');

    verify(() => history.getHistory(any(that: _withCursor('c1')))).called(2);
  });

  testWidgets('a service row opens its details; fuel and expense rows do not navigate', (
    tester,
  ) async {
    await openPage(tester);

    await tapText(tester, 'سوپر (باک پر)');
    await tapText(tester, 'تمدید بیمه‌نامه شخص ثالث ۱۲ ماهه ایران');
    expect(opened, isEmpty);

    await tapText(tester, 'روغن موتور، فیلتر روغن');
    expect(opened, ['v1/s1']);
  });

  testWidgets('the type tabs and the invoice chip refilter the history', (tester) async {
    await openPage(tester);

    await tapText(tester, 'سوخت‌گیری');
    expect(lastFirstPageQuery().type, HistoryType.fuel);

    await tapText(tester, 'فاکتوردار');
    final query = lastFirstPageQuery();
    expect(query.type, HistoryType.fuel);
    expect(query.attachmentsOnly, isTrue);
  });

  testWidgets('the tune button and the period chip open the filter', (tester) async {
    await openPage(tester);

    await tester.tap(find.byTooltip('فیلتر سوابق'));
    await tester.pumpAndSettle();
    expect(opened, ['filter']);
  });

  testWidgets('the vehicle chip switches to one vehicle or all of them', (tester) async {
    final peugeot = taraWith(id: 'v2', nickname: 'پژو ۲۰۷');
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([addedTara, peugeot]));
    await openPage(tester);
    expect(find.text('همه خودروها'), findsOneWidget);
    expect(find.text('همه خودروهای گاراژ'), findsOneWidget); // ribbon

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    await tester.tap(find.text('پژو ۲۰۷').last);
    await tester.pumpAndSettle();

    expect(lastFirstPageQuery().vehicleIds, ['v2']);
    expect(find.text('پژو ۲۰۷'), findsWidgets);
  });

  testWidgets('a preset from another page shows the current year', (tester) async {
    await openPage(tester);

    container.read(historyFilterProvider.notifier).showCurrentYear();
    await tester.pumpAndSettle();

    expect(find.text('مجموع هزینه‌های سال ۱۴۰۵'), findsOneWidget);
    expect(find.text('۱۴۰۵'), findsOneWidget); // the period chip
    expect(lastFirstPageQuery().from, DateTime(2026, 3, 21));
  });

  testWidgets('shows the empty state', (tester) async {
    stubFirstPage(const Right(HistoryResult(entries: [], summary: summary)));
    await openPage(tester);

    expect(find.text('سابقه‌ای با این فیلترها پیدا نشد'), findsOneWidget);
  });

  testWidgets('shows an error with retry', (tester) async {
    stubFirstPage(const Left(Failure('boom')));
    await openPage(tester);

    expect(find.text('دریافت تاریخچه ممکن نشد'), findsOneWidget);
    stubFirstPage(Right(historyResult()));
    await tapText(tester, 'تلاش دوباره');

    expect(find.text('روغن موتور، فیلتر روغن'), findsOneWidget);
  });
}

Matcher _withCursor(String? cursor) =>
    isA<HistoryQuery>().having((query) => query.cursor, 'cursor', cursor);
