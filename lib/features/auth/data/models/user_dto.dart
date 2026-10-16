import '../../domain/entities/user.dart';

/// `{ "id", "phone", "createdAt" }` from `GET /api/auth/me` and inside the verify response.
class UserDto {
  const UserDto({required this.id, required this.phone, required this.createdAt});

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    phone: json['phone'] as String,
    createdAt: json['createdAt'] as String,
  );

  final String id;
  final String phone;

  /// ISO-8601.
  final String createdAt;

  User toEntity() => User(id: id, phone: phone, createdAt: DateTime.parse(createdAt));
}
