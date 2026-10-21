import 'package:car_assistant/core/router/app_routes.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/notifications/domain/entities/notification_inbox.dart';
import 'package:car_assistant/features/notifications/domain/repositories/notification_repository.dart';
import 'package:car_assistant/features/notifications/presentation/pages/notifications_page.dart';
import 'package:car_assistant/features/notifications/presentation/providers/notification_providers.dart';
import 'package:car_assistant/features/notifications/presentation/widgets/notification_bell_button.dart';
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

import '../../vehicles/vehicle_fixtures.dart';
import '../notification_fixtures.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockNotificationRepository notifications;
  late MockVehicleRepository vehicles;
  // In UTC like the fixtures, so the relative times hold in any time zone.
  final now = DateTime.utc(2026, 10, 21, 18, 45);

  setUp(() {
    notifications = MockNotificationRepository();
    vehicles = MockVehicleRepository();
    when(() => vehicles.getVehicles()).thenAnswer((_) async => const Right([tara]));
    when(() => notifications.getNotifications()).thenAnswer(
      (_) async => Right(
        NotificationInbox(
          notifications: [
            intervalNotification(),
            documentExpiryNotification(),
            expenseExpiryNotification(),
          ],
          unreadCount: 2,
        ),
      ),
    );
    when(() => notifications.getUnreadCount()).thenAnswer((_) async => const Right(2));
    when(() => notifications.markRead(any()))
        .thenAnswer((_) async => Right(intervalNotification(read: true)));
    when(() => notifications.markAllRead()).thenAnswer((_) async => const Right(2));
  });

  /// A home page with the bell; the notifications page and its targets are stub routes.
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              Scaffold(appBar: AppBar(actions: const [NotificationBellButton()])),
        ),
        GoRoute(
          path: AppRoutes.notificationsPath,
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(path: '/vehicles/:id/due', builder: (context, state) => const Text('due page')),
        GoRoute(
          path: '/vehicles/:id/documents',
          builder: (context, state) => const Text('documents page'),
        ),
        GoRoute(
          path: '/vehicles/:id/services/new',
          builder: (context, state) => const Text('service wizard'),
        ),
        GoRoute(path: '/vehicles/:id', builder: (context, state) => const Text('vehicle page')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(notifications),
          vehicleRepositoryProvider.overrideWithValue(vehicles),
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

  Future<void> openInbox(WidgetTester tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(NotificationBellButton));
    await tester.pumpAndSettle();
  }

  testWidgets('the bell shows the unread count and opens the inbox', (tester) async {
    await pumpApp(tester);

    expect(find.text('۲'), findsOneWidget);
    expect(find.byTooltip('اعلانات، ۲ خوانده‌نشده'), findsOneWidget);

    await tester.tap(find.byType(NotificationBellButton));
    await tester.pumpAndSettle();

    expect(find.text('صندوق اعلانات'), findsOneWidget);
  });

  testWidgets('the bell shows no badge when nothing is unread or the count fails', (tester) async {
    when(() => notifications.getUnreadCount()).thenAnswer((_) async => const Left(Failure('x')));
    await pumpApp(tester);

    expect(find.byTooltip('اعلانات'), findsOneWidget);
    expect(find.text('۰'), findsNothing);
  });

  testWidgets('composes every row from its fields', (tester) async {
    await openInbox(tester);

    expect(find.text('۲ اعلان جدید'), findsOneWidget);
    expect(find.text('خواندن همه'), findsOneWidget);
    expect(find.text('همه (۳)'), findsOneWidget);
    for (final chip in ['سرویس و نگهداری', 'بیمه و اسناد', 'سیستمی']) {
      expect(find.text(chip), findsOneWidget);
    }
    expect(find.text('موعد تعویض روغن موتور تارا اتوماتیک نقره‌ای'), findsOneWidget);
    expect(find.textContaining('تنها ۱۵۰ کیلومتر تا سرویس'), findsOneWidget);
    expect(find.text('ثبت سرویس'), findsOneWidget);
    expect(find.text('۲ ساعت پیش'), findsOneWidget);
    expect(find.text('سررسید بیمه شخص ثالث'), findsOneWidget);
    expect(find.text('۱۸ روز باقیمانده'), findsOneWidget);
    expect(find.textContaining('دیروز، '), findsOneWidget);
    expect(find.text('سررسید بیمه بدنه'), findsOneWidget);
    expect(find.text('تمامی اعلانات به مدت ۹۰ روز در تاریخچه حفظ می‌گردند'), findsOneWidget);
  });

  Future<void> tapChip(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('chips filter by category; an empty one offers to show all', (tester) async {
    await openInbox(tester);

    await tapChip(tester, 'بیمه و اسناد');
    expect(find.text('سررسید بیمه شخص ثالث'), findsOneWidget);
    expect(find.text('ثبت سرویس'), findsNothing);

    await tapChip(tester, 'سیستمی');
    expect(find.text('اعلانی در این دسته‌بندی وجود ندارد'), findsOneWidget);

    await tester.tap(find.text('مشاهده همه اعلان‌ها'));
    await tester.pumpAndSettle();
    expect(find.text('ثبت سرویس'), findsOneWidget);
  });

  testWidgets('"خواندن همه" marks everything read and refreshes the badge', (tester) async {
    await openInbox(tester);
    when(() => notifications.getUnreadCount()).thenAnswer((_) async => const Right(0));

    await tester.tap(find.text('خواندن همه'));
    await tester.pumpAndSettle();

    verify(() => notifications.markAllRead()).called(1);
    expect(find.text('اعلان جدیدی نیست'), findsOneWidget);

    // The bell under the inbox refreshes once it is back on screen.
    await tester.tap(find.byTooltip('بازگشت'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('اعلانات'), findsOneWidget);
    expect(find.text('۲'), findsNothing);
  });

  testWidgets('tapping a service reminder marks it read and opens the due page', (tester) async {
    await openInbox(tester);

    await tester.tap(find.text('موعد تعویض روغن موتور تارا اتوماتیک نقره‌ای'));
    await tester.pumpAndSettle();

    verify(() => notifications.markRead('n1')).called(1);
    expect(find.text('due page'), findsOneWidget);
  });

  testWidgets('"ثبت سرویس" opens the service wizard', (tester) async {
    await openInbox(tester);

    await tester.tap(find.text('ثبت سرویس'));
    await tester.pumpAndSettle();

    expect(find.text('service wizard'), findsOneWidget);
  });

  testWidgets('a document reminder opens the documents page', (tester) async {
    await openInbox(tester);

    await tester.tap(find.text('سررسید بیمه شخص ثالث'));
    await tester.pumpAndSettle();

    verify(() => notifications.markRead('n2')).called(1);
    expect(find.text('documents page'), findsOneWidget);
  });

  testWidgets('a read expense reminder opens the vehicle without marking it again', (tester) async {
    await openInbox(tester);

    await tester.tap(find.text('سررسید بیمه بدنه'));
    await tester.pumpAndSettle();

    verifyNever(() => notifications.markRead('n3'));
    expect(find.text('vehicle page'), findsOneWidget);
  });

  testWidgets('a load error offers a retry', (tester) async {
    when(() => notifications.getNotifications()).thenAnswer((_) async => const Left(Failure('x')));
    await openInbox(tester);

    expect(find.text('دریافت اعلان‌ها ممکن نشد'), findsOneWidget);
    expect(find.text('تلاش دوباره'), findsOneWidget);
  });
}
