import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

/// White card of the garage (Stitch "گاراژ من": 16px radius, level-1 hairline and shadow).
/// With [onTap] the whole card is tappable.
class GarageCard extends StatelessWidget {
  const GarageCard({super.key, required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppTheme.cardRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}
