import 'package:flutter/material.dart';

import '../../../../../core/theme/vehicle_palette.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/vehicle_color.dart';
import 'form_field_header.dart';
import 'form_help_text.dart';
import 'form_section_card.dart';

/// Optional body colour: six round swatches with the chosen colour's name next to the label.
/// Tapping the chosen swatch again clears the choice.
class ColorSwatches extends StatelessWidget {
  const ColorSwatches({super.key, required this.selected, required this.onChanged, this.error});

  final VehicleColor? selected;
  final ValueChanged<VehicleColor?> onChanged;
  final String? error;

  static String nameOf(VehicleColor color, AppLocalizations l10n) => switch (color) {
    VehicleColor.white => l10n.vehicleColorWhite,
    VehicleColor.black => l10n.vehicleColorBlack,
    VehicleColor.silver => l10n.vehicleColorSilver,
    VehicleColor.blue => l10n.vehicleColorBlue,
    VehicleColor.red => l10n.vehicleColorRed,
    VehicleColor.beige => l10n.vehicleColorBeige,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final current = selected;
    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: FormFieldHeader(label: l10n.vehicleColorLabel)),
              if (current != null)
                Text(
                  nameOf(current, l10n),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final color in VehicleColor.values)
                Expanded(
                  child: _Swatch(
                    color: color,
                    label: nameOf(color, l10n),
                    selected: color == current,
                    onTap: () => onChanged(color == current ? null : color),
                  ),
                ),
            ],
          ),
          if (error != null) ...[const SizedBox(height: 8), FormHelpText(error: error)],
        ],
      ),
    );
  }
}

/// A 44px colour circle in a touch target at least 48px wide; the chosen one is larger with a check mark.
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final VehicleColor color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = VehiclePalette.of(context);
    final fill = switch (color) {
      VehicleColor.white => palette.white,
      VehicleColor.black => palette.black,
      VehicleColor.silver => palette.silver,
      VehicleColor.blue => palette.blue,
      VehicleColor.red => palette.red,
      VehicleColor.beige => palette.beige,
    };
    final check = color == VehicleColor.white ? scheme.onSurface : palette.onPlateBand;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: SizedBox(
          height: 52,
          child: Center(
            child: AnimatedScale(
              scale: selected ? 1.1 : 1,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: fill,
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: selected ? 0.15 : 0.06),
                      blurRadius: selected ? 6 : 2,
                    ),
                  ],
                ),
                child: selected ? Icon(Icons.check, size: 18, color: check) : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
