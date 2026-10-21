import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/intervals/domain/repositories/interval_repository.dart';
import 'package:car_assistant/features/intervals/presentation/pages/due_services_page.dart';
import 'package:car_assistant/features/intervals/presentation/providers/interval_providers.dart';
import 'package:car_assistant/features/intervals/presentation/widgets/due_success_card.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
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
import '../../interval_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockIntervalRepository extends Mock implements IntervalRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late MockIntervalRepository repository;
  final now = DateTime(2026, 10, 21, 18, 45); // ۲۹ مهر ۱۴۰۵
  List<String>? wizardExtra;

  setUp(() {
    vehicles = MockVehicleRepository();
    repository = MockIntervalRepository();
    wizardExtra = null;
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => repository.getDue('v1')).thenAnswer((_) async => Right(dueReport));
  });

  Future<void> openPage(WidgetTester tester, {OdometerUpdateArgs? args}) async {
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TextButton(onPressed: () => context.push('/due'), child: const Text('home')),
          ),
        ),
        GoRoute(
          path: '/due',
          builder: (context, state) => DueServicesPage(vehicleId: 'v1', args: args),
        ),
        GoRoute(
          path: '/vehicles/:id/services/new',
          builder: (context, state) {
            wizardExtra = state.extra as List<String>?;
            return const Scaffold(body: Text('wizard'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          intervalRepositoryProvider.overrideWithValue(repository),
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
    await tester.tap(find.text('home'));
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  testWidgets('after an odometer update: success header, notice and one card per pending item', (
    tester,
  ) async {
    await openPage(tester, args: const OdometerUpdateArgs(previousKm: 34500, newKm: 34850));

    expect(find.text('سرویس‌های سررسید شده'), findsOneWidget);
    expect(find.text('کیلومتر با موفقیت ثبت شد'), findsOneWidget);
    expect(find.text('امروز، ۲۹ مهر ۱۴۰۵'), findsOneWidget);
    expect(find.text('۳۴٬۸۵۰'), findsOneWidget);
    expect(find.text('+۳۵۰ کیلومتر نسبت به ثبت قبل'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(
      find.text(
        'با این کارکرد جدید، ۲ سرویس خودرو به سررسید رسیده‌اند و نیازمند اقدام در تعمیرگاه هستند.',
      ),
      findsOneWidget,
    );
    // Three pending cards, the ok item left out.
    expect(find.text('تعویض روغن موتور و فیلترها'), findsOneWidget);
    expect(find.text('رسیدگی فوری'), findsOneWidget);
    expect(find.text('۳۵۰ کیلومتر گذشته از موعد'), findsOneWidget);
    expect(find.text('مقرر: ۳۴٬۵۰۰ کیلومتر'), findsOneWidget);
    expect(find.text('نزدیک به موعد'), findsOneWidget);
    expect(find.text('تنها ۱۵۰ کیلومتر مانده'), findsOneWidget);
    expect(find.text('اطلاعیه'), findsOneWidget);
    expect(find.text('۱٬۱۵۰ کیلومتر مانده (حدود ۱ ماه)'), findsOneWidget);
    expect(find.text('مایع خنک‌کننده'), findsNothing);
    expect(find.text('ثبت فاکتور این سرویس'), findsOneWidget);
    expect(find.text('ثبت این سرویس'), findsNWidgets(2));
  });

  testWidgets('without an update there is no success header and the plain notice', (tester) async {
    await openPage(tester);

    expect(find.text('کیلومتر با موفقیت ثبت شد'), findsNothing);
    expect(
      find.text('۲ سرویس خودرو به سررسید رسیده‌اند و نیازمند اقدام در تعمیرگاه هستند.'),
      findsOneWidget,
    );
  });

  testWidgets('the action opens the wizard with the covered items preselected', (tester) async {
    await openPage(tester);

    await tapText(tester, 'ثبت فاکتور این سرویس');

    expect(find.text('wizard'), findsOneWidget);
    expect(wizardExtra, ['engine_oil', 'oil_filter']);
  });

  testWidgets('shows the empty state when every interval is ok', (tester) async {
    when(() => repository.getDue('v1')).thenAnswer((_) async => Right(allOkReport));

    await openPage(tester);

    expect(find.text('همه سرویس‌ها به‌موقع هستند'), findsOneWidget);
    expect(find.text('نیاز به بررسی دوره‌ای'), findsNothing);
  });

  testWidgets('both footer buttons close the page', (tester) async {
    await openPage(tester);
    await tapText(tester, 'تأیید و بازگشت به داشبورد');
    expect(find.text('home'), findsOneWidget);

    await openPage(tester);
    await tapText(tester, 'بعداً یادآوری کن');
    expect(find.text('home'), findsOneWidget);
  });
}
