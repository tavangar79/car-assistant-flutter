import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/services/domain/entities/service_line_item.dart';
import 'package:car_assistant/features/services/domain/entities/service_suggestions.dart';
import 'package:car_assistant/features/services/domain/entities/service_visit_update.dart';
import 'package:car_assistant/features/services/domain/repositories/service_repository.dart';
import 'package:car_assistant/features/services/presentation/pages/service_details_page.dart';
import 'package:car_assistant/features/services/presentation/providers/service_providers.dart';
import 'package:car_assistant/features/services/presentation/widgets/details/invoice_viewer_page.dart';
import 'package:car_assistant/features/services/presentation/widgets/details/service_item_picker_sheet.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../service_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

void main() {
  late MockVehicleRepository vehicles;
  late MockServiceRepository services;

  setUpAll(() => registerFallbackValue(const ServiceVisitUpdate()));

  setUp(() {
    vehicles = MockVehicleRepository();
    services = MockServiceRepository();
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([tara]));
    when(() => services.getCatalog()).thenAnswer((_) async => const Right(serviceCatalog));
    when(() => services.getSuggestions()).thenAnswer(
      (_) async => const Right(
        ServiceSuggestions(
          brands: {
            'oil_filter': ['سرکان', 'سرکان اصلی'],
          },
        ),
      ),
    );
    when(() => services.getVisit('v1', 's1')).thenAnswer((_) async => Right(visit()));
    when(() => services.getVisits('v1')).thenAnswer((_) async => Right([visit()]));
  });

  Future<void> openPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          serviceRepositoryProvider.overrideWithValue(services),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ServiceDetailsPage(vehicleId: 'v1', serviceId: 's1'),
                    ),
                  ),
                  child: const Text('open'),
                ),
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
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  testWidgets('shows the header, the items with reminders and costs, and the total', (
    tester,
  ) async {
    await openPage(tester);

    expect(find.text('جزئیات فاکتور سرویس'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.text('سه‌شنبه، ۲۸ مهر ۱۴۰۵'), findsOneWidget);
    expect(find.text('۳۴٬۸۵۰'), findsOneWidget);
    expect(find.text('اتوسرویس البرز'), findsOneWidget);
    expect(find.text('اقلام انجام‌شده در این مراجعه (۲ مورد)'), findsOneWidget);
    expect(find.text('روغن موتور'), findsOneWidget);
    expect(find.text('بهران رانا 5W-40'), findsOneWidget);
    // 34,850 + 7,000 km, 6 months after 29 Mehr 1405 → Farvardin 1406.
    expect(find.text('یادآور بعد: ۴۱٬۸۵۰ کیلومتر (فروردین ۱۴۰۶)'), findsOneWidget);
    expect(find.text('بدون یادآور'), findsOneWidget);
    expect(find.text('۱٬۸۵۰٬۰۰۰'), findsOneWidget);
    expect(find.text('۲۸۰٬۰۰۰'), findsOneWidget);
    expect(find.text('۲٬۱۳۰٬۰۰۰'), findsOneWidget);
    expect(find.text('تصویری از فاکتور الصاق نشده است'), findsOneWidget);
    final pdf = find.ancestor(
      of: find.text('دریافت فایل PDF فاکتور'),
      matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
    );
    expect(tester.widget<ButtonStyleButton>(pdf).onPressed, isNull);
  });

  testWidgets('shows the invoice with its size and opens the full-size viewer', (tester) async {
    when(() => services.getVisit('v1', 's1'))
        .thenAnswer((_) async => Right(visit(withInvoice: true)));
    when(() => services.fetchInvoice(any())).thenAnswer((_) async => Right(transparentPng));

    await openPage(tester);

    expect(find.text('۱٫۴ مگابایت'), findsOneWidget);
    expect(find.text('فاکتور.jpg'), findsOneWidget);
    expect(find.textContaining('بارگذاری شده در'), findsOneWidget);

    await tapText(tester, 'مشاهده در ابعاد کامل');

    expect(find.byType(InvoiceViewerPage), findsOneWidget);
  });

  testWidgets('editing an item patches the whole list', (tester) async {
    when(() => services.updateVisit('v1', 's1', any())).thenAnswer((_) async => Right(visit()));
    await openPage(tester);

    await tester.tap(find.byTooltip('ویرایش قلم').last);
    await tester.pumpAndSettle();
    expect(find.text('ویرایش قلم'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '300000');
    await tapText(tester, 'ذخیره قلم');

    final update =
        verify(() => services.updateVisit('v1', 's1', captureAny())).captured.single
            as ServiceVisitUpdate;
    expect(update.lineItems, const [
      oilLine,
      ServiceLineItem(itemId: 'oil_filter', brand: 'سرکان', cost: 300000),
    ]);
    expect(find.text('فاکتور به‌روزرسانی شد'), findsOneWidget);
  });

  testWidgets('the editor offers the brands used before for the item', (tester) async {
    when(() => services.updateVisit('v1', 's1', any())).thenAnswer((_) async => Right(visit()));
    await openPage(tester);

    await tester.tap(find.byTooltip('ویرایش قلم').last); // oil_filter
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), 'اصلی'); // brand
    await tester.pumpAndSettle();
    expect(find.text('سرکان اصلی'), findsOneWidget);
    await tapText(tester, 'سرکان اصلی');
    await tapText(tester, 'ذخیره قلم');

    final update =
        verify(() => services.updateVisit('v1', 's1', captureAny())).captured.single
            as ServiceVisitUpdate;
    expect(update.lineItems!.last.brand, 'سرکان اصلی');
  });

  testWidgets('deleting an item asks first; the last item cannot be deleted', (tester) async {
    when(() => services.updateVisit('v1', 's1', any()))
        .thenAnswer((_) async => Right(visit(lines: const [oilLine])));
    await openPage(tester);

    await tester.tap(find.byTooltip('حذف قلم').last);
    await tester.pumpAndSettle();
    expect(find.text('حذف قلم «فیلتر روغن»؟'), findsOneWidget);
    // After the save the visit is fetched again, now with one item.
    when(() => services.getVisit('v1', 's1'))
        .thenAnswer((_) async => Right(visit(lines: const [oilLine])));
    await tapText(tester, 'حذف');

    verify(() => services.updateVisit('v1', 's1', const ServiceVisitUpdate(lineItems: [oilLine])))
        .called(1);
    expect(find.text('اقلام انجام‌شده در این مراجعه (۱ مورد)'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5)); // let the snackbar go
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('حذف قلم'));
    await tester.pumpAndSettle();

    expect(find.textContaining('آخرین قلم فاکتور را نمی‌توان حذف کرد'), findsOneWidget);
    verifyNever(() => services.updateVisit('v1', 's1', const ServiceVisitUpdate(lineItems: [])));
  });

  testWidgets('adding an item picks it from the catalog, then edits it', (tester) async {
    when(() => services.updateVisit('v1', 's1', any())).thenAnswer((_) async => Right(visit()));
    await openPage(tester);

    await tapText(tester, 'افزودن قلم جدید به این فاکتور');
    final sheet = find.byType(ServiceItemPickerSheet);
    expect(find.text('انتخاب سرویس'), findsOneWidget);
    // Items already on the visit are not offered.
    expect(find.descendant(of: sheet, matching: find.text('روغن موتور')), findsNothing);
    expect(find.descendant(of: sheet, matching: find.text('لنت ترمز جلو')), findsOneWidget);
    await tapText(tester, 'لنت ترمز جلو');
    expect(find.text('افزودن قلم'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '950000');
    await tapText(tester, 'ذخیره قلم');

    final update =
        verify(() => services.updateVisit('v1', 's1', captureAny())).captured.single
            as ServiceVisitUpdate;
    expect(update.lineItems, const [
      oilLine,
      filterLine,
      ServiceLineItem(itemId: 'front_brake_pads', cost: 950000),
    ]);
  });

  testWidgets('the menu deletes the visit after confirming and leaves the page', (tester) async {
    when(() => services.deleteVisit('v1', 's1')).thenAnswer((_) async => const Right(unit));
    await openPage(tester);

    await tester.tap(find.byTooltip('گزینه‌های فاکتور'));
    await tester.pumpAndSettle();
    await tapText(tester, 'حذف فاکتور');
    expect(find.text('حذف این فاکتور؟'), findsOneWidget);
    await tapText(tester, 'حذف');

    verify(() => services.deleteVisit('v1', 's1')).called(1);
    expect(find.byType(ServiceDetailsPage), findsNothing);
    expect(find.text('فاکتور حذف شد'), findsOneWidget);
  });
}
