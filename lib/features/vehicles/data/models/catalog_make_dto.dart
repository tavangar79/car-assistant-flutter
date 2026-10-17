import '../../domain/entities/catalog_make.dart';
import 'catalog_model_dto.dart';

/// JSON shape `{ "id", "name", "models": [...] }` of a catalog make.
class CatalogMakeDto {
  const CatalogMakeDto({required this.id, required this.name, required this.models});

  factory CatalogMakeDto.fromJson(Map<String, dynamic> json) => CatalogMakeDto(
    id: json['id'] as String,
    name: json['name'] as String,
    models: [
      for (final model in json['models'] as List<dynamic>)
        CatalogModelDto.fromJson(model as Map<String, dynamic>),
    ],
  );

  final String id;
  final String name;
  final List<CatalogModelDto> models;

  CatalogMake toEntity() =>
      CatalogMake(id: id, name: name, models: [for (final model in models) model.toEntity()]);
}
