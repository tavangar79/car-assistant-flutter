import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/tone_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../expenses/presentation/widgets/expense_formats.dart';
import '../../domain/entities/document_status.dart';
import '../../domain/entities/vehicle_document.dart';
import 'document_formats.dart';

/// One document of the wallet (Stitch "کیف مدارک"): the file tile with its type strip, the title
/// with the status pill, "issuer — شماره: number", the Jalali issue and expiry dates, then a footer
/// with the reminder line and "مشاهده اصل فایل" (or "ثبت تمدید جدید" once expired). Tapping the
/// card opens it for editing.
class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.document,
    required this.now,
    required this.onOpen,
    required this.onViewFile,
    required this.onRenew,
  });

  final VehicleDocument document;
  final DateTime now;
  final VoidCallback onOpen;
  final VoidCallback onViewFile;
  final VoidCallback onRenew;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final status = DocumentStatus.of(document.expiresAt, now);
    final tone = documentStatusTone(status.kind, tones);
    final issuerLine = documentIssuerLine(document, l10n);
    final issuedAt = document.issuedAt;
    final expiresAt = document.expiresAt;
    final showReminder = document.expiryReminder && expiresAt != null && !status.isExpired;
    final hasFile = document.files.isNotEmpty;
    final mutedSmall = theme.textTheme.labelSmall?.copyWith(color: tones.label);
    return Material(
      color: scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: scheme.shadow.withValues(alpha: 0.3),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FileTile(document: document),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The pill moves under the title when both don't fit on one line.
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              documentTitle(document, l10n),
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface,
                              ),
                            ),
                            _StatusPill(label: documentStatusLabel(status, l10n), tone: tone),
                          ],
                        ),
                        if (issuerLine != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            issuerLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
                          ),
                        ],
                        if (issuedAt != null || expiresAt != null) ...[
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            children: [
                              if (issuedAt != null)
                                Text(
                                  l10n.documentIssuedAt(
                                    formatJalaliNumeric(issuedAt.toLocal(), l10n.localeName),
                                  ),
                                  style: mutedSmall,
                                ),
                              if (issuedAt != null && expiresAt != null)
                                Text('•', style: mutedSmall?.copyWith(color: scheme.outline)),
                              if (expiresAt != null)
                                Text(
                                  l10n.documentExpiresAt(
                                    formatJalaliNumeric(expiresAt.toLocal(), l10n.localeName),
                                  ),
                                  style: mutedSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: tone.chipForeground,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Semantics(
                    label: l10n.documentDetails,
                    // chevron_right mirrors to point left (forward) in RTL.
                    child: Icon(Icons.chevron_right, size: 20, color: scheme.outline),
                  ),
                ],
              ),
              if (showReminder || hasFile || status.isExpired) ...[
                const SizedBox(height: 10),
                Divider(height: 1, color: scheme.surfaceContainer),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (showReminder) ...[
                      Icon(Icons.notifications_active_outlined, size: 15, color: tone.foreground),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          l10n.documentReminderOn,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(color: tone.chipForeground),
                        ),
                      ),
                    ] else
                      const Spacer(),
                    if (status.isExpired)
                      _FooterAction(
                        label: l10n.documentRenew,
                        icon: Icons.add_circle_outline,
                        color: tone.chipForeground,
                        onPressed: onRenew,
                      )
                    else if (hasFile)
                      _FooterAction(
                        label: l10n.documentViewFile,
                        icon: Icons.visibility_outlined,
                        color: scheme.onSurface,
                        onPressed: onViewFile,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The 48px file tile: the type icon with a dark "PDF" / "JPG" / "N تصویر" strip at its bottom.
class _FileTile extends StatelessWidget {
  const _FileTile({required this.document});

  final VehicleDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final badge = documentFileBadge(document.files, l10n);
    return Container(
      width: 48,
      height: 48,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: badge == null ? 0 : 10),
              child: Icon(documentTypeIcon(document.type), size: 22, color: scheme.secondary),
            ),
          ),
          if (badge != null)
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              child: Container(
                color: scheme.inverseSurface.withValues(alpha: 0.8),
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text(
                  badge,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: scheme.onInverseSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The tinted status pill with its dot.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.tone});

  final String label;
  final ToneColors tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tone.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: tone.foreground, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: tone.chipForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterAction extends StatelessWidget {
  const _FooterAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(label), const SizedBox(width: 4), Icon(icon, size: 15)],
      ),
    );
  }
}
