import 'failure.dart';

/// The account is blocked by an admin (HTTP 403 with `details.code == "user_blocked"`), from any
/// call, sign-in included. [message] is the server's (Persian) text, shown on the blocked page.
class UserBlockedFailure extends Failure {
  const UserBlockedFailure([super.message = 'Account blocked']);
}
