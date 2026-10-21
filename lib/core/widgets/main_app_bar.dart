import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../l10n/app_localizations.dart';

/// Top bar shared by the tabs (Stitch "گاراژ خالی"): logo, [title] and an optional [subtitle] under
/// it at the start, notifications and the account avatar at the end. 64px high.
///
/// The garage with vehicles (Stitch "گاراژ من") shows a [badge] pill next to the title and its own
/// [actions] instead of notifications and the avatar.
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, required this.title, this.subtitle, this.badge, this.actions});

  final String title;
  final String? subtitle;
  final String? badge;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
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
          SvgPicture.asset('assets/images/logo.svg', height: 32, excludeFromSemantics: true),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
                ),
                if (subtitle case final subtitle?)
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
              ],
            ),
          ),
          if (badge case final badge?) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                badge,
                style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
              ),
            ),
          ],
        ],
      ),
      actions: actions ?? _defaultActions(context),
    );
  }

  List<Widget> _defaultActions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return [
      IconButton(
        tooltip: l10n.notifications,
        // TODO(notifications): open the notifications list once it exists.
        onPressed: () {},
        iconSize: 22,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        color: scheme.onSurfaceVariant,
        icon: const Icon(Icons.notifications_outlined),
      ),
      const SizedBox(width: 8),
      Semantics(
        label: l10n.accountLabel,
        child: CircleAvatar(
          radius: 16,
          backgroundColor: scheme.primary,
          child: Icon(Icons.person, size: 18, color: scheme.onPrimary),
        ),
      ),
      const SizedBox(width: 16),
    ];
  }
}
