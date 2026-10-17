import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Bold field label, with a red `*` when [required].
class ProfileFieldLabel extends StatelessWidget {
  const ProfileFieldLabel(this.text, {super.key, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );
    return Row(
      children: [
        Text(text, style: style),
        if (required) ...[
          const SizedBox(width: 4),
          Semantics(
            label: AppLocalizations.of(context).profileRequiredLabel,
            child: ExcludeSemantics(
              child: Text('*', style: style?.copyWith(color: theme.colorScheme.error)),
            ),
          ),
        ],
      ],
    );
  }
}
