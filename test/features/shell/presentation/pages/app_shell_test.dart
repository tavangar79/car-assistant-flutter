import 'package:car_assistant/app.dart';
import 'package:car_assistant/core/widgets/main_app_bar.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/history/domain/entities/history_query.dart';
import 'package:car_assistant/features/history/domain/entities/history_result.dart';
import 'package:car_assistant/features/history/domain/repositories/history_repository.dart';
import 'package:car_assistant/features/history/presentation/pages/history_page.dart';
import 'package:car_assistant/features/history/presentation/providers/history_providers.dart';
import 'package:car_assistant/features/history/presentation/widgets/history_app_bar.dart';
import 'package:car_assistant/features/home/presentation/pages/home_page.dart';
import 'package:car_assistant/features/home/presentation/widgets/home_app_bar.dart';
import 'package:car_assistant/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:car_assistant/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:car_assistant/features/profile/domain/entities/profile_stats.dart';
import 'package:car_assistant/features/profile/domain/repositories/profile_repository.dart';
import 'package:car_assistant/features/profile/presentation/pages/profile_page.dart';
import 'package:car_assistant/features/profile/presentation/providers/profile_providers.dart';
import 'package:car_assistant/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:car_assistant/features/shell/presentation/pages/app_shell.dart';
import 'package:car_assistant/features/shell/presentation/widgets/dock_item.dart';
import 'package:car_assistant/features/shell/presentation/widgets/quick_actions_sheet.dart';
import 'package:car_assistant/features/splash/presentation/providers/splash_providers.dart';
import 'package:car_assistant/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/intervals/domain/repositories/interval_repository.dart';
import 'package:car_assistant/features/intervals/presentation/providers/interval_providers.dart';
import 'package:car_assistant/features/expenses/domain/repositories/expense_repository.dart';
import 'package:car_assistant/features/expenses/presentation/providers/expense_providers.dart';
import 'package:car_assistant/features/fuel/domain/repositories/fuel_repository.dart';
import 'package:car_assistant/features/fuel/presentation/providers/fuel_providers.dart';
import 'package:car_assistant/features/services/domain/repositories/service_repository.dart';
import 'package:car_assistant/features/services/presentation/providers/service_providers.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicle_details_page.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/add_vehicle_page.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/features/vehicles/presentation/widgets/empty_garage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../dashboard/dashboard_fixtures.dart';
import '../../../intervals/interval_fixtures.dart' as due_fixtures;
import '../../../vehicles/vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockOdometerRepository extends Mock implements OdometerRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

class MockIntervalRepository extends Mock implements IntervalRepository {}

class MockFuelRepository extends Mock implements FuelRepository {}

class MockExpenseRepository extends Mock implements ExpenseRepository {}

