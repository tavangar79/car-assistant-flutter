import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// "By signing in you accept the Terms and Privacy Policy" line under the phone page button.
/// The links are styled as in the design; there are no terms pages yet, so they are not tappable.
class TermsNote extends StatelessWidget {
  const TermsNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final link = TextStyle(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${l10n.authTermsPrefix} '),
          TextSpan(text: l10n.authTermsLink, style: link),
          TextSpan(text: ' ${l10n.authTermsAnd} '),
          TextSpan(text: l10n.authPrivacyLink, style: link),
          TextSpan(text: ' ${l10n.authTermsSuffix}'),
        ],
      ),
      textAlign: TextAlign.center,
      style: theme.textTheme.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppTones.of(context).muted,
      ),
    );
  }
}
