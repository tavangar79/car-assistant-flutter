import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/notification_category.dart';

/// The inbox chips, scrolling sideways: "همه (N)", then one per category. The selected chip is
/// navy; `null` is "همه".
class NotificationFilterChips extends StatelessWidget {
  const NotificationFilterChips({
    super.key,
    required this.selected,
    required this.total,
    required this.onSelected,
  });

  final NotificationCategory? selected;
  final int total;
  final ValueChanged<NotificationCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in [null, ...NotificationCategory.values]) ...[
            _Chip(
              label: switch (category) {
                null => l10n.notificationsFilterAll(total),
                NotificationCategory.service => l10n.notificationsFilterService,
                NotificationCategory.documents => l10n.notificationsFilterDocuments,
                NotificationCategory.system => l10n.notificationsFilterSystem,
              },
              selected: category == selected,
              onTap: () => onSelected(category),
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? scheme.primary : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? scheme.onPrimary : scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
