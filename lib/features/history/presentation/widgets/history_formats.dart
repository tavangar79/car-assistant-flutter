import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../expenses/presentation/widgets/expense_formats.dart';
import '../../domain/entities/history_filter.dart';
import '../../domain/entities/history_period.dart';

/// An amount in toman with grouping and locale digits, e.g. `۱٬۱۳۰٬۰۰۰`.
String formatAmount(int amount, String locale) =>
    NumberFormat.decimalPattern(locale).format(amount);

/// The Jalali year of [date] in locale digits, without grouping, e.g. `۱۴۰۵`.
String jalaliYearText(DateTime date, AppLocalizations l10n) =>
    localizeDigits('${Jalali.fromDateTime(date.toLocal()).year}', l10n.localeName);

/// A Jalali month and year, e.g. `آبان ۱۴۰۳`.
String jalaliMonthYear(int year, int month, AppLocalizations l10n) =>
    '${l10n.jalaliMonth('$month')} ${localizeDigits('$year', l10n.localeName)}';

/// The custom range of [filter] as numeric Jalali dates, e.g. `۱۴۰۵/۰۱/۰۱ تا ۱۴۰۵/۰۳/۳۱`.
String customRangeText(HistoryFilter filter, AppLocalizations l10n) => l10n.historyFilterRange(
  formatJalaliNumeric(filter.customFrom!, l10n.localeName),
  formatJalaliNumeric(filter.customTo!, l10n.localeName),
);

/// The label of the year chip of the history page: the applied period.
String periodChipLabel(HistoryFilter filter, DateTime now, AppLocalizations l10n) =>
    switch (filter.period) {
      HistoryPeriod.currentYear => jalaliYearText(now, l10n),
      HistoryPeriod.lastSixMonths => l10n.historyPeriodSixMonths,
      HistoryPeriod.allTime => l10n.historyPeriodAll,
      HistoryPeriod.custom => customRangeText(filter, l10n),
    };

/// The title of the summary card for the applied period.
String summaryTitle(HistoryFilter filter, DateTime now, AppLocalizations l10n) =>
    switch (filter.period) {
      HistoryPeriod.currentYear => l10n.historySummaryYear(jalaliYearText(now, l10n)),
      HistoryPeriod.lastSixMonths => l10n.historySummarySixMonths,
      HistoryPeriod.allTime => l10n.historySummaryAll,
      HistoryPeriod.custom => l10n.historySummaryCustom,
    };
