import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_item.dart';

/// Body of `GET /api/service-items`: `{ categories: [ { id, title, items: [ { id, title, subtitle,
/// icon } ] } ] }`.
class ServiceCatalogDto {
  const ServiceCatalogDto({required this.categories});

  factory ServiceCatalogDto.fromJson(Map<String, dynamic> json) => ServiceCatalogDto(
    categories: (json['categories'] as List<dynamic>)
        .map((category) => ServiceCategoryDto.fromJson(category as Map<String, dynamic>))
        .toList(),
  );

  final List<ServiceCategoryDto> categories;

  List<ServiceCategory> toEntity() => categories.map((dto) => dto.toEntity()).toList();
}

class ServiceCategoryDto {
  const ServiceCategoryDto({required this.id, required this.title, required this.items});

  factory ServiceCategoryDto.fromJson(Map<String, dynamic> json) => ServiceCategoryDto(
    id: json['id'] as String,
    title: json['title'] as String,
    items: (json['items'] as List<dynamic>)
        .map((item) => ServiceItemDto.fromJson(item as Map<String, dynamic>))
        .toList(),
  );

  final String id;
  final String title;
  final List<ServiceItemDto> items;

  ServiceCategory toEntity() =>
      ServiceCategory(id: id, title: title, items: items.map((dto) => dto.toEntity()).toList());
}

class ServiceItemDto {
  const ServiceItemDto({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  factory ServiceItemDto.fromJson(Map<String, dynamic> json) => ServiceItemDto(
    id: json['id'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    icon: json['icon'] as String,
  );

  final String id;
  final String title;
  final String subtitle;
  final String icon;

  ServiceItem toEntity() => ServiceItem(id: id, title: title, subtitle: subtitle, icon: icon);
}
