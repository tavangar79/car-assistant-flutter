import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// "Enter the verification code" headline and the "a N-digit code was sent to:" line.
class OtpIntro extends StatelessWidget {
  const OtpIntro({super.key, required this.codeLength});

  final int codeLength;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.authOtpTitle,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.375,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.authOtpSubtitle(codeLength),
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 13,
            height: 1.6,
            color: AppTones.of(context).muted,
          ),
        ),
      ],
    );
  }
}
