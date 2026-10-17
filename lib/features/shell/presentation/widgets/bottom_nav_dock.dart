import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'dock_add_button.dart';
import 'dock_item.dart';

/// Persistent bottom navigation (Stitch: 68px + safe area, 1px top border, level 3 shadow). In RTL the order reads
/// home, garage, the raised add button, history, profile. Tab indexes follow that order without the button.
class BottomNavDock extends StatelessWidget {
  const BottomNavDock({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAdd,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    Widget item(int index, IconData icon, String label) => DockItem(
      icon: icon,
      label: label,
      selected: index == currentIndex,
      onTap: () => onTabSelected(index),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
        // Stitch level 3: 0 -4px 20px rgba(15, 23, 42, 0.08).
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // The add button sits 16px above the bar's center line, so let it overflow upward.
              children: [
                item(0, Icons.home_outlined, l10n.navHome),
                item(1, Icons.directions_car_outlined, l10n.navGarage),
                Transform.translate(
                  offset: const Offset(0, -16),
                  child: DockAddButton(onPressed: onAdd),
                ),
                item(2, Icons.history, l10n.navHistory),
                item(3, Icons.person_outline, l10n.navProfile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
