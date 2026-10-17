import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// "Sign in or create an account" headline and explanation on the phone page.
class PhoneIntro extends StatelessWidget {
  const PhoneIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.authPhoneTitle,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: 20,
              height: 1.375,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.authPhoneSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.6,
              color: AppTones.of(context).muted,
            ),
          ),
        ],
      ),
    );
  }
}
