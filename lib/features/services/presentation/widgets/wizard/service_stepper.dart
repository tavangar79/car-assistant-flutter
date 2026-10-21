import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';

/// The three steps of the wizard: done steps show a check, the [current] one its number, the rest
/// are muted. An optional [summary] row (step 3: mileage and date) sits under them.
class ServiceStepper extends StatelessWidget {
  const ServiceStepper({super.key, required this.current, this.summary});

  /// 0-based index of the active step.
  final int current;
  final Widget? summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final labels = [l10n.serviceStep1Label, l10n.serviceStep2Label, l10n.serviceStep3Label];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (index, label) in labels.indexed) ...[
                if (index > 0)
                  Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.only(top: 14),
                      color: index <= current ? scheme.primary : scheme.surfaceContainerHigh,
                    ),
                  ),
                Expanded(
                  flex: 3,
                  child: _Step(index: index, label: label, current: current),
                ),
              ],
            ],
          ),
          if (summary case final summary?) ...[const SizedBox(height: 12), summary],
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.index, required this.label, required this.current});

  final int index;
  final String label;
  final int current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final done = index < current;
    final active = index == current;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: done || active ? scheme.primary : scheme.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: active ? Border.all(color: scheme.surfaceContainerHigh, width: 3) : null,
          ),
          child: done
              ? Icon(Icons.check, size: 18, color: scheme.onPrimary)
              : Center(
                  child: Text(
                    l10n.serviceStepNumber(index + 1),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: active ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active || done ? scheme.onSurface : AppTones.of(context).muted,
          ),
        ),
      ],
    );
  }
}
