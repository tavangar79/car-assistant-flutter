import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Top bar of the history page (Stitch "تاریخچه"): the title with the vehicle chip next to it,
/// and the tune button that opens the filter at the end. 64px high.
class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HistoryAppBar({
    super.key,
    required this.vehicleLabel,
    required this.onVehicleTap,
    required this.onFilterTap,
  });

  final String vehicleLabel;
  final VoidCallback onVehicleTap;
  final VoidCallback onFilterTap;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      scrolledUnderElevation: 1,
      shadowColor: scheme.shadow.withValues(alpha: 0.04),
      title: Row(
        children: [
          Text(
            l10n.navHistory,
            style: theme.textTheme.headlineLarge?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: _VehicleChip(label: vehicleLabel, onTap: onVehicleTap),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: l10n.historyFilterTooltip,
          onPressed: onFilterTap,
          iconSize: 24,
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          style: IconButton.styleFrom(shape: const CircleBorder()),
          color: scheme.onSurfaceVariant,
          icon: const Icon(Icons.tune),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

/// The pill with the shown vehicles; a 48px touch target around a 32px pill.
class _VehicleChip extends StatelessWidget {
  const _VehicleChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).historyChooseVehicle,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(minHeight: 32),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.directions_car, size: 16, color: scheme.secondary),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurface),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: scheme.secondary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
