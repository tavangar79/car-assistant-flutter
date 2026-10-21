import 'package:equatable/equatable.dart';

/// One of the eight tracked intervals of a vehicle (`GET /api/vehicles/:id/intervals`): its
/// current [km] / [months] (an override when [isCustom]) and the factory defaults.
class ServiceInterval extends Equatable {
  const ServiceInterval({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.coversItemIds,
    required this.km,
    required this.months,
    required this.defaultKm,
    required this.defaultMonths,
    required this.isCustom,
  });

  final String id;
  final String title;
  final String description;

  /// The Material Symbols name of the icon, e.g. `oil_barrel`.
  final String icon;

  /// The catalog items whose visit resets this interval.
  final List<String> coversItemIds;
  final int km;
  final int months;
  final int defaultKm;
  final int defaultMonths;
  final bool isCustom;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    icon,
    coversItemIds,
    km,
    months,
    defaultKm,
    defaultMonths,
    isCustom,
  ];
}
