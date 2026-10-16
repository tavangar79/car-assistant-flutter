import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_error_message.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_layout.dart';
import '../widgets/phone_field.dart';
import '../widgets/primary_action_button.dart';

/// Step 1 of sign-in / sign-up: enter the mobile number and get an SMS code.
class PhonePage extends ConsumerStatefulWidget {
  const PhonePage({super.key});

  @override
  ConsumerState<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends ConsumerState<PhonePage> {
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(phoneControllerProvider).isLoading) return;
    final args = await ref.read(phoneControllerProvider.notifier).submit(_phone.text);
    if (args != null && mounted) context.go(AppRoutes.otpPath, extra: args);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(phoneControllerProvider);
    return Scaffold(
      body: AuthLayout(
        content: [
          const SizedBox(height: 48),
          AuthHeader(title: l10n.authPhoneTitle, subtitle: l10n.authPhoneSubtitle),
          const SizedBox(height: 32),
          PhoneField(
            controller: _phone,
            onSubmitted: _submit,
            errorText: state.hasError ? authErrorMessage(l10n, state.error) : null,
          ),
        ],
        action: PrimaryActionButton(
          label: l10n.authSendCode,
          loading: state.isLoading,
          onPressed: _submit,
        ),
      ),
    );
  }
}
