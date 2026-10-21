import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../domain/entities/fuel_payment_method.dart';
import '../../domain/entities/fuel_rules.dart';
import 'fuel_formats.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_field.dart';

/// "جایگاه سوخت", "روش پرداخت و سهمیه" (a row that opens the method sheet) and
/// "یادداشت (اختیاری)".
class FuelDetailsCard extends StatelessWidget {
  const FuelDetailsCard({
    super.key,
    required this.stationController,
    required this.notesController,
    required this.paymentMethod,
    required this.onStationChanged,
    required this.onNotesChanged,
    required this.onPaymentMethodChanged,
    this.stationError,
    this.notesError,
  });

  final TextEditingController stationController;
  final TextEditingController notesController;
  final FuelPaymentMethod? paymentMethod;
  final ValueChanged<String> onStationChanged;
  final ValueChanged<String> onNotesChanged;
  final ValueChanged<FuelPaymentMethod> onPaymentMethodChanged;
  final String? stationError;
  final String? notesError;

  /// Lets the user pick a payment method; `null` when dismissed.
  static Future<FuelPaymentMethod?> pickPaymentMethod(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<FuelPaymentMethod>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(l10n.fuelPaymentLabel, style: Theme.of(context).textTheme.headlineSmall),
            ),
            for (final method in FuelPaymentMethod.values)
              ListTile(
                minTileHeight: 56,
                leading: const Icon(Icons.credit_card_outlined),
                title: Text(fuelPaymentLabel(method, l10n)),
                onTap: () => Navigator.of(context).pop(method),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final method = await pickPaymentMethod(context);
    if (method != null) onPaymentMethodChanged(method);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final method = paymentMethod;
    return WizardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WizardField(
            label: l10n.fuelStationLabel,
            child: TextField(
              controller: stationController,
              onChanged: onStationChanged,
              maxLength: FuelRules.stationMaxLength,
              textInputAction: TextInputAction.next,
              style: theme.textTheme.bodyMedium,
              decoration: wizardInputDecoration(
                context,
                hasError: stationError != null,
                prefixIcon: Icon(
                  Icons.local_gas_station_outlined,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          if (stationError case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
          const SizedBox(height: 16),
          WizardField(
            label: l10n.fuelPaymentLabel,
            child: Material(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _pick(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.credit_card_outlined, size: 18, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          method == null ? l10n.fuelPaymentPick : fuelPaymentLabel(method, l10n),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: method == null ? scheme.outline : scheme.onSurface,
                          ),
                        ),
                      ),
                      // keyboard_arrow_left points forward in RTL.
                      Icon(Icons.keyboard_arrow_left, size: 16, color: scheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          WizardField(
            label: l10n.fuelNotesLabel,
            child: TextField(
              controller: notesController,
              onChanged: onNotesChanged,
              maxLength: FuelRules.notesMaxLength,
              style: theme.textTheme.bodySmall,
              decoration: wizardInputDecoration(
                context,
                hint: l10n.fuelNotesHint,
                hasError: notesError != null,
                prefixIcon: Icon(Icons.edit_note, size: 18, color: scheme.onSurfaceVariant),
              ),
            ),
          ),
          if (notesError case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
        ],
      ),
    );
  }
}
