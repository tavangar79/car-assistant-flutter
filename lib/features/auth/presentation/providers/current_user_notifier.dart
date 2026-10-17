import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';

/// The signed-in user, or `null` when signed out or not loaded. Written by `AuthStatusNotifier`.
class CurrentUserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  void set(User? user) => state = user;
}
