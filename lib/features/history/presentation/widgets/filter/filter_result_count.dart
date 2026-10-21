import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

/// "تعداد نتایج منطبق با فیلترها: ۵ رکورد". [count] is `null` while it loads or when it failed.
class FilterResultCount extends StatelessWidget {
  const FilterResultCount({super.key, required this.count, required this.loading});

  final int? count;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.insights, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              l10n.historyFilterResults,
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          if (loading)
            const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
          else
            Text(
              count == null ? '—' : l10n.historyFilterResultsValue(count!),
              style: theme.textTheme.headlineSmall?.copyWith(color: scheme.primary),
            ),
        ],
      ),
    );
  }
}
