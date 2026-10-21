import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/history_month_group.dart';
import 'history_formats.dart';

/// The header of a month group: `آبان ۱۴۰۳`, the count badge, and the cost total of the loaded
/// entries of that month.
class HistoryMonthHeader extends StatelessWidget {
  const HistoryMonthHeader({super.key, required this.group});

  final HistoryMonthGroup group;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Text(
            jalaliMonthYear(group.year, group.month, l10n),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              l10n.historyMonthCount(group.entries.length),
              style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${formatAmount(group.totalCost, l10n.localeName)} ${l10n.historyToman}',
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(color: scheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
