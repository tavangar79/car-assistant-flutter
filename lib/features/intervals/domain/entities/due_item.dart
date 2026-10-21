import 'package:equatable/equatable.dart';

import 'due_status.dart';

/// The axis (distance or time) that drives an item's status.
enum DueAxis { km, days }

/// One interval's due computation (`GET /api/vehicles/:id/due`). [remainingKm] and
/// [remainingDays] are negative once past due.
class DueItem extends Equatable {
  const DueItem({
    required this.intervalId,
    required this.title,
    required this.description,
    required this.icon,
    required this.coversItemIds,
    required this.status,
    required this.baselineKm,
    required this.baselineDate,
    required this.baselineServiceId,
    required this.dueKm,
    required this.dueDate,
    required this.remainingKm,
    required this.remainingDays,
  });

  /// The thresholds of the status matrix (DOMAIN.md).
  static const dueSoonKm = 500;
  static const dueSoonDays = 14;
  static const upcomingKm = 1500;
  static const upcomingDays = 30;

  final String intervalId;
  final String title;
  final String description;
  final String icon;
  final List<String> coversItemIds;
  final DueStatus status;
  final int baselineKm;
  final DateTime baselineDate;

  /// The visit that set the baseline, or `null` when the baseline is an odometer reading.
  final String? baselineServiceId;
  final int dueKm;
  final DateTime dueDate;
  final int remainingKm;
  final int remainingDays;

  /// The axis closer to (or further past) its due point, judged with the status thresholds;
  /// distance wins a tie, so the texts talk about km unless time is clearly the worse one.
  DueAxis get worseAxis {
    int rank(int remaining, int soon, int upcoming) => remaining <= 0
        ? 0
        : remaining <= soon
        ? 1
        : remaining <= upcoming
        ? 2
        : 3;
    final km = rank(remainingKm, dueSoonKm, upcomingKm);
    final days = rank(remainingDays, dueSoonDays, upcomingDays);
    return days < km ? DueAxis.days : DueAxis.km;
  }

  @override
  List<Object?> get props => [
    intervalId,
    title,
    description,
    icon,
    coversItemIds,
    status,
    baselineKm,
    baselineDate,
    baselineServiceId,
    dueKm,
    dueDate,
    remainingKm,
    remainingDays,
  ];
}
