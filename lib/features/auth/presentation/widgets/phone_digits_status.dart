import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import 'phone_input_formatter.dart';

/// Row under the phone field: the SMS hint, and how far the number is (progress, complete, invalid).
class PhoneDigitsStatus extends StatelessWidget {
  const PhoneDigitsStatus({super.key, required this.digitCount, required this.isValid});

  /// Digits typed after +98.
  final int digitCount;
  final bool isValid;

  /// Length of the full number with its leading 0 (`09xxxxxxxxx`).
  static const fullLength = PhoneInputFormatter.maxDigits + 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = AppTones.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(fontSize: 11, color: tones.muted);
    final complete = digitCount == PhoneInputFormatter.maxDigits;
    final (status, color) = switch ((complete, isValid)) {
      (true, true) => (l10n.authPhoneDigitsComplete(fullLength), tones.success),
      (true, false) => (l10n.authPhoneInvalid, theme.colorScheme.error),
      _ => (l10n.authPhoneDigitsProgress(digitCount, PhoneInputFormatter.maxDigits), tones.muted),
    };
    // As in Stitch: the hint hugs the physical right edge and the status the physical left edge.
    // The row is laid out right-to-left whatever the locale; free space goes between the two.
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(Icons.info_outline, size: 14, color: theme.colorScheme.outline),
              const SizedBox(width: 4),
              Flexible(child: Text(l10n.authSmsCodeHint, style: style)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            status,
            textAlign: TextAlign.left,
            style: style?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
