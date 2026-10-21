import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/expenses/domain/entities/attachment_file.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_category.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_failures.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_field.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_payment_method.dart';
import 'package:car_assistant/features/expenses/domain/entities/new_expense.dart';
import 'package:car_assistant/features/expenses/domain/repositories/expense_repository.dart';
import 'package:car_assistant/features/expenses/presentation/pages/new_expense_page.dart';
import 'package:car_assistant/features/expenses/presentation/providers/attachment_picker.dart';
import 'package:car_assistant/features/expenses/presentation/providers/expense_providers.dart';
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
import '../../expense_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class MockExpenseRepository extends Mock implements ExpenseRepository {}

class MockAttachmentPicker extends Mock implements AttachmentPicker {}

void main() {
  late MockVehicleRepository vehicles;
  late MockExpenseRepository expenses;
  late MockAttachmentPicker picker;
  final now = DateTime(2026, 10, 21, 18, 45); // چهارشنبه ۲۹ مهر ۱۴۰۵
  final today = DateTime(2026, 10, 21);

  setUpAll(() {
    registerFallbackValue(NewExpense(category: ExpenseCategory.other, amount: 1, paidAt: today));
    registerFallbackValue(pdfFile);
  });

  setUp(() {
    vehicles = MockVehicleRepository();
    expenses = MockExpenseRepository();
    picker = MockAttachmentPicker();
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => picker.pick()).thenAnswer((_) async => pdfFile);
  });

  /// Opens the page pushed above a home screen, so a successful save pops back to it.
  Future<void> openPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 2800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(vehicles),
          expenseRepositoryProvider.overrideWithValue(expenses),
          attachmentPickerProvider.overrideWithValue(picker),
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
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const NewExpensePage(vehicleId: 'v1')),
                ),
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

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
  }

  /// The text fields in page order: amount, title, reference, issuer.
  Finder field(int index) => find.byType(TextField).at(index);

  String fieldText(WidgetTester tester, int index) =>
      tester.widget<TextField>(field(index)).controller!.text;

  testWidgets('shows the vehicle, the notice and every section of the screen', (tester) async {
    await openPage(tester);

    expect(find.text('ثبت هزینه'), findsNWidgets(2)); // app bar and submit
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.textContaining('ثبت دستی اطلاعات توسط کاربر'), findsOneWidget);
    for (final label in [
      'انتخاب سرفصل هزینه',
      'دسته‌بندی اصلی',
      'بیمه شخص ثالث',
      'بیمه بدنه',
      'جریمه رانندگی',
      'عوارض و طرح',
      'معاینه فنی',
      'سایر هزینه‌ها',
      'مبلغ هزینه پرداخت‌شده',
      'الزامی',
      '+۱۰۰٬۰۰۰',
      '+۵۰۰٬۰۰۰',
      '+۱٬۰۰۰٬۰۰۰',
      'رند کردن',
      'عنوان هزینه',
      'شماره بیمه‌نامه یا کد یکتا / ارجاع',
      'تاریخ پرداخت / صدور',
      'چهارشنبه، ۲۹ مهر ۱۴۰۵',
      '۱۴۰۵/۰۷/۲۹',
      'امروز',
      'دیروز',
      'هفته گذشته',
      'انتخاب تاریخ',
      'تعیین موعد انقضا یا تمدید بعدی',
      'پیوست سند یا فیش پرداخت',
      'بدون پیوست',
      'افزودن سند یا فیش پرداخت',
      'شیوه پرداخت',
      'پرداخت اینترنتی',
      'کارت‌خوان / پوز',
      'واحد صادرکننده یا نمایندگی',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    // The expiry toggle starts off: no expiry row, no reminder checkbox.
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    expect(find.byType(Checkbox), findsNothing);
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('an empty form shows the category and amount errors and sends nothing', (
    tester,
  ) async {
    await openPage(tester);

    await submit(tester);

    expect(find.text('سرفصل هزینه را انتخاب کنید'), findsNWidgets(2)); // grid and footer
    expect(find.text('مبلغ هزینه را وارد کنید'), findsOneWidget);
    verifyNever(() => expenses.createExpense(any(), any()));
  });

  testWidgets('insurance turns the expiry on at +1 year; a fine turns it off again', (
    tester,
  ) async {
    await openPage(tester);

    await tapText(tester, 'بیمه شخص ثالث');

    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    expect(find.text('۲۹ مهر ۱۴۰۶ (۱ سال بعد)'), findsOneWidget);
    expect(find.text('۳۶۵ روز مانده'), findsOneWidget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
    expect(find.textContaining('ارسال اعلان یادآور'), findsOneWidget);

    // Last week's payment moves the suggestion with it; the pill counts from today.
    await tapText(tester, 'هفته گذشته');
    expect(find.text('چهارشنبه، ۲۲ مهر ۱۴۰۵'), findsOneWidget);
    expect(find.text('۲۲ مهر ۱۴۰۶ (۱ سال بعد)'), findsOneWidget);
    expect(find.text('۳۵۸ روز مانده'), findsOneWidget);

    await tapText(tester, 'جریمه رانندگی');
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    expect(find.byType(Checkbox), findsNothing);

    // Turned on by hand for a fine: no suggestion, the row asks for a date.
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.text('انتخاب تاریخ انقضا'), findsOneWidget);
    await submit(tester);
    expect(find.text('تاریخ انقضا باید بعد از تاریخ پرداخت باشد'), findsOneWidget);
  });

  testWidgets('the amount chips add and round', (tester) async {
    await openPage(tester);

    await tapText(tester, '+۵۰۰٬۰۰۰');
    await tapText(tester, '+۱۰۰٬۰۰۰');
    expect(fieldText(tester, 0), '۶۰۰٬۰۰۰');

    await tester.enterText(field(0), '5830000');
    await tapText(tester, 'رند کردن');
    expect(fieldText(tester, 0), '۵٬۸۵۰٬۰۰۰');
  });

  testWidgets('saves the expense with its attachment and goes back', (tester) async {
    when(() => expenses.createExpense('v1', any())).thenAnswer((_) async => Right(expense()));
    when(() => expenses.uploadAttachment('v1', 'e1', pdfFile))
        .thenAnswer((_) async => Right(expense(withAttachment: true)));
    await openPage(tester);

    await tapText(tester, 'بیمه شخص ثالث');
    await tester.enterText(field(0), '5850000');
    await tester.enterText(field(1), 'تمدید بیمه‌نامه');
    await tester.enterText(field(2), '1403/2480');
    await tester.enterText(field(3), 'نمایندگی ایران');
    await tester.pumpAndSettle();
    await tapText(tester, 'دیروز');
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tapText(tester, 'کارت‌خوان / پوز');
    await tapText(tester, 'افزودن سند یا فیش پرداخت');

    expect(find.text('بیمه‌نامه.pdf'), findsOneWidget);
    expect(find.text('۱ فایل پیوست شده'), findsOneWidget);
    expect(find.textContaining('سند PDF'), findsOneWidget);

    await submit(tester);

    final sent =
        verify(() => expenses.createExpense('v1', captureAny())).captured.single as NewExpense;
    expect(
      sent,
      NewExpense(
        category: ExpenseCategory.thirdPartyInsurance,
        amount: 5850000,
        title: 'تمدید بیمه‌نامه',
        referenceNumber: '1403/2480',
        paidAt: DateTime(2026, 10, 20),
        expiresAt: DateTime(2027, 10, 20),
        expiryReminder: false,
        paymentMethod: ExpensePaymentMethod.pos,
        issuer: 'نمایندگی ایران',
      ),
    );
    verify(() => expenses.uploadAttachment('v1', 'e1', pdfFile)).called(1);
    expect(find.byType(NewExpensePage), findsNothing);
    expect(find.text('هزینه ثبت شد'), findsOneWidget);
  });

  testWidgets('removing the attachment keeps the expense without a file', (tester) async {
    when(() => expenses.createExpense('v1', any())).thenAnswer((_) async => Right(expense()));
    await openPage(tester);
    await tapText(tester, 'سایر هزینه‌ها');
    await tester.enterText(field(0), '250000');
    await tester.pumpAndSettle();

    await tapText(tester, 'افزودن سند یا فیش پرداخت');
    await tester.tap(find.byTooltip('حذف فایل'));
    await tester.pumpAndSettle();
    expect(find.text('بدون پیوست'), findsOneWidget);

    await submit(tester);

    verify(() => expenses.createExpense('v1', any())).called(1);
    verifyNever(() => expenses.uploadAttachment(any(), any(), any()));
    expect(find.text('هزینه ثبت شد'), findsOneWidget);
  });

  testWidgets('a wrong file type is refused with a message', (tester) async {
    when(() => picker.pick()).thenAnswer(
      (_) async =>
          AttachmentFile(bytes: pdfFile.bytes, fileName: 'scan.gif', mimeType: 'image/gif'),
    );
    await openPage(tester);
    await tapText(tester, 'عوارض و طرح');
    await tester.enterText(field(0), '90000');
    await tester.pumpAndSettle();
    await tapText(tester, 'افزودن سند یا فیش پرداخت');

    await submit(tester);

    expect(find.text('فقط فایل PDF، JPG یا PNG مجاز است'), findsOneWidget);
    verifyNever(() => expenses.createExpense(any(), any()));
  });

  testWidgets('server field errors show inline', (tester) async {
    when(() => expenses.createExpense('v1', any())).thenAnswer(
      (_) async => const Left(InvalidExpenseFailure({ExpenseField.paidAt, ExpenseField.issuer})),
    );
    await openPage(tester);
    await tapText(tester, 'معاینه فنی');
    await tester.enterText(field(0), '400000');
    await tester.pumpAndSettle();

    await submit(tester);

    expect(find.text('تاریخ پرداخت نمی‌تواند در آینده باشد'), findsOneWidget);
    expect(find.text('نام صادرکننده حداکثر ۱۰۰ حرف است'), findsOneWidget);
    expect(find.text('برخی مقادیر نامعتبر است، فرم را بررسی کنید'), findsOneWidget);
    expect(find.byType(NewExpensePage), findsOneWidget);
  });
}
