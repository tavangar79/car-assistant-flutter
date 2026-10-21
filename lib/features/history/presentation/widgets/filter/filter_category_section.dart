import 'package:flutter/material.dart';

import '../../../../../core/utils/material_symbol_icon.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../services/domain/entities/service_category.dart';
import '../../../domain/entities/history_categories.dart';
import 'filter_section.dart';

/// "دسته‌بندی خدمات و هزینه‌ها": a two-column grid of the catalog categories plus "هزینه‌های
/// قانونی", each toggled on tap, and "انتخاب همه".
///
/// A catalog tile shows the category title, its first item's icon and its first item titles.
class FilterCategorySection extends StatelessWidget {
  const FilterCategorySection({
    super.key,
    required this.catalog,
    required this.selected,
    required this.onToggle,
    required this.onSelectAll,
  });

  final List<ServiceCategory> catalog;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tiles = [
      for (final category in catalog)
        _CategoryTile(
          icon: materialSymbolIcon(category.items.firstOrNull?.icon ?? ''),
          title: category.title,
          subtitle: [for (final item in category.items.take(3)) item.title].join('، '),
          selected: selected.contains(category.id),
          onTap: () => onToggle(category.id),
        ),
      _CategoryTile(
        icon: Icons.receipt_long,
        title: l10n.historyCategoryLegal,
        subtitle: l10n.historyCategoryLegalHint,
        selected: selected.contains(HistoryCategories.legal),
        onTap: () => onToggle(HistoryCategories.legal),
      ),
    ];
    return FilterSection(
      title: l10n.historyFilterCategories,
      trailing: TextButton(
        onPressed: onSelectAll,
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        child: Text(l10n.historyFilterSelectAll),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 112,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: tiles,
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurface;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? scheme.primary : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        elevation: 0.5,
        shadowColor: scheme.shadow.withValues(alpha: 0.2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: selected
                            ? scheme.onPrimary.withValues(alpha: 0.1)
                            : scheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: selected ? scheme.onPrimary : scheme.secondary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      selected ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 20,
                      color: selected ? scheme.surfaceContainerHigh : scheme.outlineVariant,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(color: foreground),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: selected ? scheme.outline : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
