import 'package:flutter/material.dart';

import '../../../../core/utils/format_version.dart';
import '../../../../l10n/app_localizations.dart';

/// Small pill showing the localized word "Version" followed by [version],
/// formatted with the current locale's digits.
class VersionBadge extends StatelessWidget {
  const VersionBadge({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.labelSmall!
        .copyWith(fontSize: 11, height: 1.5, color: scheme.onSurfaceVariant);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer.withValues(alpha: 0.6),
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.versionLabel, style: style.copyWith(fontWeight: FontWeight.w400)),
          const SizedBox(width: 6),
          Text(
            formatVersion(version, l10n.localeName),
            style: style.copyWith(fontWeight: FontWeight.w600, color: scheme.secondary),
          ),
        ],
      ),
    );
  }
}
