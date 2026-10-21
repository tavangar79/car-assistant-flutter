import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_failures.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_field.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_payment_method.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_type.dart';
import 'package:car_assistant/features/fuel/domain/entities/new_fuel_log.dart';
import 'package:car_assistant/features/fuel/domain/repositories/fuel_repository.dart';
import 'package:car_assistant/features/fuel/presentation/pages/new_fuel_page.dart';
import 'package:car_assistant/features/fuel/presentation/providers/fuel_providers.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../fuel_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockFuelRepository extends Mock implements FuelRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late MockFuelRepository fuel;
  final now = DateTime(2026, 10, 21, 18, 45); // چهارشنبه ۲۹ مهر ۱۴۰۵

  setUpAll(() {
    registerFallbackValue(
      NewFuelLog(
        fueledAt: now,
        odometerKm: 0,
        fuelType: FuelType.regular,
        volume: 1,
        totalCost: 0,
        isFullFill: true,
      ),
    );
  });

  setUp(() {
    vehicles = MockVehicleRepository();
    fuel = MockFuelRepository();
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => fuel.getLogs('v1')).thenAnswer((_) async => const Right([]));
  });

  /// Opens the page pushed above a home screen, so a successful save pops back to it.
  Future<void> openPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          fuelRepositoryProvider.overrideWithValue(fuel),
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
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => const NewFuelPage(vehicleId: 'v1'))),
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

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  /// The text fields in page order: odometer, volume, cost, station, notes.
  Finder field(int index) => find.byType(TextField).at(index);

  String fieldText(WidgetTester tester, int index) =>
      tester.widget<TextField>(field(index)).controller!.text;

  testWidgets('shows the vehicle, the defaults and the sections of the screen', (tester) async {
    await openPage(tester);

    expect(find.text('ثبت سوخت‌گیری'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.text('هنوز سوخت‌گیری ثبت نشده است'), findsOneWidget);
    expect(find.text('چهارشنبه، ۲۹ مهر ۱۴۰۵'), findsOneWidget);
    expect(find.text('۱۸:۴۵'), findsOneWidget);
    expect(fieldText(tester, 0), '۳۴٬۵۰۰');
    expect(find.text('سند ثبت‌شده قبلی: ۳۴٬۵۰۰'), findsOneWidget);
    for (final label in [
      'امروز',
      'دیروز',
      'انتخاب تاریخ دیگر',
      '+۵۰',
      '+۱۰۰',
      '+۵۰۰',
      'معمولی',
      'سوپر',
      'CNG',
      'LPG',
      'حجم سوخت‌گیری',
      'مبلغ کل پرداختی',
      'نرخ محاسبه‌شده:',
      'باک کاملاً پر شد (باک پر)',
      'میانگین مصرف این دوره:',
      'جایگاه سوخت',
      'روش پرداخت و سهمیه',
      'انتخاب روش پرداخت',
      'یادداشت (اختیاری)',
      'ثبت سوخت‌گیری و ذخیره',
      'انصراف و بازگشت',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    // No previous fill-up: the rate and the economy can't be computed, no distance line.
    expect(find.text('قابل محاسبه نیست'), findsNWidgets(2));
    expect(find.textContaining('پیمایش از باک قبل'), findsNothing);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('the header shows the last fill-up; chips adjust the odometer and the date', (
    tester,
  ) async {
    when(() => fuel.getLogs('v1')).thenAnswer(
      (_) async => Right([fuelLog(odometerKm: 34200, fueledAt: DateTime.utc(2026, 10, 15, 9))]),
    );
    await openPage(tester);

    expect(find.text('آخرین سوخت‌گیری: ۲۳ مهر ۱۴۰۵ • ۳۴٬۲۰۰ کیلومتر (باک پر)'), findsOneWidget);
    expect(find.text('+۳۰۰ کیلومتر پیمایش از باک قبل'), findsOneWidget);

    await tapText(tester, '+۵۰۰');
    expect(fieldText(tester, 0), '۳۵٬۰۰۰');
    expect(find.text('+۸۰۰ کیلومتر پیمایش از باک قبل'), findsOneWidget);

    await tapText(tester, 'دیروز');
    expect(find.text('سه‌شنبه، ۲۸ مهر ۱۴۰۵'), findsOneWidget);
    await tapText(tester, 'امروز');
    expect(find.text('چهارشنبه، ۲۹ مهر ۱۴۰۵'), findsOneWidget);
  });

  testWidgets('computes the rate and the economy preview from the previous full fill', (
    tester,
  ) async {
    when(() => fuel.getLogs('v1')).thenAnswer((_) async => Right([fuelLog(odometerKm: 34200)]));
    await openPage(tester);

    await tester.enterText(field(1), '48.5');
    await tester.enterText(field(2), '145500');
    await tester.pumpAndSettle();

    expect(fieldText(tester, 1), '۴۸٫۵');
    expect(find.text('۳٬۰۰۰ تومان / لیتر'), findsOneWidget);
    // 48.5 L over 34,500 − 34,200 = 300 km.
    expect(find.textContaining('۱۶٫۱۷'), findsOneWidget);
    expect(find.textContaining('لیتر در ۱۰۰ کیلومتر'), findsOneWidget);
    expect(
      find.text('۳۰۰ کیلومتر پیمایش با ۴۸٫۵ لیتر سوخت (از باک پر قبلی تا الان)'),
      findsOneWidget,
    );
    expect(find.text('قابل محاسبه نیست'), findsNothing);

    // Another fuel type than the previous full fill: not computable.
    await tapText(tester, 'سوپر');
    expect(find.text('قابل محاسبه نیست'), findsOneWidget);

    // CNG is measured in cubic metres.
    await tapText(tester, 'CNG');
    expect(find.text('۳٬۰۰۰ تومان / متر مکعب'), findsOneWidget);

    // A partial fill is never computable.
    await tapText(tester, 'معمولی');
    expect(find.textContaining('۱۶٫۱۷'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.text('قابل محاسبه نیست'), findsOneWidget);
  });

  testWidgets('a missing volume and cost show inline errors and send nothing', (tester) async {
    await openPage(tester);

    await tapText(tester, 'ثبت سوخت‌گیری و ذخیره');

    expect(find.text('حجم سوخت را وارد کنید (بیشتر از ۰ و حداکثر ۱٬۰۰۰)'), findsOneWidget);
    expect(find.text('مبلغ کل پرداختی را وارد کنید'), findsOneWidget);
    verifyNever(() => fuel.createLog(any(), any()));

    // Editing clears the error.
    await tester.enterText(field(1), '10');
    await tester.pumpAndSettle();
    expect(find.text('حجم سوخت را وارد کنید (بیشتر از ۰ و حداکثر ۱٬۰۰۰)'), findsNothing);
  });

  testWidgets('saves the fill-up with the picked payment method and goes back', (tester) async {
    when(() => fuel.createLog('v1', any())).thenAnswer((_) async => Right(contractFuelLog()));
    await openPage(tester);

    await tapText(tester, '+۱۰۰');
    await tapText(tester, 'سوپر');
    await tester.enterText(field(1), '48.5');
    await tester.enterText(field(2), '145500');
    await tester.enterText(field(3), 'جایگاه یادگار');
    await tester.enterText(field(4), 'اکتان بوستر');
    await tester.pumpAndSettle();
    await tapText(tester, 'انتخاب روش پرداخت');
    expect(find.text('کارت‌خوان جایگاه (کارت سوخت شخصی)'), findsOneWidget);
    expect(find.text('کارت سوخت جایگاه (نرخ آزاد)'), findsOneWidget);
    expect(find.text('کارت بانکی'), findsOneWidget);
    await tapText(tester, 'نقدی');
    expect(find.text('نقدی'), findsOneWidget);

    await tapText(tester, 'ثبت سوخت‌گیری و ذخیره');

    final sent = verify(() => fuel.createLog('v1', captureAny())).captured.single as NewFuelLog;
    expect(
      sent,
      NewFuelLog(
        fueledAt: now,
        odometerKm: 34600,
        fuelType: FuelType.superGrade,
        volume: 48.5,
        totalCost: 145500,
        isFullFill: true,
        station: 'جایگاه یادگار',
        paymentMethod: FuelPaymentMethod.cash,
        notes: 'اکتان بوستر',
      ),
    );
    expect(find.byType(NewFuelPage), findsNothing);
    expect(find.text('سوخت‌گیری ثبت شد'), findsOneWidget);
  });

  testWidgets('server field errors show inline; a 400 on fueledAt shows the date message', (
    tester,
  ) async {
    when(() => fuel.createLog('v1', any())).thenAnswer(
      (_) async => const Left(InvalidFuelLogFailure({FuelField.fueledAt, FuelField.station})),
    );
    await openPage(tester);
    await tester.enterText(field(1), '10');
    await tester.enterText(field(2), '30000');
    await tester.pumpAndSettle();

    await tapText(tester, 'ثبت سوخت‌گیری و ذخیره');

    expect(find.text('تاریخ و ساعت سوخت‌گیری نمی‌تواند در آینده باشد'), findsOneWidget);
    expect(find.text('نام جایگاه حداکثر ۱۰۰ حرف است'), findsOneWidget);
    expect(find.text('برخی مقادیر نامعتبر است، فرم را بررسی کنید'), findsOneWidget);
    expect(find.byType(NewFuelPage), findsOneWidget);
  });

  testWidgets('cancel goes back without saving', (tester) async {
    await openPage(tester);

    await tapText(tester, 'انصراف و بازگشت');

    expect(find.byType(NewFuelPage), findsNothing);
    verifyNever(() => fuel.createLog(any(), any()));
  });
}
