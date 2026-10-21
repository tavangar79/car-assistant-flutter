import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/material_symbol_icon.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../domain/entities/expense_category.dart';
import 'expense_field.dart';
import 'expense_formats.dart';

/// "انتخاب سرفصل هزینه": the six categories as a 3-column grid of tiles; the selected one is
/// amber-tinted with a navy check badge.
class ExpenseCategoryGrid extends StatelessWidget {
  const ExpenseCategoryGrid({
    super.key,
    required this.selected,
    required this.onSelected,
    this.error,
  });

  final ExpenseCategory? selected;
  final ValueChanged<ExpenseCategory> onSelected;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ExpenseField(
      label: l10n.expenseCategoryLabel,
      hint: l10n.expenseCategoryBadge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1.15,
            children: [
              for (final category in ExpenseCategory.values)
                _CategoryTile(
                  category: category,
                  selected: category == selected,
                  onTap: () => onSelected(category),
                ),
            ],
          ),
          if (error case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.selected, required this.onTap});

  final ExpenseCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final amber = AppTones.of(context).amber;
    final title = expenseCategoryTitle(category, l10n);
    return Semantics(
      button: true,
      selected: selected,
      label: title,
      child: Material(
        color: selected ? amber.background : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: scheme.shadow.withValues(alpha: 0.3),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selected ? amber.chipBackground : scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        materialSymbolIcon(expenseCategoryIcon(category)),
                        size: 22,
                        color: selected ? amber.chipForeground : scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        height: 1.2,
                        color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                PositionedDirectional(
                  top: 6,
                  end: 6,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
                    child: Icon(Icons.check, size: 12, color: scheme.onPrimary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
