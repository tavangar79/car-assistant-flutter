import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/service_category.dart';
import '../../../domain/entities/service_item.dart';
import '../service_icon_tile.dart';

/// "انتخاب سرویس": the enabled catalog items not yet on the visit, grouped by category, as 64dp
/// rows.
/// Returns the chosen item, or `null` when dismissed.
class ServiceItemPickerSheet extends StatelessWidget {
  const ServiceItemPickerSheet({super.key, required this.categories, required this.excludeIds});

  final List<ServiceCategory> categories;
  final Set<String> excludeIds;

  static Future<ServiceItem?> show(
    BuildContext context, {
    required List<ServiceCategory> categories,
    required Set<String> excludeIds,
  }) => showModalBottomSheet<ServiceItem>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => ServiceItemPickerSheet(categories: categories, excludeIds: excludeIds),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final groups = [
      for (final category in categories)
        if (category.items.where((item) => !item.disabled && !excludeIds.contains(item.id)).toList()
            case final items when items.isNotEmpty)
          (category.title, items),
    ];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.serviceEditorPickItem,
                  style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
                ),
              ),
              IconButton(
                tooltip: l10n.quickActionsClose,
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: scheme.surfaceContainer,
                  foregroundColor: scheme.onSurfaceVariant,
                ),
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (groups.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.serviceEditorNoItemsLeft,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: tones.muted),
              ),
            ),
          for (final (title, items) in groups) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Text(title, style: theme.textTheme.labelMedium?.copyWith(color: tones.muted)),
            ),
            for (final item in items)
              ListTile(
                minTileHeight: 64,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: ServiceIconTile(icon: item.icon, tone: tones.neutral),
                title: Text(item.title, style: theme.textTheme.headlineSmall),
                subtitle: Text(
                  item.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                onTap: () => Navigator.of(context).pop(item),
              ),
          ],
        ],
      ),
    );
  }
}
