import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.phone,
    required this.createdAt,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.avatarUrl,
    required this.isProfileComplete,
  });

  final String id;

  /// Normalized `09xxxxxxxxx`.
  final String phone;
  final DateTime createdAt;
  final String? firstName;
  final String? lastName;

  /// Calendar date only (local midnight), Gregorian.
  final DateTime? birthDate;

  /// Server path of the profile photo (e.g. `/api/auth/me/avatar?v=…`), or `null` without one.
  /// Load it with the bearer token. It does not count towards [isProfileComplete].
  final String? avatarUrl;

  /// `false` until the user has saved a first name, last name and birth date.
  final bool isProfileComplete;

  @override
  List<Object?> get props => [
    id,
    phone,
    createdAt,
    firstName,
    lastName,
    birthDate,
    avatarUrl,
    isProfileComplete,
  ];
}
