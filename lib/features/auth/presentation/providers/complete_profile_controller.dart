import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'auth_providers.dart';

/// Saves the profile for the complete-profile page. The state carries loading and the last error.
class CompleteProfileController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns `true` once saved; the updated user then moves the router on to the home tab.
  Future<bool> save({
    required String firstName,
    required String lastName,
    required DateTime? birthDate,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(updateProfileProvider)
        .call(firstName: firstName, lastName: lastName, birthDate: birthDate);
    if (!ref.mounted) return false;
    switch (result) {
      case Right(value: final user):
        ref.read(authStatusProvider.notifier).signIn(user);
        state = const AsyncData(null);
        return true;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return false;
    }
  }
}
