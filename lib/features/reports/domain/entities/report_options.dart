import 'package:equatable/equatable.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../history/domain/entities/history_type.dart';
import 'report_period.dart';
import 'report_query.dart';

/// The choices of the export page: which vehicles, which dates and which record types.
class ReportOptions extends Equatable {
  const ReportOptions({
    this.vehicleId,
    this.period = ReportPeriod.currentYear,
    this.customFrom,
    this.customTo,
    this.types = allTypes,
    this.includeImages = false,
  });

  /// The record types a report can hold, in display order.
  static const allTypes = {HistoryType.service, HistoryType.fuel, HistoryType.expense};

  /// The one vehicle of the report, or `null` for every vehicle of the garage.
  final String? vehicleId;
  final ReportPeriod period;

  /// The days of a [ReportPeriod.custom] range (local dates); `null` is unbounded.
  final DateTime? customFrom;
  final DateTime? customTo;
  final Set<HistoryType> types;

  /// Append the invoice and attachment images to the PDF.
  final bool includeImages;

  /// At least one record type is chosen, so a file can be made.
  bool get canExport => types.isNotEmpty;

  /// These options for one vehicle, or every vehicle when [vehicleId] is `null`.
  ReportOptions withVehicle(String? vehicleId) => _copy(vehicleId: vehicleId);

  ReportOptions withTypes(Set<HistoryType> types) => _copy(types: types);

  ReportOptions withImages(bool includeImages) => _copy(includeImages: includeImages);

  /// These options with a quick [period] (the custom days are dropped).
  ReportOptions withPeriod(ReportPeriod period) =>
      _copy(period: period, customFrom: null, customTo: null);

  /// These options with a custom range; a bound left out keeps the current one at [now].
  ReportOptions withCustomRange(DateTime now, {DateTime? from, DateTime? to}) {
    final (currentFrom, currentTo) = range(now);
    return _copy(
      period: ReportPeriod.custom,
      customFrom: from ?? _day(currentFrom),
      customTo: to ?? _day(currentTo ?? now),
    );
  }

  /// The inclusive `(from, to)` bounds at [now]; a `null` bound is unbounded.
  (DateTime?, DateTime?) range(DateTime now) {
    final local = now.toLocal();
    return switch (period) {
      ReportPeriod.lastThreeMonths => (_monthsBack(local, 3), now),
      ReportPeriod.lastSixMonths => (_monthsBack(local, 6), now),
      ReportPeriod.currentYear => (Jalali(Jalali.fromDateTime(local).year).toDateTime(), now),
      ReportPeriod.allTime => (null, null),
      ReportPeriod.custom => (_startOfDay(customFrom), _endOfDay(customTo)),
    };
  }

  /// The query of `GET /api/reports` at [now].
  ReportQuery toQuery(DateTime now) {
    final (from, to) = range(now);
    return ReportQuery(
      vehicleIds: [?vehicleId],
      types: [
        for (final type in allTypes)
          if (types.contains(type)) type,
      ],
      from: from,
      to: to,
    );
  }

  ReportOptions _copy({
    Object? vehicleId = _keep,
    ReportPeriod? period,
    Object? customFrom = _keep,
    Object? customTo = _keep,
    Set<HistoryType>? types,
    bool? includeImages,
  }) => ReportOptions(
    vehicleId: identical(vehicleId, _keep) ? this.vehicleId : vehicleId as String?,
    period: period ?? this.period,
    customFrom: identical(customFrom, _keep) ? this.customFrom : customFrom as DateTime?,
    customTo: identical(customTo, _keep) ? this.customTo : customTo as DateTime?,
    types: types ?? this.types,
    includeImages: includeImages ?? this.includeImages,
  );

  static const _keep = Object();

  /// The start of the same Jalali day [months] months before [date] (the last day of the month
  /// when that day does not exist there).
  static DateTime _monthsBack(DateTime date, int months) {
    final today = Jalali.fromDateTime(date);
    final index = today.year * 12 + (today.month - 1) - months;
    final first = Jalali(index ~/ 12, index % 12 + 1);
    final day = today.day < first.monthLength ? today.day : first.monthLength;
    return Jalali(first.year, first.month, day).toDateTime();
  }

  static DateTime? _day(DateTime? date) {
    if (date == null) return null;
    final local = date.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  static DateTime? _startOfDay(DateTime? date) =>
      date == null ? null : DateTime(date.year, date.month, date.day);

  static DateTime? _endOfDay(DateTime? date) => date == null
      ? null
      : DateTime(date.year, date.month, date.day + 1).subtract(const Duration(milliseconds: 1));

  @override
  List<Object?> get props => [vehicleId, period, customFrom, customTo, types, includeImages];
}
