import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/router/app_routes.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/expenses/domain/repositories/expense_repository.dart';
import 'package:car_assistant/features/expenses/presentation/providers/expense_providers.dart';
import 'package:car_assistant/features/fuel/domain/repositories/fuel_repository.dart';
import 'package:car_assistant/features/fuel/presentation/providers/fuel_providers.dart';
import 'package:car_assistant/features/intervals/domain/repositories/interval_repository.dart';
import 'package:car_assistant/features/intervals/presentation/providers/interval_providers.dart';
import 'package:car_assistant/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/odometer/presentation/widgets/odometer_sheet.dart';
import 'package:car_assistant/features/services/domain/repositories/service_repository.dart';
import 'package:car_assistant/features/services/presentation/providers/service_providers.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/vehicle_details_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../expenses/expense_fixtures.dart' as expense_fixtures;
import '../../../fuel/fuel_fixtures.dart' as fuel_fixtures;
import '../../../intervals/interval_fixtures.dart' as due_fixtures;
import '../../../odometer/odometer_fixtures.dart';
import '../../../services/service_fixtures.dart' as services_fixtures;
import '../../vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockOdometerRepository extends Mock implements OdometerRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

class MockIntervalRepository extends Mock implements IntervalRepository {}

class MockFuelRepository extends Mock implements FuelRepository {}

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late MockOdometerRepository odometer;
  late MockServiceRepository services;
  late MockIntervalRepository intervals;
  late MockFuelRepository fuel;
  late MockExpenseRepository expenses;

  setUp(() {
    vehicles = MockVehicleRepository();
    odometer = MockOdometerRepository();
    services = MockServiceRepository();
    intervals = MockIntervalRepository();
    fuel = MockFuelRepository();
    expenses = MockExpenseRepository();
    when(() => fuel.getLogs('v1')).thenAnswer((_) async => const Right([]));
    when(() => expenses.getExpenses('v1')).thenAnswer((_) async => const Right([]));
    when(() => intervals.getDue('v1')).thenAnswer((_) async => Right(due_fixtures.allOkReport));
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([tara]));
    when(() => odometer.getReadings('v1')).thenAnswer((_) async => const Right([]));
    when(() => services.getCatalog(vehicleId: any(named: 'vehicleId')))
        .thenAnswer((_) async => const Right(services_fixtures.serviceCatalog));
    when(() => services.getVisits('v1')).thenAnswer((_) async => const Right([]));
  });

  Finder semantics(String label) =>
      find.byWidgetPredicate((w) => w is Semantics && w.properties.label == label);

  Future<void> openPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const VehicleDetailsPage(vehicleId: 'v1'),
        ),
        GoRoute(
          path: AppRoutes.editVehiclePath,
          builder: (context, state) => Text('editing ${(state.extra! as Vehicle).id}'),
        ),
        GoRoute(
          path: '/vehicles/:id/services/:serviceId',
          builder: (context, state) => Text('service ${state.pathParameters['serviceId']}'),
        ),
        GoRoute(path: '/vehicles/:id/due', builder: (context, state) => const Text('due page')),
        GoRoute(
          path: '/vehicles/:id/transfer',
          builder: (context, state) => Text('transfer ${state.pathParameters['id']}'),
        ),
        GoRoute(
          path: AppRoutes.reportExportPath,
          builder: (context, state) => Text('report ${state.uri.queryParameters['vehicleId']}'),
        ),
        GoRoute(
          path: '/vehicles/:id/intervals',
          builder: (context, state) => const Text('intervals page'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          odometerRepositoryProvider.overrideWithValue(odometer),
          serviceRepositoryProvider.overrideWithValue(services),
          intervalRepositoryProvider.overrideWithValue(intervals),
          fuelRepositoryProvider.overrideWithValue(fuel),
          expenseRepositoryProvider.overrideWithValue(expenses),
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
    await tester.pumpAndSettle();
  }

  testWidgets('shows the vehicle, its plate and mileage in Persian', (tester) async {
    await openPage(tester);

    expect(find.text('جزئیات خودرو'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.text('مدل ۱۴۰۲ • ایران خودرو • تارا • V4 اتوماتیک - فول آپشن'), findsOneWidget);
    expect(find.text('شاسی: $validVin'), findsOneWidget);
    expect(semantics('۷۲ ب ۳۴۵ ایران ۶۸'), findsOneWidget);
    expect(semantics('فعال در گاراژ'), findsOneWidget);
    expect(find.text('۳۴٬۵۰۰'), findsOneWidget);
    expect(find.text('بروزرسانی کیلومتر'), findsOneWidget);
    // No reading yet: no date badge.
    expect(find.byIcon(Icons.check_circle_outline), findsNothing);
  });

  testWidgets('sections without data show empty states, no made-up numbers', (tester) async {
    await openPage(tester);

    expect(find.text('وضعیت و سرویس‌های پیش‌رو'), findsOneWidget);
    expect(find.text('هنوز موردی برای پیگیری ثبت نشده است'), findsOneWidget);
    expect(find.text('تاریخچه آخرین خدمات و سرویس‌ها'), findsOneWidget);
    expect(find.text('هنوز سرویسی برای این خودرو ثبت نشده است'), findsOneWidget);
    expect(find.text('آخرین سوخت‌گیری‌ها'), findsOneWidget);
    expect(find.text('هنوز سوخت‌گیری برای این خودرو ثبت نشده است'), findsOneWidget);
    expect(find.text('آخرین هزینه‌ها'), findsOneWidget);
    expect(find.text('هنوز هزینه‌ای برای این خودرو ثبت نشده است'), findsOneWidget);
  });

  testWidgets('the options menu opens the ownership transfer', (tester) async {
    await openPage(tester);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('انتقال مالکیت'));
    await tester.pumpAndSettle();

    expect(find.text('transfer v1'), findsOneWidget);
  });

  testWidgets('the report button opens the report export for this vehicle', (tester) async {
    await openPage(tester);

    await tester.ensureVisible(find.text('دریافت کارنامه و گزارش فاکتورها (PDF)'));
    await tester.tap(find.text('دریافت کارنامه و گزارش فاکتورها (PDF)'));
    await tester.pumpAndSettle();

    expect(find.text('report v1'), findsOneWidget);
  });

  testWidgets('lists the pending due items; tapping one opens the due page', (tester) async {
    when(() => intervals.getDue('v1')).thenAnswer((_) async => Right(due_fixtures.dueReport));

    await openPage(tester);

    expect(find.text('هنوز موردی برای پیگیری ثبت نشده است'), findsNothing);
    expect(find.text('تعویض روغن موتور و فیلترها'), findsOneWidget);
    expect(find.text('۳۵۰ کیلومتر گذشته از موعد'), findsOneWidget);
    expect(find.text('رسیدگی فوری'), findsOneWidget);
    expect(find.text('نزدیک به موعد'), findsOneWidget);
    expect(find.text('اطلاعیه'), findsOneWidget);
    expect(find.text('مایع خنک‌کننده'), findsNothing);

    await tester.tap(find.text('تعویض روغن موتور و فیلترها'));
    await tester.pumpAndSettle();

    expect(find.text('due page'), findsOneWidget);
  });

  testWidgets('the due section settings action opens the intervals page', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('تنظیم'));
    await tester.pumpAndSettle();

    expect(find.text('intervals page'), findsOneWidget);
  });

  testWidgets('lists the last service visits and opens one', (tester) async {
    when(() => services.getVisits('v1'))
        .thenAnswer((_) async => Right([services_fixtures.visit(withInvoice: true)]));

    await openPage(tester);

    expect(find.text('هنوز سرویسی برای این خودرو ثبت نشده است'), findsNothing);
    expect(find.text('روغن موتور و ۱ مورد دیگر'), findsOneWidget);
    expect(find.textContaining('۲٬۱۳۰٬۰۰۰ تومان'), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);

    await tester.tap(find.text('روغن موتور و ۱ مورد دیگر'));
    await tester.pumpAndSettle();

    expect(find.text('service s1'), findsOneWidget);
  });

  testWidgets('lists the latest fill-ups and expenses', (tester) async {
    when(() => fuel.getLogs('v1'))
        .thenAnswer((_) async => Right([fuel_fixtures.contractFuelLog()]));
    when(() => expenses.getExpenses('v1'))
        .thenAnswer((_) async => Right([expense_fixtures.expense(withAttachment: true)]));

    await openPage(tester);

    expect(find.text('هنوز سوخت‌گیری برای این خودرو ثبت نشده است'), findsNothing);
    expect(find.text('سوپر • ۴۸٫۵ لیتر'), findsOneWidget);
    expect(find.textContaining('۳۴٬۸۵۰ کیلومتر • ۱۴۵٬۵۰۰ تومان'), findsOneWidget);
    expect(find.text('۷٫۴۶ لیتر/۱۰۰ ک‌م'), findsOneWidget);
    expect(find.text('هنوز هزینه‌ای برای این خودرو ثبت نشده است'), findsNothing);
    expect(find.text('تمدید بیمه‌نامه شخص ثالث ۱۲ ماهه ایران'), findsOneWidget);
    expect(find.textContaining('۵٬۸۵۰٬۰۰۰ تومان'), findsOneWidget);
    expect(find.byIcon(Icons.attach_file), findsOneWidget);
  });

  testWidgets('shows the date of the latest reading', (tester) async {
    when(() => odometer.getReadings('v1')).thenAnswer((_) async => Right([reading]));

    await openPage(tester);

    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    expect(find.textContaining('مهر ۱۴۰۵'), findsOneWidget);
  });

  testWidgets('the update mileage button opens the odometer sheet', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('بروزرسانی کیلومتر'));
    await tester.pumpAndSettle();

    expect(find.byType(OdometerSheet), findsOneWidget);
    expect(find.text('آخرین ثبت: ۳۴٬۵۰۰ کیلومتر'), findsOneWidget);
  });

  testWidgets('the options menu opens the edit page for the vehicle', (tester) async {
    await openPage(tester);

    await tester.tap(find.byTooltip('تنظیمات خودرو'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ویرایش خودرو'));
    await tester.pumpAndSettle();

    expect(find.text('editing v1'), findsOneWidget);
  });

  testWidgets('shows an error and retries', (tester) async {
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Left(Failure('boom')));
    await openPage(tester);
    expect(find.text('دریافت اطلاعات خودرو ممکن نشد'), findsOneWidget);

    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    await tester.tap(find.text('تلاش دوباره'));
    await tester.pumpAndSettle();

    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
  });
}
