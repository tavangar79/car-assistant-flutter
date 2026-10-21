import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/document_group.dart';
import '../../domain/entities/vehicle_document.dart';

/// The wallet chips with counts, scrolling sideways: "همه (۵)", "بیمه‌ها (۲)", "معاینه فنی (۱)",
/// "مدارک هویتی (۲)". The selected chip is navy; `null` is "همه".
class DocumentGroupChips extends StatelessWidget {
  const DocumentGroupChips({
    super.key,
    required this.documents,
    required this.selected,
    required this.onSelected,
  });

  final List<VehicleDocument> documents;
  final DocumentGroup? selected;
  final ValueChanged<DocumentGroup?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    int count(DocumentGroup group) => documents.where((d) => d.type.group == group).length;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final group in [null, ...DocumentGroup.values]) ...[
            _Chip(
              label: switch (group) {
                null => l10n.documentsFilterAll(documents.length),
                DocumentGroup.insurance => l10n.documentsGroupInsurance(count(group)),
                DocumentGroup.inspection => l10n.documentsGroupInspection(count(group)),
                DocumentGroup.identity => l10n.documentsGroupIdentity(count(group)),
              },
              selected: group == selected,
              onTap: () => onSelected(group),
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final shape = StadiumBorder(
      side: selected ? BorderSide.none : BorderSide(color: scheme.outlineVariant),
    );
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? scheme.primary : scheme.surfaceContainerLowest,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? scheme.onPrimary : scheme.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
