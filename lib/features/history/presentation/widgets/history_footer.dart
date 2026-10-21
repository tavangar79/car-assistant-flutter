import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../l10n/app_localizations.dart';
import 'history_formats.dart';

/// The end-of-records milestone: a flag and "شروع تاریخچه …" with the Jalali month and year the
/// vehicle was added ([startedAt]); just the flag when it is unknown.
class HistoryFooter extends StatelessWidget {
  const HistoryFooter({super.key, required this.startedAt});

  final DateTime? startedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final color = theme.colorScheme.secondary.withValues(alpha: 0.6);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.flag_outlined, size: 20, color: color),
          if (startedAt case final date?) ...[
            const SizedBox(height: 6),
            Text(
              l10n.historyStart(_monthYear(date, l10n)),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }

  static String _monthYear(DateTime date, AppLocalizations l10n) {
    final jalali = Jalali.fromDateTime(date.toLocal());
    return jalaliMonthYear(jalali.year, jalali.month, l10n);
  }
}
