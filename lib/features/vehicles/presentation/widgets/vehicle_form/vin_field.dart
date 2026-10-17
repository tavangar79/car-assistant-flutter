import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/vehicle_rules.dart';
import 'form_field_header.dart';
import 'form_help_text.dart';
import 'form_input_decoration.dart';
import 'form_section_card.dart';

/// Optional VIN: 17 Latin letters or digits, typed left to right and uppercased.
/// (Stitch also has a barcode-scan button; scanning is not supported, so it is left out.)
class VinField extends StatelessWidget {
  const VinField({super.key, required this.controller, this.onChanged, this.error});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormFieldHeader(
            label: l10n.vehicleVinLabel,
            badge: l10n.vehicleVinBadge(VehicleRules.vinLength),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            onChanged: onChanged,
            maxLength: VehicleRules.vinLength,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            enableSuggestions: false,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
              const _UpperCaseFormatter(),
            ],
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14, letterSpacing: 1.5),
            decoration: formInputDecoration(
              context,
              hint: l10n.vehicleVinHint,
              hasError: error != null,
            ),
          ),
          const SizedBox(height: 4),
          FormHelpText(help: l10n.vehicleVinHelp, error: error),
        ],
      ),
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  const _UpperCaseFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) =>
      newValue.copyWith(text: newValue.text.toUpperCase());
}
