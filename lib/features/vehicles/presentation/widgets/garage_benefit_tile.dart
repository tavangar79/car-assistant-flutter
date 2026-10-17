import 'package:flutter/material.dart';

/// One feature of a vehicle file under the empty garage: icon tile, one-line title and description.
class GarageBenefitTile extends StatelessWidget {
  const GarageBenefitTile({super.key, required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: scheme.onSurface),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                      ),
                    ),
                    // Mirrors in RTL, so it points left like the design.
                    Icon(Icons.chevron_right, size: 18, color: scheme.secondary),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
