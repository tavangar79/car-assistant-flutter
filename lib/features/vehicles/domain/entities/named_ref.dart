import 'package:equatable/equatable.dart';

/// A catalog entry by id and display name, e.g. a make, model or trim.
class NamedRef extends Equatable {
  const NamedRef({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
