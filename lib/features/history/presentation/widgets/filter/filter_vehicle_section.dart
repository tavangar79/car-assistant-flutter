import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../vehicles/domain/entities/vehicle.dart';
import '../../../../vehicles/presentation/widgets/vehicle_details/plate_badge.dart';
import '../../../../vehicles/presentation/widgets/vehicle_form/color_swatches.dart';
import 'filter_section.dart';

/// "خودرو (محدوده جستجو)": one card per vehicle (multi-select) and "همه خودروهای گاراژ".
class FilterVehicleSection extends StatelessWidget {
  const FilterVehicleSection({
    super.key,
    required this.vehicles,
    required this.selectedIds,
    required this.onToggle,
    required this.onSelectAll,
  });

  final List<Vehicle> vehicles;

  /// Empty means every vehicle.
  final Set<String> selectedIds;
  final ValueChanged<Vehicle> onToggle;
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final all = selectedIds.isEmpty;
    return FilterSection(
      title: l10n.historyFilterVehicles,
      hint: l10n.historyFilterVehiclesHint,
      trailing: FilterPill(
        text: l10n.historyFilterSelectedVehicles(all ? vehicles.length : selectedIds.length),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final vehicle in vehicles) ...[
            _VehicleCard(
              vehicle: vehicle,
              selected: selectedIds.contains(vehicle.id),
              onTap: () => onToggle(vehicle),
            ),
            const SizedBox(height: 8),
          ],
          _AllVehiclesCard(count: vehicles.length, selected: all, onTap: onSelectAll),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.vehicle, required this.selected, required this.onTap});

  final Vehicle vehicle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        elevation: 0.5,
        shadowColor: scheme.shadow.withValues(alpha: 0.2),
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: BorderDirectional(
                start: BorderSide(color: selected ? scheme.primary : Colors.transparent, width: 6),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected ? scheme.primary : scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_car,
                    color: selected ? scheme.onPrimary : scheme.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              vehicle.nickname,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: scheme.onSurface,
                              ),
                            ),
                          ),
                          if (vehicle.color case final color?) ...[
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                ColorSwatches.nameOf(color, l10n),
                                overflow: TextOverflow.clip,
                                softWrap: false,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        l10n.historyFilterMileage(vehicle.mileageKm),
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PlateBadge(plate: vehicle.plate, dense: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AllVehiclesCard extends StatelessWidget {
  const _AllVehiclesCard({required this.count, required this.selected, required this.onTap});

  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 76),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.garage_outlined, color: scheme.secondary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.historyFilterAllVehicles,
                          style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                        ),
                        Text(
                          l10n.historyFilterAllVehiclesHint(count),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    size: 20,
                    color: selected ? scheme.primary : scheme.outline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
