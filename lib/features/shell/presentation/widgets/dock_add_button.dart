import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// The raised round add button in the middle of the dock (Stitch: 56x56, `add` glyph in the accent).
class DockAddButton extends StatelessWidget {
  const DockAddButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        tooltip: AppLocalizations.of(context).quickAdd,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: scheme.primary,
          foregroundColor: AppTones.of(context).accentOnPrimary,
          fixedSize: const Size.square(56),
        ),
        iconSize: 28,
        icon: const Icon(Icons.add),
      ),
    );
  }
}
