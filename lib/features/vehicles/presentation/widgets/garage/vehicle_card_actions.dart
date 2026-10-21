import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';

/// The three shortcuts of a garage card: ثبت سرویس, ثبت کیلومتر and دفترچه سوابق. Service and the
/// records book are disabled until their pages exist.
class VehicleCardActions extends StatelessWidget {
  const VehicleCardActions({super.key, required this.onUpdateOdometer});

  final VoidCallback onUpdateOdometer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final tones = AppTones.of(context);
    return Row(
      children: [
        Expanded(
          // TODO(phase-2): open the service wizard for this vehicle.
          child: _Shortcut(
            icon: Icons.build_outlined,
            color: tones.amber.foreground,
            label: l10n.garageActionService,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Shortcut(
            icon: Icons.edit_road,
            color: tones.info.foreground,
            label: l10n.garageActionOdometer,
            onTap: onUpdateOdometer,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          // TODO(phase-4): open this vehicle's history.
          child: _Shortcut(
            icon: Icons.receipt_long_outlined,
            color: scheme.secondary,
            label: l10n.garageActionRecords,
          ),
        ),
      ],
    );
  }
}

/// A 64dp tile: colored icon over a label. Without [onTap] it is shown disabled.
class _Shortcut extends StatelessWidget {
  const _Shortcut({required this.icon, required this.color, required this.label, this.onTap});

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = onTap != null;
    // A disabled shortcut still takes the tap, so it doesn't fall through and open the card.
    return GestureDetector(
      onTap: enabled ? null : () {},
      child: Semantics(
        button: true,
        enabled: enabled,
        hint: enabled ? null : AppLocalizations.of(context).quickActionUnavailable,
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: Material(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                height: 64,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 20, color: color),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }
}
