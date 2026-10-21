import 'package:equatable/equatable.dart';

import 'app_notification.dart';

/// The inbox: newest first (at most 100), and how many are unread.
class NotificationInbox extends Equatable {
  const NotificationInbox({required this.notifications, required this.unreadCount});

  final List<AppNotification> notifications;
  final int unreadCount;

  /// The inbox with [id] read.
  NotificationInbox withRead(String id) {
    final wasUnread = notifications.any((n) => n.id == id && !n.read);
    return NotificationInbox(
      notifications: [for (final n in notifications) n.id == id ? n.markedRead() : n],
      unreadCount: wasUnread && unreadCount > 0 ? unreadCount - 1 : unreadCount,
    );
  }

  /// The inbox with everything read.
  NotificationInbox allRead() => NotificationInbox(
    notifications: [for (final n in notifications) n.read ? n : n.markedRead()],
    unreadCount: 0,
  );

  @override
  List<Object?> get props => [notifications, unreadCount];
}
