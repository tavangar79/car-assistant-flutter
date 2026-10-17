import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/main_app_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// The Profile tab. A placeholder that keeps sign-out reachable until the profile is designed.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: MainAppBar(title: l10n.navProfile),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.comingSoon),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => ref.read(authStatusProvider.notifier).logout(),
              style: OutlinedButton.styleFrom(minimumSize: const Size(200, 56)),
              icon: const Icon(Icons.logout),
              label: Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
  }
}
