import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The server message of a blocked account, shown on the blocked page; `null` otherwise.
/// Written by `AuthStatusNotifier`.
class BlockedMessageNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? message) => state = message;
}
