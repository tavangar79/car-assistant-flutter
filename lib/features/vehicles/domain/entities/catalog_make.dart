import 'package:equatable/equatable.dart';

import 'catalog_model.dart';

/// A make (manufacturer) in the vehicle catalog with its models.
class CatalogMake extends Equatable {
  const CatalogMake({required this.id, required this.name, this.models = const []});

  final String id;
  final String name;
  final List<CatalogModel> models;

  @override
  List<Object?> get props => [id, name, models];
}
