import 'package:equatable/equatable.dart';

import 'named_ref.dart';

/// A model in the vehicle catalog with its trims.
class CatalogModel extends Equatable {
  const CatalogModel({required this.id, required this.name, this.trims = const []});

  final String id;
  final String name;
  final List<NamedRef> trims;

  @override
  List<Object?> get props => [id, name, trims];
}
