import '../../domain/entities/user.dart';

/// `PublicUser` from `GET/PUT /api/auth/me` and inside the verify response:
/// `{ "id", "phone", "createdAt", "firstName", "lastName", "birthDate", "avatarUrl",
/// "isProfileComplete" }`.
class UserDto {
  const UserDto({
    required this.id,
    required this.phone,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.avatarUrl,
    required this.isProfileComplete,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    phone: json['phone'] as String,
    createdAt: json['createdAt'] as String,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    birthDate: json['birthDate'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
    isProfileComplete: json['isProfileComplete'] as bool,
  );

  final String id;
  final String phone;

  /// ISO-8601.
  final String createdAt;
  final String? firstName;
  final String? lastName;

  /// Gregorian `YYYY-MM-DD`.
  final String? birthDate;

  /// Relative server path, e.g. `/api/auth/me/avatar?v=1729150000000`.
  final String? avatarUrl;
  final bool isProfileComplete;

  User toEntity() => User(
    id: id,
    phone: phone,
    createdAt: DateTime.parse(createdAt),
    firstName: firstName,
    lastName: lastName,
    birthDate: birthDate == null ? null : DateTime.parse(birthDate!),
    avatarUrl: avatarUrl,
    isProfileComplete: isProfileComplete,
  );
}
