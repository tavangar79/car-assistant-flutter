import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/plate_badge.dart';
import '../../../vehicles/presentation/widgets/vehicle_photo_thumb.dart';

/// "دامنه خودروی گزارش": the single-vehicle / every-vehicle segment, then the [vehicle] card
/// (faded while every vehicle is chosen). Without a [vehicle] only "همه خودروها" is offered.
class ReportScopeCard extends StatelessWidget {
  const ReportScopeCard({
    super.key,
    required this.vehicle,
    required this.vehicleCount,
    required this.allVehicles,
    required this.onChanged,
  });

  final Vehicle? vehicle;
  final int vehicleCount;
  final bool allVehicles;

  /// Called with `true` for "همه خودروها".
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final vehicle = this.vehicle;
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.reportScopeTitle,
                  style: theme.textTheme.labelMedium?.copyWith(color: muted),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.reportScopeChangeable,
                  style: theme.textTheme.labelSmall?.copyWith(color: muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SegmentedToggle(
            selected: allVehicles || vehicle == null ? 1 : 0,
            onSelected: (index) => onChanged(index == 1),
            segments: [
              if (vehicle != null)
                (icon: Icons.directions_car, label: vehicle.nickname, trailing: null),
              (
                icon: Icons.garage_outlined,
                label: l10n.reportScopeAll(vehicleCount),
                trailing: null,
              ),
            ],
          ),
          if (vehicle != null) ...[
            const SizedBox(height: 8),
            AnimatedOpacity(
              opacity: allVehicles ? 0.5 : 1,
              duration: const Duration(milliseconds: 200),
              child: _VehicleRow(vehicle: vehicle),
            ),
          ],
        ],
      ),
    );
  }
}

/// The chosen vehicle: photo, nickname, model year and make, and the plate.
class _VehicleRow extends StatelessWidget {
  const _VehicleRow({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final subtitle = [
      '${vehicle.make.name} ${vehicle.model.name}',
      l10n.vehicleDetailsModelYear(localizeDigits('${vehicle.yearJalali}', l10n.localeName)),
    ].join(' • ');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          VehiclePhotoThumb(photoUrl: vehicle.photoUrl, radius: 12),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.nickname,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: AppTones.of(context).muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PlateBadge(plate: vehicle.plate, dense: true),
        ],
      ),
    );
  }
}
