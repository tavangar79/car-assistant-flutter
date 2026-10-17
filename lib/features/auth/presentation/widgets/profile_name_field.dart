import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../domain/entities/profile_rules.dart';
import 'auth_error_text.dart';
import 'profile_field_label.dart';

/// Required name field (label, icon, hint) with an optional validation [error].
class ProfileNameField extends StatelessWidget {
  const ProfileNameField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.error,
    this.onChanged,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? error;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasError = error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileFieldLabel(label, required: true),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          maxLength: ProfileRules.maxNameLength,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: scheme.outline),
            counterText: '',
            fillColor: scheme.surfaceContainerLowest,
            prefixIcon: Icon(icon, size: 20, color: AppTones.of(context).muted),
            enabledBorder: hasError ? Theme.of(context).inputDecorationTheme.errorBorder : null,
          ),
        ),
        if (error case final message?) ...[const SizedBox(height: 6), AuthErrorText(message)],
      ],
    );
  }
}
