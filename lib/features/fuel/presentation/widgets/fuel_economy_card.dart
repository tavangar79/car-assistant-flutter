import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/fuel_economy.dart';
import 'fuel_formats.dart';

/// "میانگین مصرف این دوره": the preview economy in large digits with its unit, how it was
/// computed and the full-tank footnote; or "قابل محاسبه نیست" with why.
class FuelEconomyCard extends StatelessWidget {
  const FuelEconomyCard({super.key, required this.preview, required this.unit});

  final FuelEconomyPreview? preview;

  /// "لیتر" or "متر مکعب", by the chosen fuel type.
  final String unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final preview = this.preview;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tones.info.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.insights, size: 18, color: tones.info.foreground),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.fuelEconomyTitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (preview == null)
            Text(
              l10n.notComputable,
              style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
            )
          else
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: formatDecimal(preview.economy, l10n.localeName),
                    style: AppTextStyles.metricOdometer.copyWith(color: scheme.onSurface),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: l10n.fuelEconomyUnit(unit),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          if (preview != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.check_circle_outline, size: 14, color: scheme.onSurface),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.fuelEconomyBreakdown(
                      preview.distanceKm,
                      formatDecimal(preview.volume, l10n.localeName),
                      unit,
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurface),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          Text(
            preview == null ? l10n.fuelEconomyUnavailable : l10n.fuelEconomyDisclaimer,
            style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
