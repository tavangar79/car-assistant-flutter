/// The `type` query of `GET /api/history` (the tab row of the history page), and the type of an
/// entry ([all] is never an entry's type).
enum HistoryType {
  all('all'),
  service('service'),
  fuel('fuel'),
  expense('expense');

  const HistoryType(this.wire);

  /// The value on the wire.
  final String wire;

  static HistoryType fromWire(String wire) => values.firstWhere((type) => type.wire == wire);
}
