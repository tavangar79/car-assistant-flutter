import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/tone_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_kind.dart';
import 'notification_formats.dart';

/// One row of the inbox (Stitch "اعلان‌ها"): a tinted icon tile, the title (with a blue dot while
/// unread), the body, then the relative time and either "ثبت سرویس" (service reminders) or the
/// days-left chip (expiry reminders). Unread rows are tinted blue.
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.vehicleName,
    required this.now,
    required this.onTap,
    required this.onAddService,
  });

  final AppNotification notification;
  final String vehicleName;
  final DateTime now;
  final VoidCallback onTap;
  final VoidCallback onAddService;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final unread = !notification.read;
    final ToneColors tone = switch (notification.kind) {
      NotificationKind.intervalDueSoon => tones.dueSoon,
      _ => tones.overdue,
    };
    return Material(
      color: unread ? tones.info.background : scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: scheme.shadow.withValues(alpha: 0.3),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tone.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification.kind.isInterval ? Icons.build : Icons.policy_outlined,
                  size: 22,
                  color: tone.foreground,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notificationTitle(notification, vehicleName, l10n),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        if (unread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: tones.info.foreground,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notificationBody(notification, vehicleName, now, l10n),
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1.6,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 14, color: scheme.secondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            formatRelativeTime(notification.createdAt, now, l10n),
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                          ),
                        ),
                        if (notification.kind.isInterval)
                          _AddServiceButton(onPressed: onAddService)
                        else
                          _DaysLeftChip(days: notificationDaysLeft(notification, now)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "ثبت سرویس ›": the small navy button of a service reminder.
class _AddServiceButton extends StatelessWidget {
  const _AddServiceButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context).notificationAddService),
          const SizedBox(width: 4),
          // chevron_right mirrors to point left (forward) in RTL.
          const Icon(Icons.chevron_right, size: 16),
        ],
      ),
    );
  }
}

/// "۱۸ روز باقیمانده" (or "منقضی شده") on red.
class _DaysLeftChip extends StatelessWidget {
  const _DaysLeftChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tone = AppTones.of(context).overdue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tone.chipBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        days > 0 ? l10n.notificationDaysLeft(days) : l10n.notificationExpired,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: tone.chipForeground,
        ),
      ),
    );
  }
}
