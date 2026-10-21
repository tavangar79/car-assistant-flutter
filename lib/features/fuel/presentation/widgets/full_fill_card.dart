import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';

/// "باک کاملاً پر شد (باک پر)": the title with its dot, the explanation and the switch.
class FullFillCard extends StatelessWidget {
  const FullFillCard({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return WizardCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        l10n.fuelFullFillTitle,
                        style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: scheme.secondary, shape: BoxShape.circle),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.fuelFullFillBody,
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Semantics(
            label: l10n.fuelFullFillTitle,
            child: Switch(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
