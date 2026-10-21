/// The `categories` query of `GET /api/history`: the six service catalog categories plus [legal].
abstract final class HistoryCategories {
  /// Insurances, inspection, tolls and fines (every expense category but `other`).
  static const legal = 'legal';

  /// Every value, in screen order: the catalog's, then [legal].
  static const all = [
    'fluids',
    'brakes',
    'suspension',
    'electrical',
    'drivetrain',
    'periodic',
    legal,
  ];
}
