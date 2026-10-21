import 'package:equatable/equatable.dart';

import '../../../../core/utils/days_until.dart';

/// How a document stands today, from red to green: expired, due within 15 days, due within 30
/// days, valid for longer, or permanent (no expiry).
enum DocumentStatusKind { expired, dueSoon, upcoming, valid, permanent }

/// The status of a document and its day count: days past the expiry when [kind] is `expired`,
/// days left otherwise (0 for `permanent`).
class DocumentStatus extends Equatable {
  const DocumentStatus(this.kind, [this.days = 0]);

  /// The status of an expiry on [now] (calendar days, local time). An expiry today is due soon.
  factory DocumentStatus.of(DateTime? expiresAt, DateTime now) {
    if (expiresAt == null) return const DocumentStatus(DocumentStatusKind.permanent);
    final days = daysUntil(expiresAt, now);
    if (days < 0) return DocumentStatus(DocumentStatusKind.expired, -days);
    if (days <= dueSoonDays) return DocumentStatus(DocumentStatusKind.dueSoon, days);
    if (days <= upcomingDays) return DocumentStatus(DocumentStatusKind.upcoming, days);
    return DocumentStatus(DocumentStatusKind.valid, days);
  }

  /// Days left up to which the expiry is "near" (amber).
  static const dueSoonDays = 15;

  /// Days left up to which the expiry is shown as coming (blue).
  static const upcomingDays = 30;

  final DocumentStatusKind kind;
  final int days;

  bool get isExpired => kind == DocumentStatusKind.expired;

  @override
  List<Object?> get props => [kind, days];
}
