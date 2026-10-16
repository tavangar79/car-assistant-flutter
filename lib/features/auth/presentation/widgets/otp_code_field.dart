import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/latin_digits.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';

/// [length] digit boxes over one invisible text field (so paste and SMS autofill work).
/// Calls [onCompleted] once [length] digits are typed.
class OtpCodeField extends StatelessWidget {
  const OtpCodeField({
    super.key,
    required this.controller,
    required this.length,
    required this.onCompleted,
    this.hasError = false,
    this.enabled = true,
  });

  final TextEditingController controller;
  final int length;
  final ValueChanged<String> onCompleted;
  final bool hasError;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: length * 68.0),
        child: Stack(
          children: [
            ListenableBuilder(
              listenable: controller,
              builder: (context, _) => Row(
                children: [
                  for (var i = 0; i < length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: _DigitBox(
                        digit: i < controller.text.length
                            ? localizeDigits(controller.text[i], l10n.localeName)
                            : '',
                        active: enabled && i == controller.text.length,
                        hasError: hasError,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Positioned.fill(
              child: Semantics(
                label: l10n.authOtpFieldLabel,
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  maxLength: length,
                  showCursor: false,
                  enableInteractiveSelection: false,
                  style: const TextStyle(color: Colors.transparent),
                  decoration: const InputDecoration.collapsed(hintText: null),
                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                      null,
                  inputFormatters: [const _LatinDigitsFormatter()],
                  onChanged: (value) {
                    if (value.length == length) onCompleted(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DigitBox extends StatelessWidget {
  const _DigitBox({required this.digit, required this.active, required this.hasError});

  final String digit;
  final bool active;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderColor = hasError
        ? scheme.error
        : active
        ? scheme.primary
        : scheme.outlineVariant;
    return Container(
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: active || hasError ? 2 : 1),
      ),
      child: Text(
        digit,
        style: Theme.of(context).textTheme.headlineLarge!
            .copyWith(fontSize: 28, color: scheme.onSurface),
      ),
    );
  }
}

/// Turns Persian/Arabic digits into ASCII digits and drops everything else.
class _LatinDigitsFormatter extends TextInputFormatter {
  const _LatinDigitsFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = toLatinDigits(newValue.text).replaceAll(RegExp(r'\D'), '');
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}
