import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/tone_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/entities/expense_category.dart';
import '../../../expenses/presentation/widgets/expense_formats.dart';
import '../../../fuel/domain/entities/fuel_log.dart';
import '../../../fuel/presentation/widgets/fuel_formats.dart';
import '../../../services/domain/entities/service_category.dart';
import '../../../services/domain/entities/service_visit.dart';
import '../../../services/presentation/widgets/service_icon_tile.dart';
import '../../domain/entities/history_entry.dart';
import 'history_formats.dart';

/// One record of the history (Stitch "تاریخچه" rows): a tinted icon tile, the title, the date
/// line and a detail line, then the cost and a badge. [onTap] is `null` for records without a
/// details page (they show no chevron).
class HistoryEntryRow extends StatelessWidget {
  const HistoryEntryRow({super.key, required this.entry, required this.catalog, this.onTap});

  final HistoryEntry entry;

  /// The service catalog, for the titles and icons of service items.
  final List<ServiceCategory> catalog;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tones = AppTones.of(context);
    final content = switch (entry) {
      HistoryEntry(service: final service?) => _serviceContent(service, l10n, tones),
      HistoryEntry(fuelLog: final log?) => _fuelContent(log, l10n, tones),
      HistoryEntry(expense: final expense?) => _expenseContent(expense, l10n, tones),
      _ => _RowContent(icon: '', tone: tones.neutral, title: entry.id, dateLine: ''),
    };
    return _RowFrame(entry: entry, content: content, onTap: onTap);
  }

  _RowContent _serviceContent(ServiceVisit visit, AppLocalizations l10n, AppTones tones) {
    final items = [for (final line in visit.lineItems) findServiceItem(catalog, line.itemId)];
    final titles = [
      for (final (index, item) in items.indexed) item?.title ?? visit.lineItems[index].itemId,
    ];
    return _RowContent(
      icon: items.firstOrNull?.icon ?? '',
      tone: tones.amber,
      title: titles.join('، '),
      dateLine: _line(visit.serviceDate, l10n.historyRowKm(visit.odometerKm), l10n),
      detail: visit.workshop,
      badge: visit.hasInvoice ? _Badge.invoice : null,
    );
  }

  _RowContent _fuelContent(FuelLog log, AppLocalizations l10n, AppTones tones) {
    final fuel = fuelTypeLabel(log.fuelType, l10n);
    final volume = l10n.historyRowVolume(
      formatDecimal(log.volume, l10n.localeName),
      fuelUnitLabel(log.fuelType, l10n),
    );
    return _RowContent(
      icon: 'local_gas_station',
      tone: tones.info,
      title: log.isFullFill ? l10n.historyFullFill(fuel) : fuel,
      dateLine: _line(log.fueledAt, volume, l10n),
      detail: log.station,
      economy: switch (log.economy) {
        final economy? => l10n.historyEconomy(formatDecimal(economy, l10n.localeName)),
        null => null,
      },
    );
  }

  _RowContent _expenseContent(Expense expense, AppLocalizations l10n, AppTones tones) {
    return _RowContent(
      icon: expenseCategoryIcon(expense.category),
      tone: expense.category == ExpenseCategory.fine ? tones.overdue : tones.neutral,
      title: expense.title ?? expenseCategoryTitle(expense.category, l10n),
      dateLine: _line(expense.paidAt, expense.issuer, l10n),
      detail: switch (expense.expiresAt) {
        final expiresAt? => l10n.historyExpiresAt(formatJalaliDate(expiresAt.toLocal(), l10n)),
        null => null,
      },
      badge: expense.hasAttachment ? _Badge.attachment : null,
    );
  }

  /// `۲۵ آبان ۱۴۰۳ • [extra]`.
  static String _line(DateTime date, String? extra, AppLocalizations l10n) => [
    formatJalaliDate(date.toLocal(), l10n),
    if (extra != null && extra.isNotEmpty) extra,
  ].join(' • ');
}

enum _Badge { invoice, attachment }

/// What a row shows, built from its record.
class _RowContent {
  const _RowContent({
    required this.icon,
    required this.tone,
    required this.title,
    required this.dateLine,
    this.detail,
    this.badge,
    this.economy,
  });

  final String icon;
  final ToneColors tone;
  final String title;
  final String dateLine;
  final String? detail;
  final _Badge? badge;
  final String? economy;
}

class _RowFrame extends StatelessWidget {
  const _RowFrame({required this.entry, required this.content, required this.onTap});

  final HistoryEntry entry;
  final _RowContent content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return Material(
      color: scheme.surfaceContainerLowest,
      borderRadius: AppTheme.cardRadius,
      shadowColor: scheme.shadow.withValues(alpha: 0.2),
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.cardRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ServiceIconTile(icon: content.icon, tone: content.tone, iconSize: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        content.dateLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                      ),
                      if (content.detail case final detail? when detail.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            detail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(color: tones.muted),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: formatAmount(entry.cost, l10n.localeName),
                        children: [
                          TextSpan(
                            text: ' ${l10n.historyToman}',
                            style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                          ),
                        ],
                      ),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (content.badge case final badge?) _BadgeChip(badge: badge),
                        if (content.economy case final economy?) _EconomyChip(text: economy),
                        if (onTap != null)
                          // chevron_right mirrors to point left (forward) in RTL.
                          Icon(Icons.chevron_right, size: 18, color: scheme.outlineVariant),
                      ],
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

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.badge});

  final _Badge badge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (icon, label, background) = switch (badge) {
      _Badge.invoice => (Icons.receipt, l10n.historyInvoiceBadge, scheme.surfaceContainerHigh),
      _Badge.attachment => (
        Icons.attach_file,
        l10n.historyAttachmentBadge,
        scheme.surfaceContainer,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: scheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _EconomyChip extends StatelessWidget {
  const _EconomyChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = AppTones.of(context).info;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: info.chipBackground, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: theme.textTheme.labelSmall?.copyWith(color: info.chipForeground)),
    );
  }
}
