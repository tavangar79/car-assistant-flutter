import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/vehicle_rules.dart';
import 'form_field_header.dart';
import 'form_help_text.dart';
import 'form_input_decoration.dart';
import 'form_section_card.dart';

/// Required vehicle nickname, shown on the dashboard.
class NicknameField extends StatelessWidget {
  const NicknameField({super.key, required this.controller, this.onChanged, this.error});

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
            label: l10n.vehicleNicknameLabel,
            required: true,
            badge: l10n.vehicleNicknameBadge,
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            onChanged: onChanged,
            maxLength: VehicleRules.nicknameMaxLength,
            textInputAction: TextInputAction.next,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: formInputDecoration(
              context,
              hint: l10n.vehicleNicknameHint,
              hasError: error != null,
              suffix: Icon(
                Icons.drive_file_rename_outline,
                size: 20,
                color: AppTones.of(context).muted,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FormHelpText(help: l10n.vehicleNicknameHelp, error: error),
        ],
      ),
    );
  }
}
