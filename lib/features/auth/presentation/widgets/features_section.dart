import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import 'feature_card.dart';

/// "Why sign up" heading with the three benefit cards of the phone page.
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = AppTones.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                l10n.authFeaturesTitle,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FeatureCard(
          icon: Icons.notifications_active_outlined,
          tone: tones.amber,
          title: l10n.authFeatureRemindersTitle,
          tag: l10n.authFeatureRemindersTag,
          body: l10n.authFeatureRemindersBody,
        ),
        const SizedBox(height: 10),
        FeatureCard(
          icon: Icons.description_outlined,
          tone: tones.neutral,
          title: l10n.authFeatureInvoicesTitle,
          tag: l10n.authFeatureInvoicesTag,
          body: l10n.authFeatureInvoicesBody,
        ),
        const SizedBox(height: 10),
        FeatureCard(
          icon: Icons.sync,
          tone: tones.emerald,
          title: l10n.authFeatureTransferTitle,
          tag: l10n.authFeatureTransferTag,
          body: l10n.authFeatureTransferBody,
        ),
      ],
    );
  }
}
