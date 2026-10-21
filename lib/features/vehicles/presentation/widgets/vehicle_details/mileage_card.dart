import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/widgets/format_jalali_date.dart';
import 'details_card.dart';

/// "کارکرد فعلی خودرو": the mileage in odometer digits, the date of the latest reading (hidden
/// when there is none) and the amber "بروزرسانی کیلومتر" button.
class MileageCard extends StatelessWidget {
  const MileageCard({
    super.key,
    required this.mileageKm,
    required this.lastReadingAt,
    required this.onUpdate,
  });

  final int mileageKm;
  final DateTime? lastReadingAt;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final date = lastReadingAt;
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.speed, size: 18, color: tones.muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.vehicleDetailsMileageTitle,
                  style: theme.textTheme.labelMedium?.copyWith(color: tones.muted),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.vehicleDetailsMileageBadge,
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                NumberFormat.decimalPattern(l10n.localeName).format(mileageKm),
                style: AppTextStyles.metricOdometer.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(width: 4),
              Text(
                l10n.vehicleMileageUnit,
                style: theme.textTheme.labelLarge?.copyWith(color: tones.muted),
              ),
              const SizedBox(width: 8),
              if (date != null)
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, size: 15, color: tones.success),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              formatJalaliDate(date.toLocal(), l10n),
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onUpdate,
            style: FilledButton.styleFrom(
              backgroundColor: scheme.tertiary,
              foregroundColor: scheme.onTertiary,
            ),
            icon: const Icon(Icons.add_circle_outline, size: 20),
            label: Text(l10n.vehicleDetailsUpdateMileage),
          ),
        ],
      ),
    );
  }
}
