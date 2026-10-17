import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Top bar of the complete-profile page: car tile and the page title.
class CompleteProfileTopBar extends StatelessWidget {
  const CompleteProfileTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.directions_car, size: 20, color: scheme.onPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).profileHeaderTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
