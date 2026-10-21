import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';

/// The quick vehicle switch of the history app bar: every vehicle, or one of them.
class HistoryVehicleSheet extends StatelessWidget {
  const HistoryVehicleSheet({super.key, required this.vehicles, required this.selectedIds});

  final List<Vehicle> vehicles;
  final Set<String> selectedIds;

  /// Opens the sheet; returns the chosen vehicle ids (empty for every vehicle), or `null` when
  /// dismissed.
  static Future<Set<String>?> show(
    BuildContext context, {
    required List<Vehicle> vehicles,
    required Set<String> selectedIds,
  }) => showModalBottomSheet<Set<String>>(
    context: context,
    useRootNavigator: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => HistoryVehicleSheet(vehicles: vehicles, selectedIds: selectedIds),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(l10n.historyChooseVehicle, style: theme.textTheme.headlineSmall),
            ),
            _Option(
              icon: Icons.garage_outlined,
              label: l10n.historyFilterAllVehicles,
              selected: selectedIds.isEmpty,
              onTap: () => Navigator.of(context).pop(const <String>{}),
            ),
            for (final vehicle in vehicles)
              _Option(
                icon: Icons.directions_car,
                label: vehicle.nickname,
                selected: selectedIds.length == 1 && selectedIds.contains(vehicle.id),
                onTap: () => Navigator.of(context).pop({vehicle.id}),
              ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      minTileHeight: 64,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: scheme.secondary),
      title: Text(label),
      trailing: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? scheme.primary : scheme.outline,
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}
