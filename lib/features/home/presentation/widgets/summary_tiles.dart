import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// The three Home tiles: total cost this year, invoices and items needing attention. Their records
/// don't exist yet, so each value is "—" (read as "قابل محاسبه نیست"). Each tile opens [onOpen].
class SummaryTiles extends StatelessWidget {
  const SummaryTiles({super.key, required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final amber = AppTones.of(context).amber;
    const gap = SizedBox(width: 4);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            // TODO(phase-3): this year's total of services, fuel and expenses.
            child: _SummaryTile(
              title: l10n.homeCostThisYear,
              valueStyle: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              unit: l10n.currencyToman,
              footer: l10n.homeCostFooter,
              onTap: onOpen,
            ),
          ),
          gap,
          Expanded(
            // TODO(phase-2): number of service invoices.
            child: _SummaryTile(
              title: l10n.homeInvoicesTitle,
              valueStyle: AppTextStyles.metricOdometer,
              unit: l10n.homeInvoicesUnit,
              footer: l10n.homeInvoicesFooter,
              onTap: onOpen,
            ),
          ),
          gap,
          Expanded(
            // TODO(phase-2): number of due / overdue intervals across the garage.
            child: _SummaryTile(
              title: l10n.homeAttentionTitle,
              valueStyle: AppTextStyles.metricOdometer,
              unit: l10n.homeAttentionUnit,
              footer: l10n.homeAttentionFooter,
              onTap: onOpen,
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

/// One tile: title, the value ("—" for now) with its unit, and a link line.
/// White by default; the attention tile passes the amber colors.
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.title,
    required this.valueStyle,
    required this.unit,
    required this.footer,
    required this.onTap,
    this.background,
    this.labelColor,
    this.accentColor,
  });

  final String title;
  final TextStyle? valueStyle;
  final String unit;
  final String footer;
  final VoidCallback onTap;
  final Color? background;
  final Color? labelColor;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                Semantics(
                  label: l10n.notComputable,
                  excludeSemantics: true,
                  child: Text(
                    l10n.valueUnavailable,
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
