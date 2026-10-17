import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_providers.dart';
import '../providers/otp_args.dart';
import '../widgets/auth_error_text.dart';
import '../widgets/auth_failure_message.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/back_tile_button.dart';
import '../widgets/bottom_action_dock.dart';
import '../widgets/masked_phone_card.dart';
import '../widgets/otp_code_input.dart';
import '../widgets/otp_intro.dart';
import '../widgets/primary_cta_button.dart';
import '../widgets/resend_card.dart';

/// Enter the SMS code (Stitch screen `8e8f9a27ae4f4dcfbfe34140a8f9942a`).
/// On success the router guard moves on to the vehicles page.
class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key, required this.args});

  final OtpArgs args;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _code = TextEditingController();
  Timer? _timer;
  late int _secondsLeft;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    _code.addListener(() => setState(() {}));
    _startCountdown(widget.args.resendInSeconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    setState(() => _secondsLeft = seconds < 0 ? 0 : seconds);
    if (_secondsLeft == 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  bool get _isComplete => _code.text.length == widget.args.codeLength;

  Future<void> _verify() async {
    if (ref.read(otpControllerProvider).isLoading) return;
    final ok = await ref
        .read(otpControllerProvider.notifier)
        .verify(phone: widget.args.phone, code: _code.text);
    if (!ok && mounted) _code.clear();
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    final seconds = await ref.read(otpControllerProvider.notifier).resend(widget.args.phone);
    if (!mounted) return;
    setState(() => _resending = false);
    if (seconds != null) _startCountdown(seconds);
    if (!ref.read(otpControllerProvider).hasError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).authCodeResent)));
    }
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRoutes.phoneName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(otpControllerProvider);
    final error = state.hasError ? authFailureMessage(state.error!, l10n) : null;
    final verifying = state.isLoading && !_resending;
    return AuthScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BackTileButton(onPressed: _back),
            const SizedBox(height: 16),
            OtpIntro(codeLength: widget.args.codeLength),
            const SizedBox(height: 14),
            MaskedPhoneCard(phone: widget.args.phone, onEdit: _back),
            const SizedBox(height: 28),
            OtpCodeInput(
              length: widget.args.codeLength,
              controller: _code,
              hasError: error != null && _code.text.isEmpty,
              onCompleted: (_) => _verify(),
            ),
            if (error != null) ...[const SizedBox(height: 10), AuthErrorText(error)],
            const SizedBox(height: 16),
            ResendCard(secondsLeft: _secondsLeft, loading: _resending, onResend: _resend),
          ],
        ),
      ),
      dock: BottomActionDock(
        child: PrimaryCtaButton(
          label: l10n.authVerify,
          loading: verifying,
          onPressed: _isComplete ? _verify : null,
        ),
      ),
    );
  }
}
