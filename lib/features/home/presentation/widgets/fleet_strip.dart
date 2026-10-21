import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/widgets/vehicle_photo_thumb.dart';

/// "گاراژ من" on Home: the title with the vehicle count, the "مدیریت" link ([onManage]) and a
/// scrollable row of vehicle chips ([onOpenVehicle]).
class FleetStrip extends StatelessWidget {
  const FleetStrip({
    super.key,
    required this.vehicles,
    required this.onManage,
    required this.onOpenVehicle,
  });

  final List<Vehicle> vehicles;
  final VoidCallback onManage;
  final ValueChanged<Vehicle> onOpenVehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                l10n.navGarage,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                l10n.garageVehicleCount(vehicles.length),
                style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onManage,
              style: TextButton.styleFrom(
                foregroundColor: scheme.secondary,
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                textStyle: theme.textTheme.labelMedium,
              ),
              child: Text(l10n.homeFleetManage),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              for (final (index, vehicle) in vehicles.indexed) ...[
                if (index > 0) const SizedBox(width: 8),
                _VehicleChip(vehicle: vehicle, onTap: () => onOpenVehicle(vehicle)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A pill with the vehicle's round photo and nickname.
class _VehicleChip extends StatelessWidget {
  const _VehicleChip({required this.vehicle, required this.onTap});

  final Vehicle vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: scheme.surfaceContainerLowest,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 48,
            padding: const EdgeInsetsDirectional.only(start: 10, end: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VehiclePhotoThumb(photoUrl: vehicle.photoUrl, size: 28, radius: 14),
                const SizedBox(width: 6),
                Text(
                  vehicle.nickname,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
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
