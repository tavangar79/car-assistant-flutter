import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../transfers/presentation/widgets/incoming_transfers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_category.dart';
import '../../domain/entities/notification_inbox.dart';
import '../../domain/entities/notification_kind.dart';
import '../providers/notification_providers.dart';
import '../providers/notifications_controller.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_filter_chips.dart';

/// "صندوق اعلانات" (Stitch `5b8dd2f6f8294f8e93ae15a912e4b372`): the unread count with
/// "خواندن همه", the category chips (filtered on the client), the notifications and the 90-day
/// footer. Tapping one marks it read and opens what it is about. A full page above the tabs.
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  /// `null` shows every category.
  NotificationCategory? _filter;

  NotificationsController get _controller => ref.read(notificationsControllerProvider.notifier);

  Future<void> _open(AppNotification notification) async {
    await _controller.markRead(notification.id);
    if (!mounted) return;
    final vehicleId = notification.vehicleId;
    switch (notification.kind) {
      case NotificationKind.intervalDueSoon || NotificationKind.intervalOverdue:
        context.push(AppRoutes.duePath(vehicleId));
      case NotificationKind.documentExpiry:
        context.push(AppRoutes.documentsPath(vehicleId));
      // The vehicle details live inside the Garage tab, so go there instead of pushing.
      case NotificationKind.expenseExpiry:
        context.go(AppRoutes.vehicleDetailsPath(vehicleId));
    }
  }

  Future<void> _addService(AppNotification notification) async {
    await _controller.markRead(notification.id);
    if (mounted) context.push(AppRoutes.newServicePath(notification.vehicleId));
  }

  Future<void> _readAll() async {
    final messenger = ScaffoldMessenger.of(context);
    final message = AppLocalizations.of(context).notificationsActionFailed;
    if (!await _controller.markAllRead()) {
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final inbox = ref.watch(notificationsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        scrolledUnderElevation: 1,
        shadowColor: scheme.shadow.withValues(alpha: 0.04),
        leading: IconButton(
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: Text(
          l10n.notificationsTitle,
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Semantics(
            label: l10n.accountLabel,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primary,
              child: Icon(Icons.person, size: 18, color: scheme.onPrimary),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: inbox.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(
          message: l10n.notificationsLoadError,
          onRetry: () => ref.invalidate(notificationsControllerProvider),
        ),
        data: _inbox,
      ),
    );
  }

  Widget _inbox(NotificationInbox inbox) {
    final now = ref.watch(clockProvider)();
    final names = {
      for (final vehicle in ref.watch(vehiclesProvider).value ?? const <Vehicle>[])
        vehicle.id: vehicle.nickname,
    };
    final shown = [
      for (final notification in inbox.notifications)
        if (_filter == null || notification.category == _filter) notification,
    ];
    return RefreshIndicator(
      onRefresh: () => ref.refresh(notificationsControllerProvider.future),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Pinned: incoming ownership transfers.
          const IncomingTransfers(padding: EdgeInsets.only(top: 8, bottom: 16)),
          _UnreadHeader(
            unreadCount: inbox.unreadCount,
            onReadAll: inbox.unreadCount > 0 ? _readAll : null,
          ),
          const SizedBox(height: 8),
          NotificationFilterChips(
            selected: _filter,
            total: inbox.notifications.length,
            onSelected: (category) => setState(() => _filter = category),
          ),
          const SizedBox(height: 16),
          if (shown.isEmpty)
            _EmptyFilter(onShowAll: () => setState(() => _filter = null))
          else
            for (final notification in shown) ...[
              NotificationCard(
                notification: notification,
                vehicleName: names[notification.vehicleId] ?? '',
                now: now,
                onTap: () => _open(notification),
                onAddService: () => _addService(notification),
              ),
              const SizedBox(height: 8),
            ],
          const SizedBox(height: 24),
          const _RetentionFooter(),
        ],
      ),
    );
  }
}

/// "● ۲ اعلان جدید" and "خواندن همه" (disabled when nothing is unread).
class _UnreadHeader extends StatelessWidget {
  const _UnreadHeader({required this.unreadCount, required this.onReadAll});

  final int unreadCount;
  final VoidCallback? onReadAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final blue = AppTones.of(context).info.foreground;
    return Row(
      children: [
        if (unreadCount > 0) ...[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: blue, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            l10n.notificationsNewCount(unreadCount),
            style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
          ),
        ),
        TextButton.icon(
          onPressed: onReadAll,
          style: TextButton.styleFrom(
            foregroundColor: blue,
            minimumSize: const Size(48, 48),
            textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          icon: const Icon(Icons.done_all, size: 18),
          label: Text(l10n.notificationsReadAll),
        ),
      ],
    );
  }
}

/// The empty state of a chip: icon, title, body and "مشاهده همه اعلان‌ها".
class _EmptyFilter extends StatelessWidget {
  const _EmptyFilter({required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: scheme.surfaceContainer, shape: BoxShape.circle),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 32,
              color: scheme.secondary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.notificationsEmptyTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.notificationsEmptyBody,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onShowAll,
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
              backgroundColor: scheme.surfaceContainer,
              foregroundColor: scheme.onSurface,
              textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            child: Text(l10n.notificationsShowAll),
          ),
        ],
      ),
    );
  }
}

/// "🔒 تمامی اعلانات به مدت ۹۰ روز در تاریخچه حفظ می‌گردند".
class _RetentionFooter extends StatelessWidget {
  const _RetentionFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.secondary.withValues(alpha: 0.7);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 16, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            AppLocalizations.of(context).notificationsRetention,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
