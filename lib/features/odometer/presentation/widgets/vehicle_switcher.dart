import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/widgets/vehicle_photo_thumb.dart';
import '../../../vehicles/presentation/widgets/plate_text.dart';

/// "انتخاب خودرو": a horizontal strip of vehicle chips; the [selectedId] one is navy.
class VehicleSwitcher extends StatelessWidget {
  const VehicleSwitcher({
    super.key,
    required this.vehicles,
    required this.selectedId,
    required this.onSelected,
  });

  final List<Vehicle> vehicles;
  final String selectedId;
  final ValueChanged<Vehicle> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final neutral = AppTones.of(context).neutral;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.odometerPickVehicle,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: neutral.chipBackground,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                l10n.activeVehicleBadge,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: neutral.foreground,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final vehicle in vehicles) ...[
                _VehicleChip(
                  vehicle: vehicle,
                  selected: vehicle.id == selectedId,
                  onTap: () => onSelected(vehicle),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _VehicleChip extends StatelessWidget {
  const _VehicleChip({required this.vehicle, required this.selected, required this.onTap});

  final Vehicle vehicle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurfaceVariant;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? scheme.primary : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VehiclePhotoThumb(photoUrl: vehicle.photoUrl, size: 36),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          vehicle.nickname,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            color: foreground,
                          ),
                        ),
                        if (vehicle.isDefault) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.verified, size: 14, color: foreground),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plateText(vehicle.plate, l10n),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        color: selected ? scheme.onPrimary : scheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
