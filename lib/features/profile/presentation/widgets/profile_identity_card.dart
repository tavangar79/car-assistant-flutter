import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/user.dart';
import 'profile_avatar.dart';
import 'profile_card.dart';

/// The identity card: photo, name with the verified mark, phone, "عضو رسمی از …" (month and year joined) and
/// the edit button ([onEdit]; `null` shows it disabled).
class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({super.key, required this.user, required this.onEdit});

  final User user;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final names = [
      user.firstName,
      user.lastName,
    ].map((name) => name?.trim() ?? '').where((name) => name.isNotEmpty).toList();
    final since = Jalali.fromDateTime(user.createdAt.toLocal());
    return ProfileCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ProfileAvatar(initials: names.map((name) => name[0]).join('.')),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (names.isNotEmpty)
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          names.join(' '),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.verified,
                        size: 18,
                        color: scheme.primary,
                        semanticLabel: l10n.profilePhoneVerified,
                      ),
                    ],
                  ),
                Text(
                  formatPhone(user.phone, l10n.localeName),
                  textDirection: TextDirection.ltr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: scheme.secondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.profileMemberSince(
                    l10n.jalaliMonth('${since.month}'),
                    localizeDigits('${since.year}', l10n.localeName),
                  ),
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: l10n.profileEdit,
            onPressed: onEdit,
            style: IconButton.styleFrom(
              backgroundColor: scheme.surfaceContainerLow,
              foregroundColor: scheme.onSurface,
              disabledBackgroundColor: scheme.surfaceContainerLow,
              minimumSize: const Size.square(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.edit, size: 20),
          ),
        ],
      ),
    );
  }

  /// `09123456789` → `۰۹۱۲ ۳۴۵ ۶۷۸۹` (locale digits). Other lengths are only localized.
  static String formatPhone(String phone, String locale) {
    if (phone.length != 11) return localizeDigits(phone, locale);
    final grouped = '${phone.substring(0, 4)} ${phone.substring(4, 7)} ${phone.substring(7)}';
    return localizeDigits(grouped, locale);
  }
}
