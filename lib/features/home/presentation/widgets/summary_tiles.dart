import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// The three Home tiles: this year's total cost ([onOpenCost]), the invoice count
/// ([onOpenInvoices]) and the items needing attention ([onOpenAttention]; `null` when nothing is
/// due, then the tile is not tappable).
class SummaryTiles extends StatelessWidget {
  const SummaryTiles({
    super.key,
    required this.yearTotalCost,
    required this.invoiceCount,
    required this.attentionCount,
    required this.onOpenCost,
    required this.onOpenInvoices,
    required this.onOpenAttention,
  });

  final int yearTotalCost;
  final int invoiceCount;
  final int attentionCount;
  final VoidCallback onOpenCost;
  final VoidCallback onOpenInvoices;
  final VoidCallback? onOpenAttention;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final amber = AppTones.of(context).amber;
    final number = NumberFormat.decimalPattern(l10n.localeName);
    const gap = SizedBox(width: 4);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _SummaryTile(
              title: l10n.homeCostThisYear,
              value: number.format(yearTotalCost),
              valueStyle: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              unit: l10n.currencyToman,
              footer: l10n.homeCostFooter,
              onTap: onOpenCost,
            ),
          ),
          gap,
          Expanded(
            child: _SummaryTile(
              title: l10n.homeInvoicesTitle,
              value: number.format(invoiceCount),
              valueStyle: AppTextStyles.metricOdometer,
              unit: l10n.homeInvoicesUnit,
              footer: l10n.homeInvoicesFooter,
              onTap: onOpenInvoices,
            ),
          ),
          gap,
          Expanded(
            child: _SummaryTile(
              title: l10n.homeAttentionTitle,
              value: number.format(attentionCount),
              valueStyle: AppTextStyles.metricOdometer,
              unit: l10n.homeAttentionUnit,
              footer: l10n.homeAttentionFooter,
              onTap: onOpenAttention,
              background: amber.background,
              labelColor: amber.chipForeground,
              accentColor: amber.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

/// One tile: title, the value with its unit, and a link line.
/// White by default; the attention tile passes the amber colors.
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.title,
    required this.value,
    required this.valueStyle,
    required this.unit,
    required this.footer,
    required this.onTap,
    this.background,
    this.labelColor,
    this.accentColor,
  });

  final String title;
  final String value;
  final TextStyle? valueStyle;
  final String unit;
  final String footer;
  final VoidCallback? onTap;
  final Color? background;
  final Color? labelColor;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final label = labelColor ?? scheme.onSurfaceVariant;
    final radius = BorderRadius.circular(12);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: background == null ? Border.all(color: scheme.outlineVariant) : null,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: background ?? scheme.surfaceContainerLowest,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(color: label),
                ),
                const SizedBox(height: 8),
                // Large sums shrink to fit instead of being cut off.
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: valueStyle?.copyWith(color: accentColor ?? scheme.onSurface),
                  ),
                ),
                const SizedBox(height: 2),
                Text(unit, style: theme.textTheme.labelSmall?.copyWith(color: label)),
                const SizedBox(height: 8),
                Text(
                  footer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: accentColor == null ? null : FontWeight.w600,
                    color: accentColor ?? scheme.secondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
