import 'package:equatable/equatable.dart';

import 'due_item.dart';
import 'due_status.dart';

/// The due computation of a vehicle at [asOf]: all eight intervals, worst first.
class DueReport extends Equatable {
  const DueReport({required this.asOf, required this.mileageKm, required this.items});

  final DateTime asOf;
  final int mileageKm;
  final List<DueItem> items;

  /// The items that are not `ok`, in the API's order.
  List<DueItem> get pending => items.where((item) => item.status.needsAttention).toList();

  /// The items already due or about to be (`overdue` and `due_soon`).
  int get reachedCount => items
      .where((item) => item.status == DueStatus.overdue || item.status == DueStatus.dueSoon)
      .length;

  @override
  List<Object?> get props => [asOf, mileageKm, items];
}
