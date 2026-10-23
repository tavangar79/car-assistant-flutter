import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_providers.dart';
import '../providers/otp_args.dart';
import '../providers/otp_state.dart';
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
/// On success the router guard moves on to the home tab.
///
/// The view: renders [otpViewModelProvider] and forwards user events to it.
class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key, required this.args});

  final OtpArgs args;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _code = TextEditingController();

  @override
  void initState() {
    super.initState();
    _code.addListener(
      () => ref.read(otpViewModelProvider(widget.args).notifier).codeChanged(_code.text),
    );
  }

  /// go_router can reuse this state when a new code is requested for another number. The new
  /// args get a fresh view model; only the boxes need emptying.
  @override
  void didUpdateWidget(OtpPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.args != oldWidget.args) _code.clear();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _resend() async {
    final args = widget.args;
    final sent = await ref.read(otpViewModelProvider(args).notifier).resend();
    // Ignore a late answer for a number the user has since changed.
    if (!sent || !mounted || args != widget.args) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).authCodeResent)));
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
    final provider = otpViewModelProvider(widget.args);
    final viewModel = ref.read(provider.notifier);
    final state = ref.watch(provider);
    // Keep the boxes in step when the view model clears the code (after a failed attempt).
    ref.listen<OtpState>(provider, (_, next) {
      if (next.code.isEmpty && _code.text.isNotEmpty) _code.clear();
    });
    final failure = state.failure;
    final error = failure == null ? null : authFailureMessage(failure, l10n);
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
              hasError: state.showsCodeError,
              onCompleted: (_) => viewModel.verify(),
            ),
            if (error != null) ...[const SizedBox(height: 10), AuthErrorText(error)],
            const SizedBox(height: 16),
            ResendCard(
              secondsLeft: state.secondsLeft,
              loading: state.isResending,
              onResend: _resend,
            ),
          ],
        ),
      ),
      dock: BottomActionDock(
        child: PrimaryCtaButton(
          label: l10n.authVerify,
          loading: state.isVerifying,
          onPressed: state.isComplete ? viewModel.verify : null,
        ),
      ),
    );
  }
}
