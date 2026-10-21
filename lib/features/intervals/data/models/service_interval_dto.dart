import '../../domain/entities/service_interval.dart';

/// One entry of `{ intervals: [...] }`.
class ServiceIntervalDto {
  const ServiceIntervalDto({
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

  factory ServiceIntervalDto.fromJson(Map<String, dynamic> json) => ServiceIntervalDto(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    icon: json['icon'] as String,
    coversItemIds: (json['coversItemIds'] as List<dynamic>).cast<String>(),
    km: json['km'] as int,
    months: json['months'] as int,
    defaultKm: json['defaultKm'] as int,
    defaultMonths: json['defaultMonths'] as int,
    isCustom: json['isCustom'] as bool,
  );

  /// Parses the `{ intervals: [...] }` envelope.
  static List<ServiceIntervalDto> listFromJson(Map<String, dynamic> json) =>
      (json['intervals'] as List<dynamic>)
          .map((item) => ServiceIntervalDto.fromJson(item as Map<String, dynamic>))
          .toList();

  final String id;
  final String title;
  final String description;
  final String icon;
  final List<String> coversItemIds;
  final int km;
  final int months;
  final int defaultKm;
  final int defaultMonths;
  final bool isCustom;

  ServiceInterval toEntity() => ServiceInterval(
    id: id,
    title: title,
    description: description,
    icon: icon,
    coversItemIds: coversItemIds,
    km: km,
    months: months,
    defaultKm: defaultKm,
    defaultMonths: defaultMonths,
    isCustom: isCustom,
  );
}
