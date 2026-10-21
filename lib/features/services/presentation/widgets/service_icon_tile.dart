import 'package:flutter/material.dart';

import '../../../../core/theme/tone_colors.dart';
import '../../../../core/utils/material_symbol_icon.dart';

/// A rounded tile with a catalog item's Material Symbols [icon], tinted with [tone].
class ServiceIconTile extends StatelessWidget {
  const ServiceIconTile({
    super.key,
    required this.icon,
    required this.tone,
    this.size = 44,
    this.iconSize = 24,
    this.radius = 12,
  });

  final String icon;
  final ToneColors tone;
  final double size;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: tone.background,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: tone.border),
    ),
    child: Icon(materialSymbolIcon(icon), size: iconSize, color: tone.foreground),
  );
}
