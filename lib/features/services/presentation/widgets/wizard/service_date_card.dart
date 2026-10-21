import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../service_formats.dart';
import 'wizard_card.dart';

/// Which quick date chip is active.
enum ServiceDateChip { today, yesterday, lastWeek }

/// "تاریخ ثبت فاکتور": the chosen Jalali date with its weekday, a calendar button and the quick
/// chips today / yesterday / last week / pick from calendar.
class ServiceDateCard extends StatelessWidget {
  const ServiceDateCard({
    super.key,
    required this.date,
    required this.now,
    required this.onChip,
    required this.onPick,
  });

  /// The chosen day (local).
  final DateTime date;
  final DateTime now;
  final ValueChanged<ServiceDateChip> onChip;
  final VoidCallback onPick;

  /// The chip that matches [date] against [now], if any.
  static ServiceDateChip? chipOf(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final back = today.difference(day).inDays;
    return switch (back) {
      0 => ServiceDateChip.today,
      1 => ServiceDateChip.yesterday,
      7 => ServiceDateChip.lastWeek,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final active = chipOf(date, now);
    return WizardCard(
      icon: Icons.calendar_month,
      title: l10n.serviceDateTitle,
      trailing: Text(
        l10n.serviceDateBadge,
        style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.event_available, size: 22, color: scheme.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.serviceDateLabel,
                        style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      Text(
                        formatServiceDate(date, l10n),
                        style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.serviceDatePick,
                  onPressed: onPick,
                  style: IconButton.styleFrom(
                    backgroundColor: scheme.surfaceContainerLowest,
                    foregroundColor: scheme.onSurface,
                    minimumSize: const Size(44, 44),
                  ),
                  icon: const Icon(Icons.calendar_today, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final chip in ServiceDateChip.values) ...[
                  _Chip(
                    label: switch (chip) {
                      ServiceDateChip.today => l10n.serviceDateToday,
                      ServiceDateChip.yesterday => l10n.serviceDateYesterday,
                      ServiceDateChip.lastWeek => l10n.serviceDateLastWeek,
                    },
                    selected: chip == active,
                    onTap: () => onChip(chip),
                  ),
                  const SizedBox(width: 6),
                ],
                _Chip(
                  label: l10n.serviceDatePick,
                  selected: false,
                  icon: Icons.expand_more,
                  onTap: onPick,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap, this.icon});

  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 44),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        backgroundColor: selected ? scheme.primary : scheme.surfaceContainer,
        foregroundColor: selected
            ? scheme.onPrimary
            : icon == null
            ? scheme.onSurface
            : scheme.secondary,
        textStyle: theme.textTheme.labelMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (icon case final icon?) ...[const SizedBox(width: 4), Icon(icon, size: 16)],
        ],
      ),
    );
  }
}
