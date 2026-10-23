import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/history/domain/entities/history_filter.dart';
import 'package:car_assistant/features/history/domain/entities/history_period.dart';
import 'package:car_assistant/features/history/domain/entities/history_query.dart';
import 'package:car_assistant/features/history/domain/repositories/history_repository.dart';
import 'package:car_assistant/features/history/presentation/pages/history_filter_page.dart';
import 'package:car_assistant/features/history/presentation/providers/history_providers.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:car_assistant/features/services/domain/repositories/service_repository.dart';
import 'package:car_assistant/features/services/presentation/providers/service_providers.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../services/service_fixtures.dart';
import '../../../vehicles/vehicle_fixtures.dart';
import '../../history_fixtures.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

void main() {
  final now = DateTime(2026, 10, 21, 18, 45); // ۲۹ مهر ۱۴۰۵
  final peugeot = taraWith(id: 'v2', nickname: 'پژو ۲۰۷');
  late MockHistoryRepository history;
  late ProviderContainer container;

  setUpAll(() => registerFallbackValue(const HistoryQuery()));

  Future<void> openPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    history = MockHistoryRepository();
    final vehicles = MockVehicleRepository();
    final services = MockServiceRepository();
    when(() => history.getHistory(any())).thenAnswer((_) async => Right(historyResult()));
    when(() => vehicles.getVehicles()).thenAnswer((_) async => Right([tara, peugeot]));
    when(() => services.getCatalog(vehicleId: any(named: 'vehicleId')))
        .thenAnswer((_) async => const Right(serviceCatalog));
    container = ProviderContainer(
      overrides: [
        historyRepositoryProvider.overrideWithValue(history),
        vehicleRepositoryProvider.overrideWithValue(vehicles),
        serviceRepositoryProvider.overrideWithValue(services),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () =>
                    Navigator.of(context)
                        .push(MaterialPageRoute<void>(builder: (_) => const HistoryFilterPage())),
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

  HistoryFilter draft() => container.read(historyFilterDraftProvider);

  testWidgets('shows the vehicles, the catalog categories, the periods and the match count', (
    tester,
  ) async {
    await openPage(tester);

    expect(find.text('فیلتر سوابق'), findsOneWidget);
    expect(find.text('انتخاب شده: ۲ خودرو'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.text('پژو ۲۰۷'), findsOneWidget);
    expect(find.text('نمایش جامع تمام ۲ خودروی ثبت‌شده'), findsOneWidget);
    expect(find.text('روغن و مایعات مصرفی'), findsOneWidget);
    expect(find.text('روغن موتور، فیلتر روغن'), findsOneWidget);
    expect(find.text('ترمز و ایمنی'), findsOneWidget);
    expect(find.text('هزینه‌های قانونی'), findsOneWidget);
    expect(find.text('سال جاری (۱۴۰۵)'), findsOneWidget);
    expect(find.text('۲۳ رکورد'), findsOneWidget);
    verify(
      () => history.getHistory(any(that: isA<HistoryQuery>().having((q) => q.limit, 'limit', 1))),
    ).called(1);
  });

  testWidgets('edits the pending filter and applies it on "اعمال فیلتر"', (tester) async {
    await openPage(tester);

    await tapText(tester, 'پژو ۲۰۷');
    await tapText(tester, 'ترمز و ایمنی');
    await tapText(tester, 'هزینه‌های قانونی');
    await tapText(tester, 'فقط سوابق دارای پیوست / فاکتور');
    await tapText(tester, '۶ ماه اخیر');

    expect(find.text('۴ فیلتر فعال'), findsOneWidget);
    expect(container.read(historyFilterProvider), HistoryFilter.initial);

    await tapText(tester, 'اعمال فیلتر');

    expect(find.byType(HistoryFilterPage), findsNothing);
    expect(
      container.read(historyFilterProvider),
      const HistoryFilter(
        vehicleIds: {'v2'},
        categories: {'brakes', 'legal'},
        attachmentsOnly: true,
      ).withPeriod(HistoryPeriod.lastSixMonths),
    );
  });

  testWidgets('"انتخاب همه" picks every category and "پاک کردن" resets', (tester) async {
    await openPage(tester);

    await tapText(tester, 'انتخاب همه');
    expect(draft().categories, hasLength(7));

    await tapText(tester, 'همه خودروهای گاراژ');
    await tapText(tester, 'پاک کردن');
    expect(draft(), HistoryFilter.initial);
    expect(find.textContaining('فیلتر فعال'), findsNothing);
  });

  testWidgets('a custom range asks for the first and last day', (tester) async {
    await openPage(tester);

    await tapText(tester, 'انتخاب دستی');
    expect(find.text('از تاریخ'), findsOneWidget);
    await tapText(tester, 'تأیید تاریخ');
    expect(find.text('تا تاریخ'), findsOneWidget);
    await tapText(tester, 'تأیید تاریخ');

    expect(draft().period, HistoryPeriod.custom);
    expect(draft().customFrom, DateTime(2026, 10, 21));
    expect(draft().customTo, DateTime(2026, 10, 21));
    expect(find.text('۱۴۰۵/۰۷/۲۹ تا ۱۴۰۵/۰۷/۲۹'), findsOneWidget);
  });

  testWidgets('the close button leaves the applied filter untouched', (tester) async {
    await openPage(tester);

    await tapText(tester, 'ترمز و ایمنی');
    await tester.tap(find.byTooltip('بستن'));
    await tester.pumpAndSettle();

    expect(find.byType(HistoryFilterPage), findsNothing);
    expect(container.read(historyFilterProvider), HistoryFilter.initial);
  });
}
