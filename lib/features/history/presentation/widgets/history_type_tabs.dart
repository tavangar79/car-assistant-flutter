import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/history_type.dart';

/// The segmented type switcher: همه موارد / سرویس و تعمیر / سوخت‌گیری / هزینه‌های جاری.
class HistoryTypeTabs extends StatelessWidget {
  const HistoryTypeTabs({super.key, required this.selected, required this.onSelected});

  final HistoryType selected;
  final ValueChanged<HistoryType> onSelected;

  static String label(HistoryType type, AppLocalizations l10n) => switch (type) {
    HistoryType.all => l10n.historyTabAll,
    HistoryType.service => l10n.historyTabService,
    HistoryType.fuel => l10n.historyTabFuel,
    HistoryType.expense => l10n.historyTabExpense,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final type in HistoryType.values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _Tab(
                  label: label(type, l10n),
                  selected: type == selected,
                  onTap: () => onSelected(type),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? scheme.surfaceContainerLowest : Colors.transparent,
        elevation: selected ? 1 : 0,
        shadowColor: scheme.shadow.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: selected ? scheme.onSurface : scheme.secondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
