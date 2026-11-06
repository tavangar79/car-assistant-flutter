import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_providers.dart';

/// Shown when the account is blocked (Stitch "حساب مسدود شده", screen
/// `0d21e7101fb04fce9305a330a323a1ff`): an icon, a title, the server message and one action, back
/// to the phone page. The router guard keeps a blocked user here.
class BlockedPage extends ConsumerWidget {
  const BlockedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final message = ref.watch(blockedMessageProvider) ?? l10n.blockedMessageFallback;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(child: _BlockedNotice(message: message)),
              ),
              const SizedBox(height: 16),
              _BackToLoginButton(
                label: l10n.blockedBackToLogin,
                onPressed: () => ref.read(authStatusProvider.notifier).leaveBlocked(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The block badge, the title and the server [message], centred.
class _BlockedNotice extends StatelessWidget {
  const _BlockedNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final tones = AppTones.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: tones.overdue.background,
              shape: BoxShape.circle,
              border: Border.all(color: tones.overdue.border),
            ),
            child: Icon(Icons.block, size: 48, color: tones.overdue.foreground),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.blockedTitle,
            textAlign: TextAlign.center,
            style: text.headlineSmall!.copyWith(
              fontSize: 24,
              height: 32 / 24,
              fontWeight: FontWeight.w700,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: text.bodyLarge!.copyWith(fontSize: 15, height: 1.625, color: tones.muted),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width 64dp navy button; the forward arrow sits left of the label, as in the design.
class _BackToLoginButton extends StatelessWidget {
  const _BackToLoginButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(64),
        textStyle: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_forward, size: 20),
            const SizedBox(width: 8),
            Flexible(child: Text(label, textDirection: TextDirection.rtl)),
          ],
        ),
      ),
    );
  }
}
