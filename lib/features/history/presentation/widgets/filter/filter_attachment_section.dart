import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import 'filter_section.dart';

/// "اسناد و مدارک مالی": the attachment-only switch.
class FilterAttachmentSection extends StatelessWidget {
  const FilterAttachmentSection({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return FilterSection(
      title: l10n.historyFilterDocuments,
      child: Material(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        elevation: 0.5,
        shadowColor: scheme.shadow.withValues(alpha: 0.2),
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.attachment, size: 22, color: scheme.onSurface),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.historyFilterAttachmentsOnly,
                        style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                      ),
                      Text(
                        l10n.historyFilterAttachmentsHint,
                        style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Switch(value: value, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
