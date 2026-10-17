import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// One box of the code input. Stitch states: filled (navy hairline), active (2px navy + amber
/// cursor), empty (light border, faint dot). [hasError] turns the border red.
class OtpDigitBox extends StatelessWidget {
  const OtpDigitBox({super.key, this.digit, this.isActive = false, this.hasError = false});

  /// Already locale-formatted; `null` when empty.
  final String? digit;
  final bool isActive;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final filled = digit != null;
    final borderColor = hasError
        ? scheme.error
        : (filled || isActive)
        ? scheme.primary
        : scheme.outlineVariant;
    final textStyle = theme.textTheme.headlineLarge?.copyWith(fontSize: 24);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled || isActive
            ? scheme.surfaceContainerLowest
            : scheme.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: AppTheme.radius,
        border: Border.all(color: borderColor, width: isActive ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: isActive ? 0.1 : 0.04),
            blurRadius: isActive ? 6 : 1,
            offset: Offset(0, isActive ? 2 : 1),
          ),
        ],
      ),
      child: switch ((digit, isActive)) {
        (final String value, _) => Text(value, style: textStyle?.copyWith(color: scheme.primary)),
        (null, true) => Container(
          width: 2,
          height: 24,
          decoration: BoxDecoration(
            color: scheme.tertiary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        (null, false) => Text(
          '·',
          style: textStyle?.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.surfaceContainerHighest,
          ),
        ),
      },
    );
  }
}
