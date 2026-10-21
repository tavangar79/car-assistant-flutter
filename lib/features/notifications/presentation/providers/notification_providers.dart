import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/notification_inbox.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/get_unread_notification_count.dart';
import '../../domain/usecases/mark_all_notifications_read.dart';
import '../../domain/usecases/mark_notification_read.dart';
import 'notifications_controller.dart';

// Dependency wiring for the notifications feature. Override [notificationRepositoryProvider] in
// tests.

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(NotificationRemoteDataSource(ref.watch(dioProvider)));
});

final getNotificationsProvider = Provider<GetNotifications>((ref) {
  return GetNotifications(ref.watch(notificationRepositoryProvider));
});

final getUnreadNotificationCountProvider = Provider<GetUnreadNotificationCount>((ref) {
  return GetUnreadNotificationCount(ref.watch(notificationRepositoryProvider));
});

final markNotificationReadProvider = Provider<MarkNotificationRead>((ref) {
  return MarkNotificationRead(ref.watch(notificationRepositoryProvider));
});

final markAllNotificationsReadProvider = Provider<MarkAllNotificationsRead>((ref) {
  return MarkAllNotificationsRead(ref.watch(notificationRepositoryProvider));
});

/// The unread count of the app-bar bell, shared by every app bar. Invalidated after a read or
/// read-all and when the notifications page closes.
final unreadNotificationCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final count = await ref.watch(getUnreadNotificationCountProvider).call();
  return count.getOrElse((failure) => throw failure);
});

/// The inbox of the notifications page, with its read and read-all actions.
final notificationsControllerProvider =
    AsyncNotifierProvider.autoDispose<NotificationsController, NotificationInbox>(
      NotificationsController.new,
    );
