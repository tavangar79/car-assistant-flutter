import 'package:equatable/equatable.dart';

import 'user.dart';

/// Outcome of a successful code verification. The token itself stays in the data layer.
class AuthResult extends Equatable {
  const AuthResult({required this.user, required this.isNewUser});

  final User user;

  /// `true` when this verification created the account (register), `false` for a login.
  final bool isNewUser;

  @override
  List<Object?> get props => [user, isNewUser];
}
