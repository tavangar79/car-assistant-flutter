import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/phone_number.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_app_header.dart';
import '../widgets/auth_failure_message.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/bottom_action_dock.dart';
import '../widgets/features_section.dart';
import '../widgets/phone_entry_card.dart';
import '../widgets/phone_input_formatter.dart';
import '../widgets/phone_intro.dart';
import '../widgets/primary_cta_button.dart';
import '../widgets/terms_note.dart';

/// Sign in / sign up with a mobile number (Stitch screen `2f0dca69a97045d69d1e1aaef7fd6824`).
class PhonePage extends ConsumerStatefulWidget {
  const PhonePage({super.key});

  @override
  ConsumerState<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends ConsumerState<PhonePage> {
  final _phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phone.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String get _digits => PhoneInputFormatter.digitsOf(_phone.text);

  bool get _isValid => PhoneNumber.normalize('0$_digits') != null;

  Future<void> _submit() async {
    final args = await ref.read(phoneControllerProvider.notifier).submit('0$_digits');
    if (args != null && mounted) context.goNamed(AppRoutes.otpName, extra: args);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(phoneControllerProvider);
    final error = state.hasError ? authFailureMessage(state.error!, l10n) : null;
    return AuthScaffold(
      body: Column(
        children: [
          const AuthAppHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const PhoneIntro(),
                  PhoneEntryCard(
                    controller: _phone,
                    digitCount: _digits.length,
                    isValid: _isValid,
                    error: error,
                  ),
                  const SizedBox(height: 16),
                  const FeaturesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      dock: BottomActionDock(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryCtaButton(
              label: l10n.authSendCode,
              loading: state.isLoading,
              onPressed: _isValid ? _submit : null,
            ),
            const SizedBox(height: 12),
            const TermsNote(),
          ],
        ),
      ),
    );
  }
}
