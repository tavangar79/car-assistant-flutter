import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

/// Sticky bottom bar of the vehicle form: the primary [submitLabel] button and cancel.
/// While [saving] the primary button shows a spinner and "saving…", and both are disabled.
class VehicleFormDock extends StatelessWidget {
  const VehicleFormDock({
    super.key,
    required this.submitLabel,
    required this.saving,
    required this.onSubmit,
    required this.onCancel,
  });

  final String submitLabel;
  final bool saving;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: saving ? null : onSubmit,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    textStyle: theme.textTheme.headlineSmall,
                    disabledBackgroundColor: scheme.primary.withValues(alpha: 0.8),
                    disabledForegroundColor: scheme.onPrimary,
                  ),
                  icon: saving
                      ? SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                        )
                      : const Icon(Icons.check_circle_outline, size: 20),
                  label: Text(saving ? l10n.vehicleSaving : submitLabel),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: saving ? null : onCancel,
                style: TextButton.styleFrom(
                  minimumSize: const Size(88, 52),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  backgroundColor: scheme.surfaceContainer,
                  foregroundColor: scheme.onSurface,
                  textStyle: theme.textTheme.labelLarge,
                ),
                child: Text(l10n.vehicleCancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
