import '../../domain/entities/service_suggestions.dart';

/// Body of `GET /api/service-suggestions`: `{ workshops: string[], brands: { itemId: string[] } }`.
class ServiceSuggestionsDto {
  const ServiceSuggestionsDto({required this.workshops, required this.brands});

  factory ServiceSuggestionsDto.fromJson(Map<String, dynamic> json) => ServiceSuggestionsDto(
    workshops: (json['workshops'] as List<dynamic>).cast<String>(),
    brands: {
      for (final MapEntry(:key, :value) in (json['brands'] as Map<String, dynamic>).entries)
        key: (value as List<dynamic>).cast<String>(),
    },
  );

  final List<String> workshops;
  final Map<String, List<String>> brands;

  ServiceSuggestions toEntity() => ServiceSuggestions(workshops: workshops, brands: brands);
}
