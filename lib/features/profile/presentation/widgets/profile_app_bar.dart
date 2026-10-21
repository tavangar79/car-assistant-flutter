import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Top bar of the Profile tab (Stitch "پروفایل"): the account avatar and "پروفایل" at the start,
/// notifications at the end. 64px high.
class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      scrolledUnderElevation: 1,
      shadowColor: scheme.shadow.withValues(alpha: 0.04),
      title: Row(
        children: [
          Semantics(
            label: l10n.accountLabel,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primary,
              child: Icon(Icons.person, size: 18, color: scheme.onPrimary),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l10n.navProfile,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: l10n.notifications,
          // TODO(phase-5): open the notifications list.
          onPressed: () {},
          iconSize: 24,
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          color: scheme.onSurfaceVariant,
          icon: const Icon(Icons.notifications_outlined),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
