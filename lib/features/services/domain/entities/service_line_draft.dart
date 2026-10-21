import 'package:equatable/equatable.dart';

/// What step 3 of the wizard holds for one item before it is checked. Digits are Latin.
class ServiceLineDraft extends Equatable {
  const ServiceLineDraft({
    this.brand = '',
    this.cost,
    this.notes = '',
    this.nextDueKm,
    this.nextDueMonths,
  });

  final String brand;
  final int? cost;
  final String notes;
  final int? nextDueKm;
  final int? nextDueMonths;

  ServiceLineDraft copyWith({
    String? brand,
    int? Function()? cost,
    String? notes,
    int? Function()? nextDueKm,
    int? Function()? nextDueMonths,
  }) => ServiceLineDraft(
    brand: brand ?? this.brand,
    cost: cost == null ? this.cost : cost(),
    notes: notes ?? this.notes,
    nextDueKm: nextDueKm == null ? this.nextDueKm : nextDueKm(),
    nextDueMonths: nextDueMonths == null ? this.nextDueMonths : nextDueMonths(),
  );

  @override
  List<Object?> get props => [brand, cost, notes, nextDueKm, nextDueMonths];
}
