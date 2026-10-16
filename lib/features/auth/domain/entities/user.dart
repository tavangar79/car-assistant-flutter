import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, required this.phone, required this.createdAt});

  final String id;

  /// Normalized `09xxxxxxxxx`.
  final String phone;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, phone, createdAt];
}
