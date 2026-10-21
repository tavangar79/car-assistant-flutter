import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import 'garage_card.dart';

/// "مدیریت و امکانات گاراژ": ownership transfer, the document wallet and the report export. Their
/// pages don't exist yet, so the rows are shown disabled (and the wallet without a document count).
class GarageToolsSection extends StatelessWidget {
  const GarageToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final divider = Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: scheme.surfaceContainer,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.garageToolsTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Text(
                l10n.garageToolsSubtitle,
                style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GarageCard(
          child: Column(
            children: [
              // TODO(phase-6): open "انتقال مالکیت خودرو".
              _ToolRow(
                icon: Icons.swap_horiz,
                title: l10n.garageToolTransferTitle,
                body: l10n.garageToolTransferBody,
              ),
              divider,
              // TODO(phase-5): open "کیف مدارک" and show the document count badge.
              _ToolRow(
                icon: Icons.folder_shared_outlined,
                title: l10n.garageToolDocumentsTitle,
                body: l10n.garageToolDocumentsBody,
              ),
              divider,
              // TODO(phase-6): open "خروجی گزارش".
              _ToolRow(
                icon: Icons.picture_as_pdf_outlined,
                title: l10n.garageToolExportTitle,
                body: l10n.garageToolExportBody,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A tool row: tinted icon tile, title, one-line description and chevron. Shown disabled until
/// its page exists.
class _ToolRow extends StatelessWidget {
  const _ToolRow({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tone = AppTones.of(context).neutral;
    return Semantics(
      button: true,
      enabled: false,
      hint: AppLocalizations.of(context).quickActionUnavailable,
      child: Opacity(
        opacity: 0.45,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tone.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: tone.foreground),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // chevron_right mirrors to point left (forward) in RTL.
              Icon(Icons.chevron_right, size: 20, color: scheme.secondary),
            ],
          ),
        ),
      ),
    );
  }
}
