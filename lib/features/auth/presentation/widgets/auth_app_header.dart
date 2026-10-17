import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// Logo tile with the app name and tagline, at the top of the phone page.
class AuthAppHeader extends StatelessWidget {
  const AuthAppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = AppTones.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tones.label),
            ),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              fit: BoxFit.cover,
              semanticsLabel: l10n.authLogoLabel,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.authBrandTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  l10n.authBrandSubtitle,
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 11, color: tones.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
