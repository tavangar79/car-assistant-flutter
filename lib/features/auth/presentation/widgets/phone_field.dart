import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';

/// Large phone number input. Accepts Latin, Persian and Arabic digits, `+`, spaces, dashes and
/// parentheses (e.g. `0098 912-123-4567`); normalization happens in the domain layer.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.errorText,
    this.enabled = true,
  });

  static const _sample = '09123456789';
  static final _allowed = FilteringTextInputFormatter.allow(RegExp(r'[0-9۰-۹٠-٩+ ()\-]'));

  /// Room for `+98 (912) 123-4567` and `0098 912 123 4567` with a little slack.
  static const _maxLength = 20;

  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final digits = Theme.of(context).textTheme.headlineLarge!.copyWith(letterSpacing: 2);
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: true,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.telephoneNumber],
      inputFormatters: [_allowed, LengthLimitingTextInputFormatter(_maxLength)],
      // Phone numbers read left-to-right, also in Persian.
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      style: digits,
      onSubmitted: (_) => onSubmitted(),
      decoration: InputDecoration(
        labelText: l10n.authPhoneLabel,
        hintText: localizeDigits(_sample, l10n.localeName),
        hintStyle: digits.copyWith(color: Theme.of(context).colorScheme.outline),
        prefixIcon: const Icon(Icons.phone_iphone, size: 28),
        errorText: errorText,
        errorMaxLines: 2,
      ),
    );
  }
}
