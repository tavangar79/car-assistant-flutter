import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../fuel/presentation/widgets/fuel_formats.dart';
import '../../domain/entities/history_summary.dart';
import 'history_formats.dart';

/// The expense overview card of the history page: the [title] of the period, the record count,
/// the cost total, and the service count and fuel litres tiles. All over the filtered set.
class HistorySummaryCard extends StatelessWidget {
  const HistorySummaryCard({super.key, required this.title, required this.summary});

  final String title;
  final HistorySummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppTheme.cardRadius,
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(color: scheme.secondary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.historySummaryCount(summary.entryCount),
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    formatAmount(summary.totalCost, l10n.localeName),
                    style: AppTextStyles.metricOdometer.copyWith(color: scheme.onSurface),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                l10n.historyToman,
                style: theme.textTheme.bodyMedium?.copyWith(color: scheme.secondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: scheme.surfaceContainerHigh),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.build,
                  label: l10n.historyServicesLabel,
                  value: l10n.historyServicesValue(summary.serviceCount),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricTile(
                  icon: Icons.local_gas_station,
                  label: l10n.historyFuelLabel,
                  value: l10n.historyFuelValue(formatDecimal(summary.fuelVolume, l10n.localeName)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                ),
                Text(value, style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
