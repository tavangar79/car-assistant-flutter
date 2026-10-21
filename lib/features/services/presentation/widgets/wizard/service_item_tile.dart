import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/utils/material_symbol_icon.dart';
import '../../../domain/entities/service_item.dart';

/// One catalog item of step 1: icon tile, title and subtitle, centred. When [selected] the card
/// has a navy ring and an amber check at its end corner.
class ServiceItemTile extends StatelessWidget {
  const ServiceItemTile({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final ServiceItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final amber = AppTones.of(context).amber;
    return Semantics(
      selected: selected,
      button: true,
      label: item.title,
      child: Material(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.5),
                width: selected ? 2 : 1,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: selected ? scheme.surfaceContainer : scheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          materialSymbolIcon(item.icon),
                          size: 26,
                          color: selected ? scheme.primary : scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
                if (selected)
                  PositionedDirectional(
                    top: -8,
                    end: -8,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: amber.chipBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, size: 16, color: amber.chipForeground),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
