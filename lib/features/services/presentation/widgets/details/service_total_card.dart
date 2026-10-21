import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';

/// The navy totals card: the heading, then "مبلغ نهایی فاکتور" with [totalCost] in odometer digits.
class ServiceTotalCard extends StatelessWidget {
  const ServiceTotalCard({super.key, required this.totalCost});

  final int totalCost;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final faint = scheme.onPrimary.withValues(alpha: 0.7);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.12), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.serviceDetailsTotalTitle,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: faint),
          ),
          Divider(height: 20, color: scheme.onPrimary.withValues(alpha: 0.1)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  l10n.serviceDetailsTotalLabel,
                  style: theme.textTheme.bodySmall?.copyWith(color: faint),
                ),
              ),
              Text(
                NumberFormat.decimalPattern(l10n.localeName).format(totalCost),
                style: AppTextStyles.metricOdometer.copyWith(color: scheme.onPrimary),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  l10n.currencyToman,
                  style: theme.textTheme.bodySmall?.copyWith(color: faint),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
