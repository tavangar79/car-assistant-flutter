import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/avatar_file.dart';
import '../../domain/entities/user.dart';
import 'auth_providers.dart';

/// Uploads and removes the profile photo. The state carries loading and the last error.
class AvatarController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns `true` once uploaded; the updated user (new `avatarUrl`) is stored.
  Future<bool> upload(AvatarFile file) => _run(() => ref.read(uploadAvatarProvider).call(file));

  /// Returns `true` once removed.
  Future<bool> remove() => _run(() => ref.read(deleteAvatarProvider).call());

  Future<bool> _run(Future<Either<Failure, User>> Function() action) async {
    state = const AsyncLoading();
    final result = await action();
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
