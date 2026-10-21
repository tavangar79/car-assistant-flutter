/// How close an interval is to its due point, worst first (the API's sort order).
enum DueStatus {
  overdue,
  dueSoon,
  upcoming,
  ok;

  /// The wire value: `overdue | due_soon | upcoming | ok`. Unknown values read as [ok].
  static DueStatus fromApi(String value) => switch (value) {
    'overdue' => DueStatus.overdue,
    'due_soon' => DueStatus.dueSoon,
    'upcoming' => DueStatus.upcoming,
    _ => DueStatus.ok,
  };

  bool get needsAttention => this != DueStatus.ok;
}
