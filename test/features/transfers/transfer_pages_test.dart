import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/router/app_routes.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/transfers/domain/entities/transfer_failures.dart';
import 'package:car_assistant/features/transfers/domain/entities/vehicle_transfer.dart';
import 'package:car_assistant/features/transfers/domain/repositories/transfer_repository.dart';
import 'package:car_assistant/features/transfers/presentation/pages/transfer_page.dart';
import 'package:car_assistant/features/transfers/presentation/providers/transfer_providers.dart';
import 'package:car_assistant/features/transfers/presentation/widgets/incoming_transfers.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:car_assistant/features/vehicles/presentation/providers/vehicle_providers.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../vehicles/vehicle_fixtures.dart';
import 'transfer_fixtures.dart';

class MockTransferRepository extends Mock implements TransferRepository {}

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockTransferRepository transfers;
  late MockVehicleRepository vehicles;

  setUp(() {
    transfers = MockTransferRepository();
    vehicles = MockVehicleRepository();
    when(() => vehicles.getVehicle('v1')).thenAnswer((_) async => const Right(tara));
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([tara]));
    when(() => transfers.getTransfers()).thenAnswer((_) async => const Right(TransferList()));
  });

  Future<void> pump(WidgetTester tester, String initialLocation) async {
    tester.view
      ..physicalSize = const Size(420, 3000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: IncomingTransfers()),
        ),
        GoRoute(
          path: '/vehicles/:id/transfer',
          builder: (context, state) => TransferPage(vehicleId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/vehicles/:id',
          builder: (context, state) => Text('vehicle ${state.pathParameters['id']}'),
        ),
        GoRoute(
          path: AppRoutes.reportExportPath,
          builder: (context, state) => Text('report ${state.uri.queryParameters['vehicleId']}'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transferRepositoryProvider.overrideWithValue(transfers),
          vehicleRepositoryProvider.overrideWithValue(vehicles),
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
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  FilledButton submit(WidgetTester tester) => tester.widget<FilledButton>(
    find.ancestor(
      of: find.text('تایید نهایی و ارسال درخواست انتقال'),
      matching: find.byType(FilledButton),
    ),
  );

  group('TransferPage', () {
    testWidgets('shows the vehicle, the truthful notes and the items', (tester) async {
      await pump(tester, '/vehicles/v1/transfer');

      expect(find.text('انتقال مالکیت خودرو'), findsOneWidget);
      expect(find.text('تارا اتوماتیک نقره‌ای'), findsNWidgets(2));
      expect(
        find.text(
          'درخواست انتقال در حساب کاربری این شماره نمایش داده می‌شود و پس از تایید خریدار انجام می‌شود.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'پیش از ارسال درخواست، در صورت نیاز از صفحه «خروجی گزارش» یک نسخه PDF یا اکسل از سوابق تهیه کنید.',
        ),
        findsOneWidget,
      );
      expect(find.text('سوابق کامل سرویس‌ها و فاکتورها'), findsOneWidget);
    });

    testWidgets('submits only with a valid phone and the consent, after a confirmation', (
      tester,
    ) async {
      when(() => transfers.createTransfer(any(), any())).thenAnswer((_) async => Right(transfer()));
      await pump(tester, '/vehicles/v1/transfer');
      expect(submit(tester).onPressed, isNull);

      await tester.enterText(find.byType(TextField), '09121234567');
      await tester.pump();
      expect(submit(tester).onPressed, isNull, reason: 'consent missing');

      await tapText(
        tester,
        'صحت شماره تلفن همراه خریدار و واگذاری کامل کنترل فنی و فاکتورهای خودرو را تایید می‌نمایم.',
      );
      expect(submit(tester).onPressed, isNotNull);

      await tapText(tester, 'تایید نهایی و ارسال درخواست انتقال');
      expect(find.text('درخواست انتقال ارسال شود؟'), findsOneWidget);
      verifyNever(() => transfers.createTransfer(any(), any()));

      when(() => transfers.getTransfers())
          .thenAnswer((_) async => Right(TransferList(outgoing: [transfer()])));
      await tapText(tester, 'ارسال درخواست');

      verify(() => transfers.createTransfer('v1', '09121234567')).called(1);
      expect(find.text('درخواست انتقال ارسال شد'), findsOneWidget);
      // The page now shows the pending request.
      expect(find.text('لغو درخواست'), findsOneWidget);
    });

    testWidgets('a self transfer (422) says so', (tester) async {
      when(() => transfers.createTransfer(any(), any()))
          .thenAnswer((_) async => const Left(SelfTransferFailure()));
      await pump(tester, '/vehicles/v1/transfer');

      await tester.enterText(find.byType(TextField), '9121234567');
      await tapText(
        tester,
        'صحت شماره تلفن همراه خریدار و واگذاری کامل کنترل فنی و فاکتورهای خودرو را تایید می‌نمایم.',
      );
      await tapText(tester, 'تایید نهایی و ارسال درخواست انتقال');
      await tapText(tester, 'ارسال درخواست');

      expect(find.text('نمی‌توانید خودرو را به شماره خودتان منتقل کنید'), findsOneWidget);
    });

    testWidgets('a pending request shows its phone and date and can be cancelled', (tester) async {
      when(() => transfers.getTransfers())
          .thenAnswer((_) async => Right(TransferList(outgoing: [transfer()])));
      when(() => transfers.cancelTransfer('t1')).thenAnswer((_) async => const Right(unit));
      await pump(tester, '/vehicles/v1/transfer');

      expect(find.byType(TextField), findsNothing);
      expect(find.text('شماره خریدار: ۰۹۱۲۱۲۳۴۵۶۷'), findsOneWidget);
      expect(find.text('تاریخ ارسال: ۲۵ آبان ۱۴۰۳'), findsOneWidget);

      when(() => transfers.getTransfers()).thenAnswer((_) async => const Right(TransferList()));
      await tapText(tester, 'لغو درخواست');

      verify(() => transfers.cancelTransfer('t1')).called(1);
      expect(find.text('درخواست انتقال لغو شد'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('rule ۲ opens the report export for the vehicle', (tester) async {
      await pump(tester, '/vehicles/v1/transfer');

      await tapText(tester, 'رفتن به خروجی گزارش');

      expect(find.text('report v1'), findsOneWidget);
    });
  });

  group('IncomingTransfers', () {
    setUp(() {
      when(() => transfers.getTransfers())
          .thenAnswer((_) async => Right(TransferList(incoming: [transfer()])));
    });

    testWidgets('shows nothing without incoming transfers', (tester) async {
      when(() => transfers.getTransfers()).thenAnswer((_) async => const Right(TransferList()));
      await pump(tester, '/home');

      expect(find.text('درخواست انتقال خودرو'), findsNothing);
    });

    testWidgets('accepting opens the vehicle in the garage', (tester) async {
      final accepted = taraWith(id: 'v9');
      when(() => transfers.acceptTransfer('t1'))
          .thenAnswer((_) async => Right<Failure, Vehicle>(accepted));
      await pump(tester, '/home');

      expect(find.text('درخواست انتقال خودرو'), findsOneWidget);
      expect(
        find.text('علی رضایی می‌خواهد «تارا اتوماتیک» را به گاراژ شما منتقل کند.'),
        findsOneWidget,
      );
      await tapText(tester, 'بررسی');
      expect(find.text('فرستنده: علی رضایی'), findsOneWidget);
      expect(find.text('کارکرد: ۴۲٬۳۰۰ کیلومتر'), findsOneWidget);

      await tapText(tester, 'پذیرش');

      verify(() => transfers.acceptTransfer('t1')).called(1);
      expect(find.text('vehicle v9'), findsOneWidget);
    });

    testWidgets('a 409 on accept shows the server message', (tester) async {
      when(() => transfers.acceptTransfer('t1')).thenAnswer(
        (_) async =>
            const Left(TransferConflictFailure('خودرویی با همین پلاک در گاراژ شما وجود دارد')),
      );
      await pump(tester, '/home');

      await tapText(tester, 'بررسی');
      await tapText(tester, 'پذیرش');

      expect(find.text('خودرویی با همین پلاک در گاراژ شما وجود دارد'), findsOneWidget);
    });

    testWidgets('rejecting closes the sheet', (tester) async {
      when(() => transfers.rejectTransfer('t1')).thenAnswer((_) async => const Right(unit));
      await pump(tester, '/home');

      await tapText(tester, 'بررسی');
      when(() => transfers.getTransfers()).thenAnswer((_) async => const Right(TransferList()));
      await tapText(tester, 'رد درخواست');

      verify(() => transfers.rejectTransfer('t1')).called(1);
      expect(find.text('درخواست انتقال رد شد'), findsOneWidget);
      expect(find.text('درخواست انتقال خودرو'), findsNothing);
    });

    testWidgets('a sender without a name is "یک کاربر"', (tester) async {
      when(() => transfers.getTransfers())
          .thenAnswer((_) async => Right(TransferList(incoming: [transfer(fromName: null)])));
      await pump(tester, '/home');

      expect(find.textContaining('یک کاربر'), findsOneWidget);
    });
  });
}