class MockDashboardRepository extends Mock implements DashboardRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  const delay = Duration(milliseconds: 10);

  /// Starts the real app with a complete, signed-in user and an empty garage; ends on the shell.
  Future<void> openShell(WidgetTester tester, {List<Vehicle> garage = const []}) async {
    final vehicles = MockVehicleRepository();
    final auth = MockAuthRepository();
    final odometer = MockOdometerRepository();
    final services = MockServiceRepository();
    final intervals = MockIntervalRepository();
    final fuel = MockFuelRepository();
    final expenses = MockExpenseRepository();
    final dashboards = MockDashboardRepository();
    final profile = MockProfileRepository();
    final history = MockHistoryRepository();
    registerFallbackValue(const HistoryQuery());
    when(() => history.getHistory(any()))
        .thenAnswer((_) async => const Right(HistoryResult(entries: [])));
    when(() => dashboards.getDashboard()).thenAnswer((_) async => Right(homeDashboard()));
    when(() => profile.getStats())
        .thenAnswer((_) async => const Right(ProfileStats(vehicleCount: 0, serviceCount: 0)));
    when(() => services.getCatalog()).thenAnswer((_) async => const Right([]));
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right(garage));
    for (final vehicle in garage) {
      when(() => vehicles.getVehicle(vehicle.id)).thenAnswer((_) async => Right(vehicle));
      when(() => odometer.getReadings(vehicle.id)).thenAnswer((_) async => const Right([]));
      when(() => services.getVisits(vehicle.id)).thenAnswer((_) async => const Right([]));
      when(() => fuel.getLogs(vehicle.id)).thenAnswer((_) async => const Right([]));
      when(() => expenses.getExpenses(vehicle.id)).thenAnswer((_) async => const Right([]));
      when(() => intervals.getDue(vehicle.id))
          .thenAnswer((_) async => Right(due_fixtures.allOkReport));
    }
    when(() => vehicles.getCatalog()).thenAnswer((_) async => const Right([]));
    when(() => auth.hasSession()).thenAnswer((_) async => true);
    when(() => auth.getCurrentUser()).thenAnswer(
      (_) async => Right(
        User(
          id: 'u1',
          phone: '09121234567',
          createdAt: DateTime.utc(2026),
          isProfileComplete: true,
        ),
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          odometerRepositoryProvider.overrideWithValue(odometer),
          serviceRepositoryProvider.overrideWithValue(services),
          intervalRepositoryProvider.overrideWithValue(intervals),
          fuelRepositoryProvider.overrideWithValue(fuel),
          expenseRepositoryProvider.overrideWithValue(expenses),
          dashboardRepositoryProvider.overrideWithValue(dashboards),
          profileRepositoryProvider.overrideWithValue(profile),
          historyRepositoryProvider.overrideWithValue(history),
          authRepositoryProvider.overrideWithValue(auth),
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
    await tester.pump(delay);
    await tester.pumpAndSettle();
    expect(find.byType(AppShell), findsOneWidget);
  }

  Finder appBarTitle(String title) => find.descendant(
    of: find.byWidgetPredicate(
      (w) => w is MainAppBar || w is HomeAppBar || w is ProfileAppBar || w is HistoryAppBar,
    ),
    matching: find.text(title),
  );

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(find.descendant(of: find.byType(DockItem), matching: find.text(label)));
    await tester.pumpAndSettle();
  }

  testWidgets('lands on Home with four tabs and the add button', (tester) async {
    await openShell(tester);

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(DockItem), findsNWidgets(4));
    for (final label in ['خانه', 'گاراژ من', 'تاریخچه', 'پروفایل']) {
      expect(
        find.descendant(of: find.byType(DockItem), matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(find.byTooltip('ثبت سریع'), findsOneWidget);
    expect(appBarTitle('خانه'), findsOneWidget);
  });

  testWidgets('Home and Garage both show the empty garage', (tester) async {
    await openShell(tester);
    expect(
      find.descendant(of: find.byType(HomePage), matching: find.byType(EmptyGarage)),
      findsOneWidget,
    );

    await tapTab(tester, 'گاراژ من');

    expect(find.byType(VehiclesPage), findsOneWidget);
    expect(
      find.descendant(of: find.byType(VehiclesPage), matching: find.byType(EmptyGarage)),
      findsOneWidget,
    );
    expect(appBarTitle('گاراژ من'), findsOneWidget);
  });

  testWidgets('only the Garage app bar shows the vehicle count, in Persian digits', (tester) async {
    await openShell(tester);
    expect(appBarTitle('۰ خودرو'), findsNothing);

    await tapTab(tester, 'گاراژ من');

    expect(appBarTitle('۰ خودرو'), findsOneWidget);
    expect(find.text('۰ خودرو'), findsOneWidget); // no second heading in the page
  });

  testWidgets('switching tabs swaps the page and the app bar title', (tester) async {
    await openShell(tester);

    await tapTab(tester, 'تاریخچه');
    expect(find.byType(HistoryPage), findsOneWidget);
    expect(appBarTitle('تاریخچه'), findsOneWidget);

    await tapTab(tester, 'پروفایل');
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(appBarTitle('پروفایل'), findsOneWidget);

    await tapTab(tester, 'خانه');
    expect(find.byType(HomePage), findsOneWidget);
    expect(appBarTitle('خانه'), findsOneWidget);
  });

  testWidgets('the selected tab is marked selected', (tester) async {
    await openShell(tester);
    bool selected(String label) => tester
        .widget<DockItem>(find.ancestor(of: find.text(label), matching: find.byType(DockItem)))
        .selected;

    expect(selected('خانه'), isTrue);
    expect(selected('گاراژ من'), isFalse);

    await tapTab(tester, 'گاراژ من');

    expect(selected('خانه'), isFalse);
    expect(selected('گاراژ من'), isTrue);
  });

  testWidgets('the dock add button opens quick actions; add vehicle opens its page', (
    tester,
  ) async {
    await openShell(tester);

    await tester.tap(find.byTooltip('ثبت سریع'));
    await tester.pumpAndSettle();
    expect(find.byType(QuickActionsSheet), findsOneWidget);

    await tester.tap(find.text('افزودن خودروی جدید'));
    await tester.pumpAndSettle();

    expect(find.byType(QuickActionsSheet), findsNothing);
    expect(find.byType(AddVehiclePage), findsOneWidget);
    expect(find.byType(DockItem), findsNothing);

    await tester.tap(find.byTooltip('بازگشت'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('the empty garage add button opens the add-vehicle page', (tester) async {
    await openShell(tester);

    await tester.tap(find.text('افزودن خودرو'));
    await tester.pumpAndSettle();

    expect(find.byType(AddVehiclePage), findsOneWidget);
  });

  testWidgets(
    'with vehicles, Home is the dashboard and a vehicle chip opens it in the Garage tab',
    (tester) async {
      await openShell(tester, garage: [tara]);
      expect(find.text('هزینه کل امسال'), findsOneWidget);

      await tester.tap(find.text('تارا اتوماتیک نقره‌ای').first);
      await tester.pumpAndSettle();

      expect(find.byType(VehicleDetailsPage), findsOneWidget);
      bool selected(String label) => tester
          .widget<DockItem>(find.ancestor(of: find.text(label), matching: find.byType(DockItem)))
          .selected;
      expect(selected('گاراژ من'), isTrue);

      await tester.tap(find.byTooltip('بازگشت'));
      await tester.pumpAndSettle();
      expect(find.byType(VehiclesPage), findsOneWidget);
    },
  );

  testWidgets('tapping a garage vehicle opens its details inside the Garage tab', (tester) async {
    await openShell(tester, garage: [tara]);
    await tapTab(tester, 'گاراژ من');

    await tester.tap(find.text('تارا اتوماتیک نقره‌ای'));
    await tester.pumpAndSettle();

    expect(find.byType(VehicleDetailsPage), findsOneWidget);
    expect(find.byType(DockItem), findsNWidgets(4));
    expect(find.text('جزئیات خودرو'), findsOneWidget);
  });
}
