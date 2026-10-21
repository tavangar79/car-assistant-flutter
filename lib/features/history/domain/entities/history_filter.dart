import 'package:equatable/equatable.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/utils/recent_jalali_months.dart';
import 'history_period.dart';
import 'history_type.dart';

/// What the history page shows. [initial] is every record of every vehicle.
class HistoryFilter extends Equatable {
  const HistoryFilter({
    this.vehicleIds = const {},
    this.type = HistoryType.all,
    this.categories = const {},
    this.attachmentsOnly = false,
    this.period = HistoryPeriod.allTime,
    this.customFrom,
    this.customTo,
  });

  static const initial = HistoryFilter();

  /// The chosen vehicles; empty means every vehicle of the garage.
  final Set<String> vehicleIds;
  final HistoryType type;

  /// The chosen `HistoryCategories`; empty means no category filter.
  final Set<String> categories;

  /// Only services with an invoice and expenses with an attachment (fuel is dropped).
  final bool attachmentsOnly;
  final HistoryPeriod period;

  /// The first and last day of a [HistoryPeriod.custom] range (local dates), else `null`.
  final DateTime? customFrom;
  final DateTime? customTo;

  /// How many filters of the filter page are set (the type tabs are not counted).
  int get activeCount => [
    vehicleIds.isNotEmpty,
    categories.isNotEmpty,
    attachmentsOnly,
    period != HistoryPeriod.allTime,
  ].where((active) => active).length;

  HistoryFilter copyWith({
    Set<String>? vehicleIds,
    HistoryType? type,
    Set<String>? categories,
    bool? attachmentsOnly,
  }) => HistoryFilter(
    vehicleIds: vehicleIds ?? this.vehicleIds,
    type: type ?? this.type,
    categories: categories ?? this.categories,
    attachmentsOnly: attachmentsOnly ?? this.attachmentsOnly,
    period: period,
    customFrom: customFrom,
    customTo: customTo,
  );

  /// This filter with another [period]; [from] and [to] are the days of a custom range.
  HistoryFilter withPeriod(HistoryPeriod period, {DateTime? from, DateTime? to}) => HistoryFilter(
    vehicleIds: vehicleIds,
    type: type,
    categories: categories,
    attachmentsOnly: attachmentsOnly,
    period: period,
    customFrom: period == HistoryPeriod.custom ? from : null,
    customTo: period == HistoryPeriod.custom ? to : null,
  );

  /// The inclusive `(from, to)` bounds of [period] at [now]; `null` means unbounded.
  (DateTime?, DateTime?) range(DateTime now) {
    final local = now.toLocal();
    return switch (period) {
      HistoryPeriod.currentYear => (Jalali(Jalali.fromDateTime(local).year).toDateTime(), now),
      HistoryPeriod.lastSixMonths => (recentJalaliMonths(local).first.toDateTime(), now),
      HistoryPeriod.allTime => (null, null),
      HistoryPeriod.custom => (_startOfDay(customFrom), _endOfDay(customTo)),
    };
  }

  static DateTime? _startOfDay(DateTime? date) =>
      date == null ? null : DateTime(date.year, date.month, date.day);

  static DateTime? _endOfDay(DateTime? date) => date == null
      ? null
      : DateTime(date.year, date.month, date.day + 1).subtract(const Duration(milliseconds: 1));

  @override
  List<Object?> get props => [
    vehicleIds,
    type,
    categories,
    attachmentsOnly,
    period,
    customFrom,
    customTo,
  ];
}
