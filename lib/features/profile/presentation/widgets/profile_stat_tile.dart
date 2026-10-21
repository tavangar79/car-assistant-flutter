import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import 'profile_card.dart';

/// A counter tile: icon in a rounded box, the [count] and its [label].
class ProfileStatTile extends StatelessWidget {
  const ProfileStatTile({super.key, required this.icon, required this.count, required this.label});

  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ProfileCard(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: scheme.secondary),
          ),
          const SizedBox(height: 4),
          Text(
            NumberFormat.decimalPattern(l10n.localeName).format(count),
            style: AppTextStyles.metricOdometer.copyWith(color: scheme.onSurface),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: scheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
