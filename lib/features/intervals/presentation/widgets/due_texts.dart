import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/tone_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/due_item.dart';
import '../../domain/entities/due_status.dart';

/// The status badge label: "رسیدگی فوری", "نزدیک به موعد", "اطلاعیه" (`ok` has no badge).
String dueStatusLabel(DueStatus status, AppLocalizations l10n) => switch (status) {
  DueStatus.overdue => l10n.dueStatusOverdue,
  DueStatus.dueSoon => l10n.dueStatusDueSoon,
  DueStatus.upcoming => l10n.dueStatusUpcoming,
  DueStatus.ok => '',
};

/// The status tint from the shared theme (rose, amber, sky; emerald for `ok`).
ToneColors dueStatusTone(DueStatus status, AppTones tones) => switch (status) {
  DueStatus.overdue => tones.overdue,
  DueStatus.dueSoon => tones.dueSoon,
  DueStatus.upcoming => tones.info,
  DueStatus.ok => tones.ok,
};

/// How far an item is from its due point, on whichever axis is worse: "۳۵۰ کیلومتر گذشته از موعد",
/// "تنها ۱۵۰ کیلومتر مانده", "۱٬۱۵۰ کیلومتر مانده (حدود ۱ ماه)" or the day variants.
String dueRemainingText(DueItem item, AppLocalizations l10n) {
  final byKm = item.worseAxis == DueAxis.km;
  final months = (item.remainingDays / 30).round().clamp(1, 1 << 30);
  return switch (item.status) {
    DueStatus.overdue =>
      byKm ? l10n.dueOverdueKm(-item.remainingKm) : l10n.dueOverdueDays(-item.remainingDays),
    DueStatus.dueSoon =>
      byKm ? l10n.dueSoonKm(item.remainingKm) : l10n.dueSoonDays(item.remainingDays),
    DueStatus.upcoming || DueStatus.ok =>
      byKm
          ? l10n.dueUpcomingKm(item.remainingKm, months)
          : l10n.dueUpcomingDays(item.remainingDays, months),
  };
}

/// The icon of the remaining line: `error`, `timelapse`, `info`.
IconData dueRemainingIcon(DueStatus status) => switch (status) {
  DueStatus.overdue => Icons.error_outline,
  DueStatus.dueSoon => Icons.timelapse,
  DueStatus.upcoming || DueStatus.ok => Icons.info_outline,
};
