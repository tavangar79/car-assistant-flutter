import 'package:equatable/equatable.dart';

/// One item of a service visit. [cost] is part and labour together, in toman.
/// [nextDueKm] (km after the visit's odometer) and [nextDueMonths] (months after its date) are the
/// sticker reminder; `null` when none was set.
class ServiceLineItem extends Equatable {
  const ServiceLineItem({
    required this.itemId,
    required this.cost,
    this.brand,
    this.notes,
    this.nextDueKm,
    this.nextDueMonths,
  });

  final String itemId;
  final String? brand;
  final int cost;
  final String? notes;
  final int? nextDueKm;
  final int? nextDueMonths;

  bool get hasReminder => nextDueKm != null || nextDueMonths != null;

  @override
  List<Object?> get props => [itemId, brand, cost, notes, nextDueKm, nextDueMonths];
}
