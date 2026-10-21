import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

/// The heading above the vehicle cards: "خودروهای من", the vehicle count pill and the small
/// "افزودن خودرو" button.
class GarageHeader extends StatelessWidget {
  const GarageHeader({super.key, required this.count, required this.onAddVehicle});

  final int count;
  final VoidCallback onAddVehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Flexible(
          child: Text(
            l10n.garageMyVehicles,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              l10n.garageActiveCount(count),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.secondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Spacer(),
        FilledButton.icon(
          onPressed: onAddVehicle,
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            textStyle: theme.textTheme.labelMedium,
          ),
          icon: const Icon(Icons.add, size: 18),
          label: Text(l10n.addVehicle),
        ),
      ],
    );
  }
}
