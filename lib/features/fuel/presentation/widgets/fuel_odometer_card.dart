import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/mileage_field.dart';
import '../../domain/entities/fuel_rules.dart';
import 'quick_chip.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_field.dart';

/// "کارکرد کیلومترشمار فعلی": the km input with the previous reading as a hint, the distance
/// since the last fill-up and the +50 / +100 / +500 chips.
class FuelOdometerCard extends StatelessWidget {
  const FuelOdometerCard({
    super.key,
    required this.controller,
    required this.value,
    required this.currentMileageKm,
    required this.lastFillKm,
    required this.onChanged,
    required this.onAdjust,
    this.error,
  });

  final TextEditingController controller;

  /// The value in the input, in km.
  final int value;

  /// The vehicle's current mileage ("سند ثبت‌شده قبلی").
  final int currentMileageKm;

  /// The odometer of the last fill-up; `null` when the vehicle has none.
  final int? lastFillKm;
  final ValueChanged<String> onChanged;
  final ValueChanged<int> onAdjust;
  final String? error;

  /// The input's formatter: locale digits with thousands separators.
  static DigitsInputFormatter formatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: MileageField.maxDigits, grouped: true);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final format = NumberFormat.decimalPattern(l10n.localeName);
    final inputFormatter = formatter(l10n.localeName);
    final sinceLast = lastFillKm == null ? null : value - lastFillKm!;
    return WizardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.fuelOdometerLabel,
                  style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
              Text(
                l10n.fuelOdometerPrevious(currentMileageKm),
                style: theme.textTheme.labelSmall?.copyWith(color: scheme.tertiary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            inputFormatters: [inputFormatter],
            style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
            decoration: wizardInputDecoration(
              context,
              hint: inputFormatter.format('0'),
              hasError: error != null,
              suffix: Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: Text(
                  l10n.vehicleMileageUnit,
                  style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
          if (error case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
          const SizedBox(height: 8),
          Row(
            children: [
              if (sinceLast != null) ...[
                Icon(Icons.trip_origin, size: 16, color: scheme.tertiary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.fuelOdometerSinceLast(
                      '${sinceLast < 0 ? '-' : '+'}${format.format(sinceLast.abs())}',
                    ),
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              ] else
                const Spacer(),
              for (final step in FuelRules.odometerSteps) ...[
                const SizedBox(width: 4),
                QuickChip(label: '+${format.format(step)}', onTap: () => onAdjust(step)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
