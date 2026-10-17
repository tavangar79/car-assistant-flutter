import 'package:flutter/material.dart';

/// Decoration of the vehicle form inputs (Stitch: 48px high, `surface-container-low` fill).
/// [hasError] draws the error border.
InputDecoration formInputDecoration(
  BuildContext context, {
  String? hint,
  Widget? suffix,
  bool hasError = false,
}) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: scheme.outline),
    counterText: '',
    isDense: true,
    fillColor: scheme.surfaceContainerLow,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    suffixIcon: suffix,
    enabledBorder: hasError ? theme.inputDecorationTheme.errorBorder : null,
  );
}
