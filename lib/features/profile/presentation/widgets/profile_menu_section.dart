import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'profile_card.dart';

/// One row of a profile menu: icon, title and subtitle.
typedef ProfileMenuItem = ({IconData icon, String title, String subtitle});

/// A titled card of [items] with dividers. Every row is disabled until its page exists.
class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key, required this.title, required this.items});

  final String title;
  final List<ProfileMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
          child: Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.secondary,
            ),
          ),
        ),
        ProfileCard(
          child: Column(
            children: [
              for (final (index, item) in items.indexed) ...[
                if (index > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: scheme.surfaceContainer,
                  ),
                _MenuRow(item: item),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A disabled row: dimmed and read as "به‌زودی" by screen readers.
class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item});

  final ProfileMenuItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      enabled: false,
      hint: AppLocalizations.of(context).comingSoon,
      child: Opacity(
        opacity: 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 22, color: scheme.secondary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // chevron_right mirrors to point left (forward) in RTL.
              Icon(Icons.chevron_right, size: 20, color: scheme.secondary),
            ],
          ),
        ),
      ),
    );
  }
}
