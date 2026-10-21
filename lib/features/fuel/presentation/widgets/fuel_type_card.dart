import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/fuel_type.dart';
import 'fuel_formats.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_field.dart';

/// "نوع سوخت دریافتی": a four-way segmented control (معمولی / سوپر / CNG / LPG).
class FuelTypeCard extends StatelessWidget {
  const FuelTypeCard({super.key, required this.selected, required this.onSelected});

  final FuelType selected;
  final ValueChanged<FuelType> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return WizardCard(
      child: WizardField(
        label: l10n.fuelTypeLabel,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              for (final (index, type) in FuelType.values.indexed) ...[
                if (index > 0) const SizedBox(width: 4),
                Expanded(
                  child: TextButton(
                    onPressed: () => onSelected(type),
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: type == selected ? scheme.primary : Colors.transparent,
                      foregroundColor: type == selected
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                      textStyle: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: type == selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    child: Text(fuelTypeLabel(type, l10n)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
