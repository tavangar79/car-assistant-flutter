import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../services/presentation/widgets/service_icon_tile.dart';
import '../../domain/entities/due_item.dart';
import '../../domain/entities/due_status.dart';
import 'due_texts.dart';

/// One due interval (Stitch `5686e3f9f6cf403cb2aa717c13b9ccdc`): tinted icon tile, title and
/// description, the status badge, the remaining line with the due odometer, then the action that
/// opens the service wizard. Overdue items get the amber accent button.
class DueItemCard extends StatelessWidget {
  const DueItemCard({super.key, required this.item, required this.onRecord});

  final DueItem item;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final tone = dueStatusTone(item.status, tones);
    final overdue = item.status == DueStatus.overdue;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceIconTile(icon: item.icon, tone: tone, iconSize: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              DueStatusBadge(status: item.status),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: overdue ? tone.background : scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(dueRemainingIcon(item.status), size: 16, color: tone.foreground),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    dueRemainingText(item, l10n),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: overdue ? tone.chipForeground : scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.dueAtKm(item.dueKm),
                  style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRecord,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: switch (item.status) {
                DueStatus.overdue => scheme.tertiary,
                DueStatus.dueSoon => scheme.primary,
                DueStatus.upcoming || DueStatus.ok => scheme.surfaceContainer,
              },
              foregroundColor: switch (item.status) {
                DueStatus.overdue => scheme.onTertiary,
                DueStatus.dueSoon => scheme.onPrimary,
                DueStatus.upcoming || DueStatus.ok => scheme.onSurface,
              },
              textStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: overdue ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            icon: Icon(overdue ? Icons.build_outlined : Icons.add_task, size: 20),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    overdue ? l10n.dueActionOverdue : l10n.dueActionRecord,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                // chevron_right mirrors to point left (forward) in RTL.
                const Icon(Icons.chevron_right, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The pill with the status word, tinted by status.
class DueStatusBadge extends StatelessWidget {
  const DueStatusBadge({super.key, required this.status});

  final DueStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tone = dueStatusTone(status, AppTones.of(context));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tone.chipBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        dueStatusLabel(status, l10n),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: tone.chipForeground,
        ),
      ),
    );
  }
}
