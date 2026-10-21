import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/intervals/domain/entities/interval_failures.dart';
import 'package:car_assistant/features/intervals/domain/entities/interval_setting.dart';
import 'package:car_assistant/features/intervals/domain/repositories/interval_repository.dart';
import 'package:car_assistant/features/intervals/presentation/pages/service_intervals_page.dart';
import 'package:car_assistant/features/intervals/presentation/providers/interval_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../interval_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockIntervalRepository extends Mock implements IntervalRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late MockIntervalRepository repository;

  setUp(() {
    vehicles = MockVehicleRepository();
    repository = MockIntervalRepository();
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => repository.getIntervals('v1')).thenAnswer((_) async => const Right(intervals));
  });

  Future<void> openPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          intervalRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const ServiceIntervalsPage(vehicleId: 'v1'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  String fieldText(WidgetTester tester, int index) =>
      tester.widget<TextField>(find.byType(TextField).at(index)).controller!.text;

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  testWidgets('shows the vehicle, the rule and one card per interval with its values', (
    tester,
  ) async {
    await openPage(tester);

    expect(find.text('تنظیم دوره سرویس'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.text('کارکرد فعلی: ۳۴٬۵۰۰ کیلومتر'), findsOneWidget);
    expect(find.text('قانون سررسید اولویت زمانی یا کارکرد'), findsOneWidget);
    expect(find.text('روغن موتور و فیلتر روغن'), findsOneWidget);
    expect(find.text('پیش‌فرض کارخانه: ۵٬۰۰۰ کیلومتر / ۶ ماه'), findsOneWidget);
    expect(find.text('پیش‌فرض کارخانه: ۲۵٬۰۰۰ کیلومتر / ۱۸ ماه'), findsOneWidget);
    expect(fieldText(tester, 0), '۷٬۰۰۰'); // the override, not the default
    expect(fieldText(tester, 1), '۶');
    expect(find.byTooltip('بازنشانی این مورد'), findsNWidgets(3));
  });

  testWidgets('save puts every interval with the edited values', (tester) async {
    when(() => repository.setIntervals('v1', any()))
        .thenAnswer((_) async => const Right(intervals));
    await openPage(tester);

    await tester.enterText(find.byType(TextField).at(2), '12000'); // air filter km
    await tapText(tester, 'ذخیره تنظیمات');

    verify(
      () => repository.setIntervals('v1', const [
        IntervalSetting(id: 'engine_oil', km: 7000, months: 6),
        IntervalSetting(id: 'air_filter', km: 12000, months: 6),
        IntervalSetting(id: 'front_brake_pads', km: 25000, months: 18),
      ]),
    ).called(1);
    expect(find.text('تنظیمات دوره‌های سرویس با موفقیت ثبت شد'), findsOneWidget);
  });

  testWidgets('a value outside the limits shows an inline error and sends nothing', (tester) async {
    await openPage(tester);

    await tester.enterText(find.byType(TextField).at(0), '100');
    await tapText(tester, 'ذخیره تنظیمات');

    expect(find.text('کیلومتر را بین ۵۰۰ تا ۲۰۰٬۰۰۰ وارد کنید'), findsOneWidget);
    verifyNever(() => repository.setIntervals(any(), any()));
  });

  testWidgets('the row reset puts the factory default back', (tester) async {
    await openPage(tester);

    await tester.tap(find.byTooltip('بازنشانی این مورد').first);
    await tester.pumpAndSettle();

    expect(fieldText(tester, 0), '۵٬۰۰۰');
  });

  testWidgets('reset all asks first, then deletes the overrides', (tester) async {
    when(() => repository.resetIntervals('v1')).thenAnswer((_) async => const Right(intervals));
    await openPage(tester);

    await tapText(tester, 'بازنشانی همه');
    expect(find.text('بازنشانی همه دوره‌ها؟'), findsOneWidget);
    await tapText(tester, 'بازنشانی');

    verify(() => repository.resetIntervals('v1')).called(1);
    expect(find.text('تمام مقادیر به پیش‌فرض کارخانه بازگشتند'), findsOneWidget);
  });

  testWidgets('a 400 from the server shows the invalid snackbar', (tester) async {
    when(() => repository.setIntervals('v1', any()))
        .thenAnswer((_) async => const Left(InvalidIntervalsFailure({})));
    await openPage(tester);

    await tapText(tester, 'ذخیره تنظیمات');

    expect(find.text('مقادیر دوره‌ها نامعتبر است، فیلدها را بررسی کنید'), findsOneWidget);
  });
}
