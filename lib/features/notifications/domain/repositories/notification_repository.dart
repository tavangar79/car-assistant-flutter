import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_notification.dart';
import '../entities/notification_inbox.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class NotificationRepository {
  /// The inbox, newest first (the server syncs reminders before answering).
  Future<Either<Failure, NotificationInbox>> getNotifications();

  /// The number of unread notifications (the app-bar badge).
  Future<Either<Failure, int>> getUnreadCount();

  /// Marks one notification read (idempotent) and returns it.
  Future<Either<Failure, AppNotification>> markRead(String id);

  /// Marks every notification read; returns how many changed.
  Future<Either<Failure, int>> markAllRead();
}
