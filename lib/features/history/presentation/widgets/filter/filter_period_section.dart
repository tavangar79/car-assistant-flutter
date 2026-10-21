import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/history_filter.dart';
import '../../../domain/entities/history_period.dart';
import '../history_formats.dart';
import 'filter_section.dart';

/// "بازه زمانی ثبت": four chips (current year, last six months, all time, custom) and, for a
/// custom range, the chosen days under them.
class FilterPeriodSection extends StatelessWidget {
  const FilterPeriodSection({
    super.key,
    required this.filter,
    required this.now,
    required this.onSelected,
  });

  final HistoryFilter filter;
  final DateTime now;

  /// Called with the tapped period; the page asks for the days of [HistoryPeriod.custom].
  final ValueChanged<HistoryPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    Widget chip(HistoryPeriod period, IconData icon, String label, {bool chevron = false}) =>
        _PeriodChip(
          icon: icon,
          label: label,
          selected: filter.period == period,
          chevron: chevron,
          onTap: () => onSelected(period),
        );
    return FilterSection(
      title: l10n.historyFilterPeriod,
      trailing: Text(
        l10n.historyFilterCalendar,
        style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 52,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              chip(
                HistoryPeriod.currentYear,
                Icons.calendar_today,
                l10n.historyPeriodCurrentYear(jalaliYearText(now, l10n)),
              ),
              chip(HistoryPeriod.lastSixMonths, Icons.history, l10n.historyPeriodSixMonths),
              chip(HistoryPeriod.allTime, Icons.all_inclusive, l10n.historyPeriodAll),
              chip(HistoryPeriod.custom, Icons.date_range, l10n.historyPeriodCustom, chevron: true),
            ],
          ),
          if (filter.period == HistoryPeriod.custom && filter.customFrom != null) ...[
            const SizedBox(height: 8),
            Text(
              customRangeText(filter, l10n),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurface),
            ),
          ],
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.chevron,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool chevron;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurface;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? scheme.primary : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        elevation: 0.5,
        shadowColor: scheme.shadow.withValues(alpha: 0.2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 18, color: selected ? foreground : scheme.secondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(color: foreground),
                  ),
                ),
                if (selected && !chevron)
                  Icon(Icons.check, size: 16, color: foreground)
                else if (chevron)
                  // chevron_right mirrors to point left (forward) in RTL.
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: selected ? foreground : scheme.outline,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
