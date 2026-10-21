import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/notification_inbox.dart';
import 'notification_providers.dart';

/// Loads the inbox and marks notifications read. Each write updates the inbox in place and
/// refreshes the app-bar badge.
class NotificationsController extends AsyncNotifier<NotificationInbox> {
  @override
  Future<NotificationInbox> build() async {
    final inbox = await ref.watch(getNotificationsProvider).call();
    return inbox.getOrElse((failure) => throw failure);
  }

  /// Marks [id] read (nothing is sent when it is read already). Returns whether it is read now.
  Future<bool> markRead(String id) async {
    final inbox = state.value;
    if (inbox == null) return false;
    if (inbox.notifications.any((n) => n.id == id && n.read)) return true;
    final result = await ref.read(markNotificationReadProvider).call(id);
    if (!ref.mounted || result.isLeft()) return false;
    state = AsyncData((state.value ?? inbox).withRead(id));
    ref.invalidate(unreadNotificationCountProvider);
    return true;
  }

  /// Marks every notification read. Returns whether it worked.
  Future<bool> markAllRead() async {
    final result = await ref.read(markAllNotificationsReadProvider).call();
    if (!ref.mounted || result.isLeft()) return false;
    if (state.value case final inbox?) state = AsyncData(inbox.allRead());
    ref.invalidate(unreadNotificationCountProvider);
    return true;
  }
}
