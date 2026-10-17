import 'dart:typed_data';

import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/vehicles/domain/entities/new_vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_color.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_failures.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_field.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_photo.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/pages/add_vehicle_page.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_photo_picker.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicle_fixtures.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

class FakePhotoPicker extends VehiclePhotoPicker {
  FakePhotoPicker(this.photo);

  final VehiclePhoto photo;

  @override
  Future<VehiclePhoto?> pick(PhotoSource source) async => photo;
}

void main() {
  late MockVehicleRepository repository;
  final photo = VehiclePhoto(bytes: transparentPng, fileName: 'car.png');

  setUpAll(() {
    registerFallbackValue(
      const NewVehicle(
        nickname: 'x',
        plate: plate,
        makeId: 'm',
        modelId: 'm',
        yearJalali: 1400,
        mileageKm: 0,
      ),
    );
    registerFallbackValue(VehiclePhoto(bytes: Uint8List(1), fileName: 'x.jpg'));
  });

  setUp(() {
    repository = MockVehicleRepository();
    when(() => repository.getCatalog()).thenAnswer((_) async => const Right(catalog));
    when(() => repository.getVehicles()).thenAnswer((_) async => const Right([]));
  });

  /// Opens the page on top of a launcher, so popping it can be checked. The view is tall enough
  /// to build the whole form.
  Future<void> openPage(WidgetTester tester, {double width = 800}) async {
    tester.view.physicalSize = Size(width, 4400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(repository),
          currentJalaliYearProvider.overrideWithValue(1405),
          vehiclePhotoPickerProvider.overrideWithValue(FakePhotoPicker(photo)),
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
                  onPressed: () =>
                      Navigator.of(context)
                          .push(MaterialPageRoute<void>(builder: (_) => const AddVehiclePage())),
                  child: const Text('launcher'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('launcher'));
    await tester.pumpAndSettle();
  }

  Finder textField(int index) => find.byType(TextField).at(index);
  Finder catalogPicker(int index) => find.byType(DropdownButtonFormField<String>).at(index);

  Future<void> choose(WidgetTester tester, Finder dropdown, String item) async {
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(item).last);
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.tap(find.text('ثبت و افزودن به گاراژ'));
    await tester.pumpAndSettle();
  }

  /// Fills every field with valid values, typing Persian digits.
  Future<void> fillForm(WidgetTester tester) async {
    await tester.enterText(textField(0), 'تارا اتوماتیک نقره‌ای');
    await tester.enterText(textField(1), '۷۲');
    await choose(tester, find.byType(DropdownButton<String>).first, 'ب');
    await tester.enterText(textField(2), '۳۴۵');
    await tester.enterText(textField(3), '۶۸');
    await tester.enterText(textField(4), 'naam21ca9kk123456');
    await choose(tester, catalogPicker(0), 'ایران خودرو');
    await choose(tester, catalogPicker(1), 'تارا');
    await choose(tester, catalogPicker(2), 'V4 اتوماتیک - فول آپشن');
    await tester.tap(find.text('انتخاب سال'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تأیید سال'));
    await tester.pumpAndSettle();
    await tester.enterText(textField(5), '34500');
    await tester.tap(find.bySemanticsLabel('نقره‌ای متالیک'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows every Stitch section, without the VIN scan button', (tester) async {
    await openPage(tester);

    for (final text in [
      'افزودن خودرو',
      'مشخصات هویتی خودرو',
      'تصویر خودرو',
      'بارگذاری یا عکاسی از خودرو',
      'نام مستعار یا عنوان دلخواه',
      'پلاک ملی خودرو',
      'کد شناسایی خودرو (VIN)',
      'سازنده و مشخصات فنی',
      'برند / سازنده',
      'مدل خودرو',
      'تیپ و گیربکس',
      'سال ساخت (خورشیدی)',
      'کارکرد فعلی کیلومترشمار',
      'رنگ بدنه',
      'تنظیم به عنوان خودروی پیش‌فرض',
      'ثبت و افزودن به گاراژ',
      'انصراف',
    ]) {
      expect(find.textContaining(text), findsWidgets, reason: text);
    }
    expect(find.text('حداکثر حجم ۵ مگابایت • فرمت JPG یا PNG'), findsOneWidget);
    expect(find.text('کیلومتر'), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_scanner), findsNothing);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('fits a 360px phone without overflow, errors included', (tester) async {
    await openPage(tester, width: 360);
    await save(tester);

    expect(tester.takeException(), isNull);
  });

  testWidgets('saving an empty form shows the field errors and sends nothing', (tester) async {
    await openPage(tester);

    await save(tester);

    expect(find.text('نام خودرو را وارد کنید (حداکثر ۴۰ نویسه)'), findsOneWidget);
    expect(find.text('پلاک را کامل و درست وارد کنید'), findsOneWidget);
    expect(find.text('برند را انتخاب کنید'), findsOneWidget);
    expect(find.text('مدل را انتخاب کنید'), findsOneWidget);
    expect(find.text('سال ساخت را انتخاب کنید'), findsOneWidget);
    expect(find.text('کارکرد را بین ۰ تا ۲٬۰۰۰٬۰۰۰ کیلومتر وارد کنید'), findsOneWidget);
    expect(find.text('برخی اطلاعات معتبر نیست؛ موارد مشخص‌شده را بررسی کنید'), findsOneWidget);
    verifyNever(() => repository.createVehicle(any()));
  });

  testWidgets('editing a field hides its error', (tester) async {
    await openPage(tester);
    await save(tester);

    await tester.enterText(textField(0), 'تارا');
    await tester.pump();

    expect(find.text('نام خودرو را وارد کنید (حداکثر ۴۰ نویسه)'), findsNothing);
    expect(find.text('پلاک را کامل و درست وارد کنید'), findsOneWidget);
  });

  testWidgets('shows Persian digits and sends Latin digits, then closes', (tester) async {
    when(() => repository.createVehicle(any())).thenAnswer((_) async => const Right(tara));
    await openPage(tester);

    await fillForm(tester);
    expect(find.text('۳۴٬۵۰۰'), findsOneWidget);
    expect(find.text('۱۴۰۵'), findsOneWidget);
    expect(tester.widget<TextField>(textField(4)).controller!.text, 'NAAM21CA9KK123456');
    await save(tester);

    final sent = verify(() => repository.createVehicle(captureAny())).captured.single as NewVehicle;
    expect(
      sent,
      const NewVehicle(
        nickname: 'تارا اتوماتیک نقره‌ای',
        plate: plate,
        vin: validVin,
        makeId: 'iran-khodro',
        modelId: 'tara',
        trimId: 'tara-v4-at',
        yearJalali: 1405,
        mileageKm: 34500,
        color: VehicleColor.silver,
        isDefault: true,
      ),
    );
    verifyNever(() => repository.uploadPhoto(any(), any()));
    expect(find.byType(AddVehiclePage), findsNothing);
    expect(find.text('خودرو اضافه شد'), findsOneWidget);
  });

  testWidgets('a taken plate (409) is shown on the plate and the page stays', (tester) async {
    when(() => repository.createVehicle(any()))
        .thenAnswer((_) async => const Left(PlateTakenFailure()));
    await openPage(tester);

    await fillForm(tester);
    await save(tester);

    expect(find.text('این پلاک قبلاً در گاراژ شما ثبت شده است'), findsOneWidget);
    expect(find.byType(AddVehiclePage), findsOneWidget);
  });

  testWidgets('a server 400 marks the named fields', (tester) async {
    when(() => repository.createVehicle(any())).thenAnswer(
      (_) async => const Left(InvalidVehicleFailure({VehicleField.model, VehicleField.trim})),
    );
    await openPage(tester);

    await fillForm(tester);
    await save(tester);

    expect(find.text('مدل را انتخاب کنید'), findsOneWidget);
    expect(find.text('تیپ انتخاب‌شده معتبر نیست'), findsOneWidget);
  });

  testWidgets('any other failure shows a retry message and keeps the form', (tester) async {
    when(() => repository.createVehicle(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));
    await openPage(tester);

    await fillForm(tester);
    await save(tester);

    expect(find.text('ذخیره خودرو ممکن نشد. دوباره تلاش کنید'), findsOneWidget);
    expect(find.text('تارا اتوماتیک نقره‌ای'), findsOneWidget);
  });

  testWidgets('uploads the picked photo after saving', (tester) async {
    when(() => repository.createVehicle(any())).thenAnswer((_) async => const Right(tara));
    when(() => repository.uploadPhoto('v1', photo)).thenAnswer((_) async => const Right(tara));
    await openPage(tester);

    await tester.tap(find.text('بارگذاری یا عکاسی از خودرو'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('انتخاب فایل از گالری').last);
    await tester.pumpAndSettle();
    expect(find.text('تغییر تصویر'), findsOneWidget);
    await fillForm(tester);
    await save(tester);

    verify(() => repository.uploadPhoto('v1', photo)).called(1);
    expect(find.text('خودرو اضافه شد'), findsOneWidget);
  });

  testWidgets('when only the photo fails, says so and still closes', (tester) async {
    when(() => repository.createVehicle(any())).thenAnswer((_) async => const Right(tara));
    when(() => repository.uploadPhoto('v1', photo))
        .thenAnswer((_) async => const Left(VehiclePhotoTooLargeFailure()));
    await openPage(tester);

    await tester.tap(find.text('بارگذاری یا عکاسی از خودرو'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('انتخاب فایل از گالری').last);
    await tester.pumpAndSettle();
    await fillForm(tester);
    await save(tester);

    expect(find.byType(AddVehiclePage), findsNothing);
    expect(find.text('خودرو اضافه شد، اما بارگذاری تصویر ناموفق بود'), findsOneWidget);
  });

  testWidgets('the model list follows the make, and a new make clears the model', (tester) async {
    await openPage(tester);

    await choose(tester, catalogPicker(0), 'ایران خودرو');
    await choose(tester, catalogPicker(1), 'تارا');
    expect(find.text('تارا'), findsOneWidget);

    await choose(tester, catalogPicker(0), 'سایپا');

    expect(find.text('تارا'), findsNothing);
    expect(find.text('انتخاب مدل'), findsOneWidget);
    await choose(tester, catalogPicker(1), 'شاهین');
    expect(find.text('شاهین'), findsOneWidget);
  });

  testWidgets('the year picker lists Jalali years, newest marked brand new', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('انتخاب سال'));
    await tester.pumpAndSettle();

    expect(find.text('انتخاب سال ساخت (خورشیدی)'), findsOneWidget);
    expect(find.text('۱۴۰۶ (صفر کیلومتر)'), findsOneWidget);
  });

  testWidgets('a catalog error offers a retry', (tester) async {
    when(() => repository.getCatalog()).thenAnswer((_) async => const Left(NetworkFailure()));
    await openPage(tester);

    expect(find.text('دریافت فهرست خودروها ممکن نشد'), findsOneWidget);
    when(() => repository.getCatalog()).thenAnswer((_) async => const Right(catalog));
    await tester.tap(find.text('تلاش دوباره'));
    await tester.pumpAndSettle();

    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(3));
  });

  testWidgets('cancel closes the page without saving', (tester) async {
    await openPage(tester);

    await tester.tap(find.text('انصراف'));
    await tester.pumpAndSettle();

    expect(find.byType(AddVehiclePage), findsNothing);
    verifyNever(() => repository.createVehicle(any()));
  });
}
