import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/services/domain/entities/new_service_visit.dart';
import 'package:car_assistant/features/services/domain/entities/service_failures.dart';
import 'package:car_assistant/features/services/domain/entities/service_field.dart';
import 'package:car_assistant/features/services/domain/entities/service_line_item.dart';
import 'package:car_assistant/features/services/domain/entities/service_suggestions.dart';
import 'package:car_assistant/features/services/domain/repositories/service_repository.dart';
import 'package:car_assistant/features/services/presentation/pages/new_service_page.dart';
import 'package:car_assistant/features/services/presentation/providers/service_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../service_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockOdometerRepository extends Mock implements OdometerRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late MockOdometerRepository odometer;
  late MockServiceRepository services;
  final now = DateTime(2026, 10, 21, 18, 45); // چهارشنبه ۲۹ مهر ۱۴۰۵

  setUpAll(() {
    registerFallbackValue(
      NewServiceVisit(serviceDate: now, odometerKm: 0, workshop: 'x', lineItems: const []),
    );
  });

  setUp(() {
    vehicles = MockVehicleRepository();
    odometer = MockOdometerRepository();
    services = MockServiceRepository();
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => odometer.getReadings('v1')).thenAnswer((_) async => const Right([]));
    when(() => services.getCatalog()).thenAnswer((_) async => const Right(serviceCatalog));
    when(() => services.getSuggestions())
        .thenAnswer((_) async => const Right(ServiceSuggestions.empty));
  });

  Future<void> openPage(WidgetTester tester, {List<String> preselected = const []}) async {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              NewServicePage(vehicleId: 'v1', preselectedItemIds: preselected),
        ),
        GoRoute(
          path: '/vehicles/:id/services/:serviceId',
          builder: (context, state) =>
              Scaffold(body: Text('details ${state.pathParameters['serviceId']}')),
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
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  ButtonStyleButton buttonWithText(WidgetTester tester, String text) => tester.widget(
    find.ancestor(
      of: find.text(text),
      matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
    ),
  );

  /// Ticks oil and filter on step 1 and continues to step 2.
  Future<void> goToStep2(WidgetTester tester) async {
    await openPage(tester);
    await tapText(tester, 'روغن موتور');
    await tapText(tester, 'فیلتر روغن');
    await tapText(tester, 'ادامه به گام دوم (زمان و کارکرد)');
  }

  group('step 1', () {
    testWidgets('lists the catalog and enables continue once an item is ticked', (tester) async {
      await openPage(tester);

      expect(find.text('ثبت سرویس جدید'), findsOneWidget);
      expect(find.text('روغن و مایعات مصرفی'), findsOneWidget);
      expect(find.text('ترمز و ایمنی'), findsOneWidget);
      expect(find.text('لنت ترمز جلو'), findsOneWidget);
      expect(find.text('۰ مورد انتخاب شد'), findsOneWidget);
      expect(buttonWithText(tester, 'ادامه به گام دوم (زمان و کارکرد)').onPressed, isNull);

      await tapText(tester, 'روغن موتور');

      expect(find.text('۱ مورد انتخاب شد'), findsOneWidget);
      expect(find.text('۱ سرویس انتخاب شده'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(buttonWithText(tester, 'ادامه به گام دوم (زمان و کارکرد)').onPressed, isNotNull);

      await tapText(tester, 'پاکسازی همه');
      expect(find.text('۰ مورد انتخاب شد'), findsOneWidget);
    });

    testWidgets('search filters the tiles and empty categories', (tester) async {
      await openPage(tester);

      await tester.enterText(find.byType(TextField), 'لنت');
      await tester.pumpAndSettle();

      expect(find.text('لنت ترمز جلو'), findsOneWidget);
      expect(find.text('روغن موتور'), findsNothing);
      expect(find.text('روغن و مایعات مصرفی'), findsNothing);

      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pumpAndSettle();
      expect(find.text('سرویسی با این نام پیدا نشد'), findsOneWidget);
    });

    testWidgets('preselected items are ticked', (tester) async {
      await openPage(tester, preselected: ['engine_oil']);

      expect(find.text('۱ مورد انتخاب شد'), findsOneWidget);
    });
  });

  group('step 2', () {
    testWidgets('shows the items, the mileage with quick adjust and the date chips', (
      tester,
    ) async {
      await goToStep2(tester);

      expect(find.text('اقلام انتخاب‌شده برای فاکتور:'), findsOneWidget);
      expect(find.text('روغن موتور'), findsOneWidget);
      expect(find.text('فیلتر روغن'), findsOneWidget);
      expect(tester.widget<TextField>(find.byType(TextField).first).controller!.text, '۳۴٬۵۰۰');
      expect(find.text('آخرین ثبت: ۳۴٬۵۰۰ کیلومتر'), findsOneWidget);
      expect(find.text('چهارشنبه، ۲۹ مهر ۱۴۰۵'), findsOneWidget);
      expect(find.text('۱۸:۴۵'), findsOneWidget);

      await tapText(tester, '+۵۰۰');
      expect(tester.widget<TextField>(find.byType(TextField).first).controller!.text, '۳۵٬۰۰۰');
      expect(find.text('+۵۰۰ کیلومتر پیمایش'), findsOneWidget);

      await tapText(tester, 'دیروز');
      expect(find.text('سه‌شنبه، ۲۸ مهر ۱۴۰۵'), findsOneWidget);

      await tapText(tester, 'هفته گذشته');
      expect(find.text('چهارشنبه، ۲۲ مهر ۱۴۰۵'), findsOneWidget);
    });

    testWidgets('edit items goes back to step 1 keeping the selection', (tester) async {
      await goToStep2(tester);

      await tapText(tester, 'ویرایش اقلام');

      expect(find.text('۲ مورد انتخاب شد'), findsOneWidget);
    });
  });

  group('step 3', () {
    testWidgets('prefills the oil reminder from the sticker, sums the costs and saves', (
      tester,
    ) async {
      when(() => services.createVisit('v1', any())).thenAnswer((_) async => Right(visit()));
      await goToStep2(tester);
      await tapText(tester, '+۵۰۰');
      await tester.enterText(find.byType(TextField).at(1), '42000'); // sticker
      await tapText(tester, 'ادامه به گام سوم (جزئیات و هزینه‌ها)');

      expect(find.text('قلم ۱ از ۲'), findsOneWidget);
      expect(find.text('قلم ۲ از ۲'), findsOneWidget);
      expect(find.text('۳۵٬۰۰۰ کیلومتر'), findsOneWidget);
      // One shared card for the workshop and the invoice; no per-item copies.
      expect(find.text('اطلاعات مشترک فاکتور'), findsOneWidget);
      expect(find.text('تعمیرگاه / اتوسرویس'), findsOneWidget);
      expect(find.text('افزودن تصویر فاکتور'), findsOneWidget);
      expect(find.text('مشترک'), findsNothing);
      // Sticker 42,000 − odometer 35,000 = 7,000 km after this visit, due at 42,000.
      expect(find.text('سررسید: ۴۲٬۰۰۰ ک‌م'), findsOneWidget);

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'اتوسرویس البرز'); // workshop, on the shared card
      await tester.enterText(fields.at(1), '1850000'); // cost of item 1
      await tester.pumpAndSettle();
      expect(find.text('۱٬۸۵۰٬۰۰۰'), findsNWidgets(2)); // field and running total
      expect(find.text('جمع کل فاکتور (۲ قلم)'), findsOneWidget);

      await tapText(tester, 'ثبت نهایی فاکتور و ذخیره سوابق');

      final sent =
          verify(() => services.createVisit('v1', captureAny())).captured.single as NewServiceVisit;
      expect(sent.odometerKm, 35000);
      expect(sent.workshop, 'اتوسرویس البرز');
      expect(sent.serviceDate, now);
      expect(sent.lineItems, const [
        ServiceLineItem(itemId: 'engine_oil', cost: 1850000, nextDueKm: 7000),
        ServiceLineItem(itemId: 'oil_filter', cost: 0),
      ]);
      expect(find.text('details s1'), findsOneWidget);
      expect(find.text('سرویس با موفقیت ثبت شد'), findsOneWidget);
    });

    testWidgets('a missing workshop shows an inline error and sends nothing', (tester) async {
      await goToStep2(tester);
      await tapText(tester, 'ادامه به گام سوم (جزئیات و هزینه‌ها)');

      await tapText(tester, 'ثبت نهایی فاکتور و ذخیره سوابق');

      expect(find.text('نام تعمیرگاه را وارد کنید (حداکثر ۱۰۰ حرف)'), findsOneWidget);
      verifyNever(() => services.createVisit(any(), any()));
    });

    testWidgets('server field errors show inline; a 400 on serviceDate shows the date message', (
      tester,
    ) async {
      when(() => services.createVisit('v1', any())).thenAnswer(
        (_) async =>
            const Left(InvalidServiceFailure({ServiceField.workshop, ServiceField.lineItems})),
      );
      await goToStep2(tester);
      await tapText(tester, 'ادامه به گام سوم (جزئیات و هزینه‌ها)');
      await tester.enterText(find.byType(TextField).at(0), 'x');
      await tester.pumpAndSettle();

      await tapText(tester, 'ثبت نهایی فاکتور و ذخیره سوابق');
      expect(find.text('نام تعمیرگاه را وارد کنید (حداکثر ۱۰۰ حرف)'), findsOneWidget);
      expect(find.text('مقادیر این قلم نامعتبر است، آن را بررسی کنید'), findsNWidgets(2));

      when(() => services.createVisit('v1', any()))
          .thenAnswer((_) async => const Left(InvalidServiceFailure({ServiceField.serviceDate})));
      await tester.pump(const Duration(seconds: 5)); // let the snackbar go
      await tester.pumpAndSettle();
      await tapText(tester, 'ثبت نهایی فاکتور و ذخیره سوابق');
      expect(find.text('تاریخ و ساعت سرویس نمی‌تواند در آینده باشد'), findsOneWidget);
    });

    testWidgets('workshop and brand offer the names used before and fill on tap', (tester) async {
      when(() => services.getSuggestions()).thenAnswer(
        (_) async => const Right(
          ServiceSuggestions(
            workshops: ['اتوسرویس البرز', 'تعمیرگاه مرکزی'],
            brands: {
              'engine_oil': ['بهران رانا 5W-40'],
            },
          ),
        ),
      );
      when(() => services.createVisit('v1', any())).thenAnswer((_) async => Right(visit()));
      await goToStep2(tester);
      await tapText(tester, 'ادامه به گام سوم (جزئیات و هزینه‌ها)');

      // Nothing is offered until the field has focus; then the recent names, filtered as typed.
      expect(find.text('تعمیرگاه مرکزی'), findsNothing);
      await tester.tap(find.byType(TextField).at(0));
      await tester.pumpAndSettle();
      expect(find.text('تعمیرگاه مرکزی'), findsOneWidget);
      await tester.enterText(find.byType(TextField).at(0), 'الب');
      await tester.pumpAndSettle();
      expect(find.text('اتوسرویس البرز'), findsOneWidget);
      expect(find.text('تعمیرگاه مرکزی'), findsNothing);
      await tapText(tester, 'اتوسرویس البرز');
      expect(
        tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
        'اتوسرویس البرز',
      );

      // Brand of the first item (engine_oil): cost is at 1, brand at 2.
      await tester.enterText(find.byType(TextField).at(2), 'بهران');
      await tester.pumpAndSettle();
      await tapText(tester, 'بهران رانا 5W-40');

      await tapText(tester, 'ثبت نهایی فاکتور و ذخیره سوابق');
      final sent =
          verify(() => services.createVisit('v1', captureAny())).captured.single as NewServiceVisit;
      expect(sent.workshop, 'اتوسرویس البرز');
      expect(sent.lineItems.first.brand, 'بهران رانا 5W-40');
    });

    testWidgets('removing a card drops the item; add another returns to step 1', (tester) async {
      await goToStep2(tester);
      await tapText(tester, 'ادامه به گام سوم (جزئیات و هزینه‌ها)');

      await tester.tap(find.byTooltip('حذف سرویس').last);
      await tester.pumpAndSettle();
      expect(find.text('قلم ۱ از ۱'), findsOneWidget);

      await tapText(tester, 'افزودن یک قلم سرویس دیگر به این فاکتور');
      expect(find.text('۱ مورد انتخاب شد'), findsOneWidget);
    });
  });

  testWidgets('the app bar back goes to the previous step before leaving', (tester) async {
    await goToStep2(tester);

    await tester.tap(find.byTooltip('بازگشت'));
    await tester.pumpAndSettle();

    expect(find.text('۲ مورد انتخاب شد'), findsOneWidget);
  });
}
