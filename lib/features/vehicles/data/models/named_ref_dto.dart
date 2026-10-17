import '../../domain/entities/named_ref.dart';

/// JSON shape `{ "id", "name" }` of a make, model or trim.
class NamedRefDto {
  const NamedRefDto({required this.id, required this.name});

  factory NamedRefDto.fromJson(Map<String, dynamic> json) =>
      NamedRefDto(id: json['id'] as String, name: json['name'] as String);

  final String id;
  final String name;

  NamedRef toEntity() => NamedRef(id: id, name: name);
}
