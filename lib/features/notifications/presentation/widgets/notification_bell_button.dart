import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/notification_providers.dart';

/// The app-bar bell shared by the tabs: opens the notifications page and shows the unread count
/// as a badge (nothing while loading or when the count can't be loaded). The count is refreshed
/// when the page closes.
class NotificationBellButton extends ConsumerWidget {
  const NotificationBellButton({super.key, this.iconSize = 24});

  /// Largest count written in the badge; more shows "۹+".
  static const maxShown = 9;

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final count = ref.watch(unreadNotificationCountProvider).value ?? 0;
    final number = NumberFormat.decimalPattern(l10n.localeName);
    return IconButton(
      tooltip: l10n.notificationsUnreadLabel(count),
      onPressed: () async {
        await context.push(AppRoutes.notificationsPath);
        if (context.mounted) ref.invalidate(unreadNotificationCountProvider);
      },
      iconSize: iconSize,
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      color: scheme.onSurfaceVariant,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(count > maxShown ? '${number.format(maxShown)}+' : number.format(count)),
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
