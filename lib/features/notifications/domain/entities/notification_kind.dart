/// What a notification is about (the backend's `kind`).
enum NotificationKind {
  intervalDueSoon('interval_due_soon'),
  intervalOverdue('interval_overdue'),
  expenseExpiry('expense_expiry'),
  documentExpiry('document_expiry');

  const NotificationKind(this.wire);

  /// The value on the wire.
  final String wire;

  /// A service interval that is due soon or overdue.
  bool get isInterval => this == intervalDueSoon || this == intervalOverdue;

  static NotificationKind fromWire(String wire) => values.firstWhere((kind) => kind.wire == wire);
}
