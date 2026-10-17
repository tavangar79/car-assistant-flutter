import '../../domain/entities/catalog_model.dart';
import 'named_ref_dto.dart';

/// JSON shape `{ "id", "name", "trims": [{ "id", "name" }] }` of a catalog model.
class CatalogModelDto {
  const CatalogModelDto({required this.id, required this.name, required this.trims});

  factory CatalogModelDto.fromJson(Map<String, dynamic> json) => CatalogModelDto(
    id: json['id'] as String,
    name: json['name'] as String,
    trims: [
      for (final trim in json['trims'] as List<dynamic>)
        NamedRefDto.fromJson(trim as Map<String, dynamic>),
    ],
  );

  final String id;
  final String name;
  final List<NamedRefDto> trims;

  CatalogModel toEntity() =>
      CatalogModel(id: id, name: name, trims: [for (final trim in trims) trim.toEntity()]);
}
