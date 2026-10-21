import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// "تنظیم سریع مقادیر رایج": four buttons that add a common distance to the input. The service
/// wizard reuses the buttons under its own label ([showLabel] false).
class QuickAdjustButtons extends StatelessWidget {
  const QuickAdjustButtons({super.key, required this.onAdjust, this.showLabel = true});

  /// The steps, in screen order (Stitch: +500, +1000, +2000, -500).
  static const steps = [500, 1000, 2000, -500];

  final ValueChanged<int> onAdjust;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final format = NumberFormat.decimalPattern(l10n.localeName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLabel) ...[
          Text(
            l10n.odometerQuickAdjust,
            style: theme.textTheme.labelSmall?.copyWith(color: AppTones.of(context).muted),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            for (final (index, step) in steps.indexed) ...[
              if (index > 0) const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () => onAdjust(step),
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: step < 0
                        ? scheme.surfaceContainer
                        : scheme.surfaceContainerHigh,
                    foregroundColor: step < 0 ? scheme.onSurfaceVariant : scheme.onSurface,
                    textStyle: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: step < 0 ? FontWeight.w500 : FontWeight.w600,
                    ),
                  ),
                  child: Text('${step < 0 ? '-' : '+'}${format.format(step.abs())}'),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
