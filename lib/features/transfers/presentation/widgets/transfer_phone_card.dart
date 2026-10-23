import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/phone_input_formatter.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';

/// "شماره تلفن همراه مالک جدید (خریدار)": the phone field (left to right, with the `+۹۸` chip
/// and a phone icon) and the note that the buyer has to accept.
class TransferPhoneCard extends StatelessWidget {
  const TransferPhoneCard({super.key, required this.controller});

  /// Holds the national digits grouped as `912 345 6789` ([PhoneInputFormatter]).
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.person_add_outlined, size: 20, color: scheme.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.transferPhoneTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.transferPhoneHint,
            style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
          ),
          const SizedBox(height: 12),
          Semantics(
            label: l10n.transferPhoneLabel,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                inputFormatters: const [PhoneInputFormatter()],
                style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                decoration: InputDecoration(
                  hintText: localizeDigits('912 ••• ••••', l10n.localeName),
                  hintStyle: theme.textTheme.headlineSmall?.copyWith(color: scheme.outline),
                  fillColor: scheme.surfaceContainerLow,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        localizeDigits('+98', l10n.localeName),
                        textDirection: TextDirection.ltr,
                        style: theme.textTheme.labelMedium?.copyWith(color: scheme.secondary),
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minHeight: 48),
                  suffixIcon: Icon(Icons.smartphone, color: scheme.secondary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tones.info.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: tones.info.foreground),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.transferPhoneNote,
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
