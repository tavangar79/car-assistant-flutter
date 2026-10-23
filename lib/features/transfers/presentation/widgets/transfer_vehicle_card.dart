import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/presentation/widgets/history_formats.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/plate_badge.dart';

/// The vehicle being transferred (Stitch "انتقال مالکیت خودرو"): nickname, model year and VIN,
/// the "فعال در گاراژ" chip, then the plate and the current mileage.
class TransferVehicleCard extends StatelessWidget {
  const TransferVehicleCard({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final subtitle = [
      l10n.vehicleDetailsModelYear(localizeDigits('${vehicle.yearJalali}', l10n.localeName)),
      ?vehicle.vin,
    ].join(' • ');
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.directions_car, color: scheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.nickname,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: muted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.transferActiveInGarage,
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                PlateBadge(plate: vehicle.plate, dense: true),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.speed, size: 16, color: muted),
                    const SizedBox(width: 4),
                    Text(
                      l10n.transferMileage,
                      style: theme.textTheme.labelMedium?.copyWith(color: muted),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatAmount(vehicle.mileageKm, l10n.localeName),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.transferKm,
                      style: theme.textTheme.labelMedium?.copyWith(color: muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
