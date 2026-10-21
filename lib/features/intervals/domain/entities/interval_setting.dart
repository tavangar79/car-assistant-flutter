import 'package:equatable/equatable.dart';

/// The km and months to set for one interval (`PUT /api/vehicles/:id/intervals`).
class IntervalSetting extends Equatable {
  const IntervalSetting({required this.id, required this.km, required this.months});

  final String id;
  final int km;
  final int months;

  @override
  List<Object?> get props => [id, km, months];
}
