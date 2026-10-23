import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// The sub-filters under the type tabs: the "فاکتوردار" toggle chip, the period chip (opens the
/// filter page) and the export action (opens the report export).
class HistoryQuickFilters extends StatelessWidget {
  const HistoryQuickFilters({
    super.key,
    required this.attachmentsOnly,
    required this.periodLabel,
    required this.onToggleAttachments,
    required this.onPeriodTap,
    required this.onExport,
  });

  final bool attachmentsOnly;
  final String periodLabel;
  final VoidCallback onToggleAttachments;
  final VoidCallback onPeriodTap;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Chip(
                  selected: attachmentsOnly,
                  onTap: onToggleAttachments,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 16,
                      color: attachmentsOnly ? scheme.tertiary : scheme.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(l10n.historyInvoiceChip),
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: attachmentsOnly ? scheme.tertiary : scheme.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                _Chip(
                  selected: false,
                  onTap: onPeriodTap,
                  children: [
                    const Icon(Icons.calendar_month, size: 16),
                    const SizedBox(width: 4),
                    Text(periodLabel),
                    const SizedBox(width: 4),
                    const Icon(Icons.expand_more, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onExport,
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            textStyle: theme.textTheme.labelSmall,
          ),
          icon: const Icon(Icons.ios_share, size: 16),
          label: Text(l10n.historyExport),
        ),
      ],
    );
  }
}

/// A pill chip, navy when [selected]; a 48px touch target around a 32px pill.
class _Chip extends StatelessWidget {
  const _Chip({required this.selected, required this.onTap, required this.children});

  final bool selected;
  final VoidCallback onTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: selected ? scheme.primary : scheme.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: IconTheme.merge(
                data: IconThemeData(color: foreground),
                child: DefaultTextStyle.merge(
                  style: theme.textTheme.labelMedium?.copyWith(color: foreground),
                  child: Row(mainAxisSize: MainAxisSize.min, children: children),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
