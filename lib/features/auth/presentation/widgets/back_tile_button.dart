import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// White 40px square back button with a left chevron, on the left edge as in the design.
/// The tap target is padded to 48px.
class BackTileButton extends StatelessWidget {
  const BackTileButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          tooltip: AppLocalizations.of(context).back,
          onPressed: onPressed,
          icon: const Icon(Icons.chevron_left, size: 20),
          style: IconButton.styleFrom(
            fixedSize: const Size.square(40),
            minimumSize: const Size.square(40),
            padding: EdgeInsets.zero,
            backgroundColor: scheme.surfaceContainerLowest,
            foregroundColor: scheme.secondary,
            side: BorderSide(color: scheme.outlineVariant),
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
        ),
      ),
    );
  }
}
