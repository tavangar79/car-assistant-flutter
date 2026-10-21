import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/utils/calendar_days_ago.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../domain/entities/vehicle.dart';

/// "کیلومترشمار فعلی" of a garage card: the vehicle's mileage and how long ago its latest odometer
/// reading was taken ("آخرین ثبت: دیروز"), or "—" while there is none.
class VehicleOdometerRow extends ConsumerWidget {
  const VehicleOdometerRow({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final latest = ref.watch(odometerReadingsProvider(vehicle.id)).value?.firstOrNull;
    final now = ref.watch(clockProvider)();
    final when = latest == null
        ? l10n.valueUnavailable
        : l10n.relativeDaysAgo(calendarDaysAgo(latest.recordedAt, now));
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.speed, size: 20, color: scheme.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.garageOdometerLabel,
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                ),
                Text(
                  l10n.garageLastReading(when),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(color: tones.muted),
                ),
              ],
            ),
          ),
          Text(
            NumberFormat.decimalPattern(l10n.localeName).format(vehicle.mileageKm),
            style: AppTextStyles.metricOdometer.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(width: 4),
          Text(
            l10n.vehicleMileageUnit,
            style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
          ),
        ],
      ),
    );
  }
}
