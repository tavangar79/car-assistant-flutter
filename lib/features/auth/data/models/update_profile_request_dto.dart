/// Body of `PUT /api/auth/me`: `{ "firstName", "lastName", "birthDate": "YYYY-MM-DD" }`.
class UpdateProfileRequestDto {
  const UpdateProfileRequestDto({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  final String firstName;
  final String lastName;

  /// Only the calendar date is sent.
  final DateTime birthDate;

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'birthDate': formatDate(birthDate),
  };

  /// `1991-11-12`.
  static String formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}-${two(date.month)}-${two(date.day)}';
  }
}
