import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/latin_digits.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import 'otp_digit_box.dart';

/// Label, [length] digit boxes (left to right) and the progress row of the code page.
///
/// An invisible [TextField] covers the boxes: it takes the keyboard, paste and SMS autofill, and
/// accepts Persian digits. [onCompleted] fires when the last digit is typed.
class OtpCodeInput extends StatelessWidget {
  const OtpCodeInput({
    super.key,
    required this.length,
    required this.controller,
    required this.onCompleted,
    this.hasError = false,
  });

  final int length;
  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = AppTones.of(context);
    final small = theme.textTheme.labelMedium;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final code = value.text;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.authOtpFieldLabel(length),
              style: small?.copyWith(fontWeight: FontWeight.w600, color: tones.muted),
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      for (var i = 0; i < length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(
                          child: OtpDigitBox(
                            digit: i < code.length
                                ? localizeDigits(code[i], l10n.localeName)
                                : null,
                            isActive: i == code.length,
                            hasError: hasError,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned.fill(child: Opacity(opacity: 0, child: _hiddenField(l10n))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.authOtpAutoDetect,
                    style: small?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.authOtpProgress(code.length, length),
                  style: small?.copyWith(fontWeight: FontWeight.w700, color: tones.label),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _hiddenField(AppLocalizations l10n) => Semantics(
    label: l10n.authOtpFieldLabel(length),
    child: TextField(
      controller: controller,
      autofocus: true,
      showCursor: false,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      autofillHints: const [AutofillHints.oneTimeCode],
      inputFormatters: [TextInputFormatter.withFunction(_digitsOnly)],
      decoration: const InputDecoration(
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      onChanged: (code) {
        if (code.length == length) onCompleted(code);
      },
    ),
  );

  TextEditingValue _digitsOnly(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = toLatinDigits(newValue.text).replaceAll(RegExp(r'\D'), '');
    if (digits.length > length) digits = digits.substring(0, length);
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}
