import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// The `more_vert` options of a vehicle (Stitch open menu `bd81cbb1ef6f4257a92913f4822158fc`) with
/// the edit action. Used by the garage list and the vehicle details page.
class VehicleOptionsMenu extends StatelessWidget {
  const VehicleOptionsMenu({super.key, required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return PopupMenuButton<VoidCallback>(
      tooltip: l10n.vehicleOptions,
      icon: const Icon(Icons.more_vert),
      color: scheme.surfaceContainerLowest,
      elevation: 6,
      constraints: const BoxConstraints.tightFor(width: 192),
      menuPadding: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      onSelected: (action) => action(),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: onEdit,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20, color: scheme.secondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.editVehicle,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
