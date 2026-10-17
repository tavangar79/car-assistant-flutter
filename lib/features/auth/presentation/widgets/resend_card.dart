import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/format_countdown.dart';
import '../../../../l10n/app_localizations.dart';

/// Grey card with the resend countdown, a hint, and the resend button (enabled at zero).
class ResendCard extends StatelessWidget {
  const ResendCard({
    super.key,
    required this.secondsLeft,
    required this.onResend,
    this.loading = false,
  });

  final int secondsLeft;
  final VoidCallback onResend;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule, size: 16, color: tones.amber.foreground),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  l10n.authResendIn,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: tones.label,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _CountdownPill(text: formatCountdown(secondsLeft, l10n.localeName)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.authResendHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: tones.muted,
            ),
          ),
          const SizedBox(height: 10),
          _ResendButton(
            enabled: secondsLeft == 0 && !loading,
            loading: loading,
            onPressed: onResend,
          ),
        ],
      ),
    );
  }
}

class _CountdownPill extends StatelessWidget {
  const _CountdownPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        text,
        textDirection: TextDirection.ltr,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: scheme.primary,
        ),
      ),
    );
  }
}

class _ResendButton extends StatelessWidget {
  const _ResendButton({required this.enabled, required this.loading, required this.onPressed});

  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
          backgroundColor: scheme.surfaceContainerLowest,
          foregroundColor: scheme.primary,
          disabledBackgroundColor: scheme.surfaceContainerHigh,
          disabledForegroundColor: scheme.outline,
          side: enabled ? BorderSide(color: scheme.outlineVariant) : BorderSide.none,
          textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        child: loading
            ? const SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(AppLocalizations.of(context).authResend)),
                  const SizedBox(width: 6),
                  const Icon(Icons.refresh, size: 14),
                ],
              ),
      ),
    );
  }
}
