import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/notifications/domain/entities/app_notification.dart';
import 'package:car_assistant/features/notifications/domain/entities/notification_inbox.dart';
import 'package:car_assistant/features/notifications/domain/repositories/notification_repository.dart';
import 'package:car_assistant/features/notifications/domain/usecases/get_notifications.dart';
import 'package:car_assistant/features/notifications/domain/usecases/get_unread_notification_count.dart';
import 'package:car_assistant/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:car_assistant/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../notification_fixtures.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  final inbox = NotificationInbox(
    notifications: [intervalNotification(), documentExpiryNotification()],
    unreadCount: 2,
  );

  group('NotificationInbox', () {
    test('withRead marks one notification read and lowers the count', () {
      expect(
        inbox.withRead('n1'),
        NotificationInbox(
          notifications: [intervalNotification(read: true), documentExpiryNotification()],
          unreadCount: 1,
        ),
      );
    });

    test('withRead of a read notification keeps the count', () {
      expect(inbox.withRead('n1').withRead('n1').unreadCount, 1);
    });

    test('allRead marks everything read', () {
      expect(
        inbox.allRead(),
        NotificationInbox(
          notifications: [intervalNotification(read: true), documentExpiryNotification(read: true)],
          unreadCount: 0,
        ),
      );
    });
  });

  group('use cases pass the repository result through', () {
    late MockNotificationRepository repository;

    setUp(() => repository = MockNotificationRepository());

    test('GetNotifications', () async {
      when(() => repository.getNotifications()).thenAnswer((_) async => Right(inbox));
      expect(await GetNotifications(repository).call(), Right<Failure, NotificationInbox>(inbox));
    });

    test('GetUnreadNotificationCount', () async {
      when(() => repository.getUnreadCount()).thenAnswer((_) async => const Right(2));
      expect(await GetUnreadNotificationCount(repository).call(), const Right<Failure, int>(2));
    });

    test('MarkNotificationRead', () async {
      final read = intervalNotification(read: true);
      when(() => repository.markRead('n1')).thenAnswer((_) async => Right(read));
      expect(
        await MarkNotificationRead(repository).call('n1'),
        Right<Failure, AppNotification>(read),
      );
    });

    test('MarkAllNotificationsRead', () async {
      when(() => repository.markAllRead()).thenAnswer((_) async => const Left(Failure('x')));
      expect(
        await MarkAllNotificationsRead(repository).call(),
        const Left<Failure, int>(Failure('x')),
      );
    });
  });
}
