import 'package:car_assistant/app.dart';
import 'package:car_assistant/core/widgets/main_app_bar.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/history/presentation/pages/history_page.dart';
import 'package:car_assistant/features/home/presentation/pages/home_page.dart';
import 'package:car_assistant/features/profile/presentation/pages/profile_page.dart';
import 'package:car_assistant/features/shell/presentation/pages/app_shell.dart';
import 'package:car_assistant/features/shell/presentation/widgets/dock_item.dart';
import 'package:car_assistant/features/splash/presentation/providers/splash_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/add_vehicle_page.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/features/vehicles/presentation/widgets/empty_garage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const delay = Duration(milliseconds: 10);

  /// Starts the real app with a complete, signed-in user and an empty garage; ends on the shell.
  Future<void> openShell(WidgetTester tester) async {
    final vehicles = MockVehicleRepository();
    final auth = MockAuthRepository();
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([]));
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

  Finder appBarTitle(String title) =>
      find.descendant(of: find.byType(MainAppBar), matching: find.text(title));

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

  testWidgets('the dock add button opens the add-vehicle page above the tabs', (tester) async {
    await openShell(tester);

    await tester.tap(find.byTooltip('ثبت سریع'));
    await tester.pumpAndSettle();

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
}
