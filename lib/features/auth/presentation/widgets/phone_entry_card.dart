import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import 'auth_error_text.dart';
import 'phone_digits_status.dart';
import 'phone_input_field.dart';

/// White card with the phone label, field, digit status and an optional server [error].
class PhoneEntryCard extends StatelessWidget {
  const PhoneEntryCard({
    super.key,
    required this.controller,
    required this.digitCount,
    required this.isValid,
    this.error,
  });

  final TextEditingController controller;
  final int digitCount;
  final bool isValid;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).authPhoneLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTones.of(context).label,
            ),
          ),
          const SizedBox(height: 8),
          PhoneInputField(controller: controller, isComplete: isValid),
          const SizedBox(height: 10),
          PhoneDigitsStatus(digitCount: digitCount, isValid: isValid),
          if (error case final message?) ...[const SizedBox(height: 10), AuthErrorText(message)],
        ],
      ),
    );
  }
}
