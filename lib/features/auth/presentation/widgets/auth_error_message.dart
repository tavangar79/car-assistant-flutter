import '../../../../core/utils/format_countdown.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/auth_failures.dart';

/// Localized, user-facing text for an auth error. Network and unknown errors get a generic text.
String authErrorMessage(AppLocalizations l10n, Object? error) => switch (error) {
  InvalidPhoneFailure() => l10n.authPhoneInvalid,
  InvalidCodeFailure() => l10n.authInvalidCode,
  SmsSendFailure() => l10n.authSmsFailed,
  TooManyRequestsFailure(:final retryAfterSeconds) when retryAfterSeconds > 0 =>
    l10n.authTooManyRequestsRetryIn(formatCountdown(retryAfterSeconds, l10n.localeName)),
  TooManyRequestsFailure() => l10n.authTooManyRequests,
  _ => l10n.authGenericError,
};
