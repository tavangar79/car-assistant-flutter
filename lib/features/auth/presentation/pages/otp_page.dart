import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/auth_failures.dart';
import '../providers/auth_providers.dart';
import '../providers/otp_args.dart';
import '../widgets/auth_error_message.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_layout.dart';
import '../widgets/otp_code_field.dart';
import '../widgets/primary_action_button.dart';
import '../widgets/resend_timer.dart';

/// Step 2 of sign-in / sign-up: type the SMS code, with a resend countdown.
class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key, required this.args});

  final OtpArgs args;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _code = TextEditingController();
  late int _resendSeconds = widget.args.resendInSeconds;

  /// Bumped to restart the countdown.
  int _countdownRun = 0;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_code.text.isEmpty || ref.read(otpControllerProvider).isLoading) return;
    final notifier = ref.read(otpControllerProvider.notifier);
    // On success the router guard leaves the sign-in flow by itself.
    final signedIn = await notifier.verify(phone: widget.args.phone, code: _code.text);
    if (!signedIn && mounted) _code.clear();
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    final seconds = await ref.read(otpControllerProvider.notifier).resend(widget.args.phone);
    if (seconds == null || !mounted) return;
    setState(() {
      _resendSeconds = seconds;
      _countdownRun++;
    });
    // Rate limited: no new code was sent; the error text shows the wait.
    if (ref.read(otpControllerProvider).error is TooManyRequestsFailure) return;
    _code.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.authCodeResent)));
  }

  void _editPhone() => context.go(AppRoutes.phonePath);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(otpControllerProvider);
    final busy = state.isLoading;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          iconSize: 28,
          tooltip: l10n.back,
          onPressed: _editPhone,
          icon: const BackButtonIcon(),
        ),
      ),
      body: AuthLayout(
        content: [
          AuthHeader(
            title: l10n.authOtpTitle,
            subtitle: l10n.authOtpSubtitle(localizeDigits(widget.args.phone, l10n.localeName)),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: _editPhone,
              child: Text(l10n.authEditPhone),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: OtpCodeField(
              controller: _code,
              length: widget.args.codeLength,
              hasError: state.hasError,
              onCompleted: (_) => _verify(),
            ),
          ),
          if (state.hasError) ...[
            const SizedBox(height: 12),
            Text(
              authErrorMessage(l10n, state.error),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          ResendTimer(
            key: ValueKey(_countdownRun),
            seconds: _resendSeconds,
            onResend: busy ? null : _resend,
          ),
        ],
        action: ListenableBuilder(
          listenable: _code,
          builder: (context, _) => PrimaryActionButton(
            label: l10n.authVerify,
            loading: busy,
            onPressed: _code.text.isEmpty ? null : _verify,
          ),
        ),
      ),
    );
  }
}
