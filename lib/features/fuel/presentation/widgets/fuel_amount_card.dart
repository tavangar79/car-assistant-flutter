import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import 'decimal_input_formatter.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_field.dart';

/// "حجم سوخت‌گیری" and "مبلغ کل پرداختی" (both 48px inputs with their unit pinned to the end),
/// then the computed price per unit.
class FuelAmountCard extends StatelessWidget {
  const FuelAmountCard({
    super.key,
    required this.volumeController,
    required this.costController,
    required this.unit,
    required this.ratePerUnit,
    required this.onVolumeChanged,
    required this.onCostChanged,
    this.volumeError,
    this.costError,
  });

  final TextEditingController volumeController;
  final TextEditingController costController;

  /// "لیتر" or "متر مکعب", by the chosen fuel type.
  final String unit;

  /// Toman per [unit]; `null` while it can't be computed.
  final int? ratePerUnit;
  final ValueChanged<String> onVolumeChanged;
  final ValueChanged<String> onCostChanged;
  final String? volumeError;
  final String? costError;

  /// Largest number of digits of a total cost (999,999,999 toman has 9).
  static const costMaxDigits = 9;

  static DecimalInputFormatter volumeFormatter(String locale) =>
      DecimalInputFormatter(locale: locale);

  static DigitsInputFormatter costFormatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: costMaxDigits, grouped: true);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final volumeFormat = volumeFormatter(l10n.localeName);
    final costFormat = costFormatter(l10n.localeName);
    final inputStyle = theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface);
    Widget suffix(String text) => Padding(
      padding: const EdgeInsetsDirectional.only(end: 12),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
    return WizardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WizardField(
            label: l10n.fuelVolumeLabel,
            child: TextField(
              controller: volumeController,
              onChanged: onVolumeChanged,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [volumeFormat],
              style: inputStyle,
              decoration: wizardInputDecoration(
                context,
                hint: volumeFormat.format('0'),
                hasError: volumeError != null,
                suffix: suffix(unit),
              ),
            ),
          ),
          if (volumeError case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
          const SizedBox(height: 16),
          WizardField(
            label: l10n.fuelTotalCostLabel,
            child: TextField(
              controller: costController,
              onChanged: onCostChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [costFormat],
              style: inputStyle,
              decoration: wizardInputDecoration(
                context,
                hint: costFormat.format('0'),
                hasError: costError != null,
                suffix: suffix(l10n.currencyToman),
              ),
            ),
          ),
          if (costError case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calculate_outlined, size: 15, color: scheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.fuelRateLabel,
                    style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
                Text(
                  ratePerUnit == null ? l10n.notComputable : l10n.fuelRateValue(ratePerUnit!, unit),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
