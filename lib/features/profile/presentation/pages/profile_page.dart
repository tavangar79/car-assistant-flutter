import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/format_version.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../splash/presentation/providers/splash_providers.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/profile_identity_card.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/profile_stat_tile.dart';

/// The Profile tab (Stitch `4b009228766f48859e449e996af538b9`): the identity card, the vehicle,
/// service and document counters, the settings and legal rows (disabled until their pages exist),
/// sign-out and the app version. The subscription card (T6.3) comes later.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: const ProfileAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          if (user != null)
            // TODO(profile-edit): open an edit flow once one exists; the complete-profile page is
            // only reachable while the profile is incomplete.
            ProfileIdentityCard(user: user, onEdit: null),
          const SizedBox(height: 16),
          const _Stats(),
          const SizedBox(height: 24),
          ProfileMenuSection(
            title: l10n.profileSettingsSection,
            items: [
              (
                icon: Icons.notifications_outlined,
                title: l10n.profileReminders,
                subtitle: l10n.profileRemindersHint,
              ),
              (icon: Icons.sms_outlined, title: l10n.profileSms, subtitle: l10n.profileSmsHint),
              (
                icon: Icons.lock_person_outlined,
                title: l10n.profileSecurity,
                subtitle: l10n.profileSecurityHint,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProfileMenuSection(
            title: l10n.profileLegalSection,
            items: [
              (
                icon: Icons.support_agent,
                title: l10n.profileSupport,
                subtitle: l10n.profileSupportHint,
              ),
              (
                icon: Icons.policy_outlined,
                title: l10n.profilePrivacy,
                subtitle: l10n.profilePrivacyHint,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _LogoutButton(onPressed: () => ref.read(authStatusProvider.notifier).logout()),
          const SizedBox(height: 8),
          const _VersionLine(),
        ],
      ),
    );
  }
}

/// "خودرو فعال", "سرویس ثبت‌شده" and "مدرک در کیف" from `GET /api/profile/stats`.
class _Stats extends ConsumerWidget {
  const _Stats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(profileStatsProvider)
        .when(
          loading: () =>
              const SizedBox(height: 112, child: Center(child: CircularProgressIndicator())),
          error: (_, _) => SizedBox(
            height: 112,
            child: LoadErrorView(
              message: l10n.profileStatsLoadError,
              onRetry: () => ref.invalidate(profileStatsProvider),
            ),
          ),
          data: (stats) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProfileStatTile(
                  icon: Icons.directions_car_outlined,
                  count: stats.vehicleCount,
                  label: l10n.profileStatVehicles,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ProfileStatTile(
                  icon: Icons.build_outlined,
                  count: stats.serviceCount,
                  label: l10n.profileStatServices,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ProfileStatTile(
                  icon: Icons.folder_shared_outlined,
                  count: stats.documentCount,
                  label: l10n.profileStatDocuments,
                ),
              ),
            ],
          ),
        );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: scheme.errorContainer.withValues(alpha: 0.4),
        foregroundColor: scheme.error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      icon: const Icon(Icons.logout, size: 20),
      label: Text(AppLocalizations.of(context).profileLogout),
    );
  }
}

/// "نسخه اپلیکیشن ۱٫۰٫۰"; nothing until the version is known.
class _VersionLine extends ConsumerWidget {
  const _VersionLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final version = ref.watch(appVersionProvider).value;
    if (version == null) return const SizedBox.shrink();
    return Text(
      l10n.profileAppVersion(formatVersion(version, l10n.localeName)),
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary),
    );
  }
}
