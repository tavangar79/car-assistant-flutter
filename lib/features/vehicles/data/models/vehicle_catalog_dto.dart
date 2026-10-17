import '../../domain/entities/catalog_make.dart';
import 'catalog_make_dto.dart';

/// JSON body of `GET /api/vehicle-catalog`: `{ "makes": [...] }`.
class VehicleCatalogDto {
  const VehicleCatalogDto({required this.makes});

  factory VehicleCatalogDto.fromJson(Map<String, dynamic> json) => VehicleCatalogDto(
    makes: [
      for (final make in json['makes'] as List<dynamic>)
        CatalogMakeDto.fromJson(make as Map<String, dynamic>),
    ],
  );

  final List<CatalogMakeDto> makes;

  List<CatalogMake> toEntity() => [for (final make in makes) make.toEntity()];
}
