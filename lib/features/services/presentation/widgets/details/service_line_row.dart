import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/service_item.dart';
import '../../../domain/entities/service_line_item.dart';
import '../service_formats.dart';
import '../service_icon_tile.dart';

/// One item of a visit on the details page: icon tile, title, brand and notes, the edit and
/// delete buttons, then the reminder and the cost.
class ServiceLineRow extends StatelessWidget {
  const ServiceLineRow({
    super.key,
    required this.line,
    required this.item,
    required this.index,
    required this.baseKm,
    required this.baseDate,
    required this.onEdit,
    required this.onDelete,
  });

  final ServiceLineItem line;

  /// The catalog item, or `null` when the catalog is not loaded (the id is shown then).
  final ServiceItem? item;
  final int index;
  final int baseKm;
  final DateTime baseDate;

  /// `null` hides the button (a locked record, or an item disabled for the vehicle).
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// The reminder text, or `null` when the item has none.
  static String? reminderOf(
    ServiceLineItem line,
    int baseKm,
    DateTime baseDate,
    AppLocalizations l10n,
  ) {
    final km = line.nextDueKm;
    final months = line.nextDueMonths;
    if (km == null && months == null) return null;
    final (month, year) = months == null ? ('', '') : dueMonthYear(baseDate, months, l10n);
    if (km != null && months != null) {
      return l10n.serviceDetailsReminderBoth(baseKm + km, month, year);
    }
    if (km != null) return l10n.serviceKmValue(baseKm + km);
    return l10n.serviceDetailsReminderDate(month, year);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final tone = index == 0 ? tones.amber : tones.info;
    final subtitle = [?line.brand, ?line.notes].join(' - ');
    final reminder = reminderOf(line, baseKm, baseDate, l10n);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceIconTile(icon: item?.icon ?? '', tone: tone),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item?.title ?? line.itemId,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                      ),
                    ],
                  ],
                ),
              ),
              if (onEdit != null)
                IconButton(
                  tooltip: l10n.serviceDetailsEditItem,
                  onPressed: onEdit,
                  color: scheme.secondary,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                ),
              if (onDelete != null)
                IconButton(
                  tooltip: l10n.serviceDetailsDeleteItem,
                  onPressed: onDelete,
                  color: scheme.error,
                  icon: const Icon(Icons.delete_outline, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  reminder == null
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_active_outlined,
                  size: 17,
                  color: reminder == null ? scheme.outline : tones.amber.foreground,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    reminder == null
                        ? l10n.serviceReminderNone
                        : l10n.serviceDetailsReminder(reminder),
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  NumberFormat.decimalPattern(l10n.localeName).format(line.cost),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.currencyToman,
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
