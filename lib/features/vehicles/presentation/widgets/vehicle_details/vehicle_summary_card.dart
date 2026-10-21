import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/utils/localize_digits.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/vehicle.dart';
import '../vehicle_photo_thumb.dart';
import 'details_card.dart';
import 'plate_badge.dart';

/// The vehicle's identity: 80px photo, nickname (with a green dot for the default vehicle), model
/// year, make, model and trim, the VIN, then the plate.
class VehicleSummaryCard extends StatelessWidget {
  const VehicleSummaryCard({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final summary = [
      l10n.vehicleDetailsModelYear(localizeDigits('${vehicle.yearJalali}', l10n.localeName)),
      vehicle.make.name,
      vehicle.model.name,
      ?vehicle.trim?.name,
    ].join(' • ');
    return DetailsCard(
      child: Column(
        children: [
          Row(
            children: [
              VehiclePhotoThumb(photoUrl: vehicle.photoUrl, size: 80, radius: 12),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vehicle.nickname,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        if (vehicle.isDefault)
                          Semantics(
                            label: l10n.vehicleDetailsActive,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppTones.of(context).ok.foreground,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(summary, style: theme.textTheme.bodySmall?.copyWith(color: muted)),
                    if (vehicle.vin case final vin?) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.verified_outlined, size: 15, color: scheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              l10n.vehicleDetailsVin(vin),
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PlateBadge(plate: vehicle.plate),
        ],
      ),
    );
  }
}
