import 'package:equatable/equatable.dart';

/// One service of the catalog (`GET /api/service-items`), e.g. `engine_oil`.
class ServiceItem extends Equatable {
  const ServiceItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;

  /// The Material Symbols name of the icon, e.g. `oil_barrel`.
  final String icon;

  @override
  List<Object?> get props => [id, title, subtitle, icon];
}
