import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';

/// "تاریخ و زمان ثبت": the reading's Jalali date and time (prefixed with "امروز" when it is [now]'s
/// day) and the "تغییر تاریخ" button.
class RecordedAtRow extends StatelessWidget {
  const RecordedAtRow({super.key, required this.date, required this.now, required this.onChange});

  final DateTime date;
  final DateTime now;
  final VoidCallback onChange;

  /// The date and time as shown in the row.
  static String label(DateTime date, DateTime now, AppLocalizations l10n) {
    String two(int n) => n.toString().padLeft(2, '0');
    final time = localizeDigits('${two(date.hour)}:${two(date.minute)}', l10n.localeName);
    final day = formatJalaliDate(date, l10n);
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    return isToday
        ? l10n.odometerRecordedAtToday(day, time)
        : l10n.odometerRecordedAtValue(day, time);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.calendar_today, size: 18, color: scheme.onSurface),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.odometerRecordedAtLabel,
                  style: theme.textTheme.labelSmall?.copyWith(color: muted),
                ),
                Text(
                  label(date, now, l10n),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChange,
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
              backgroundColor: scheme.surfaceContainerLowest,
              foregroundColor: muted,
              textStyle: theme.textTheme.labelMedium,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: Text(l10n.odometerChangeDate),
          ),
        ],
      ),
    );
  }
}
