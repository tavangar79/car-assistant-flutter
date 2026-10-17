import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// Centered card with the garage illustration, a short call to action and the add-vehicle button.
class EmptyGarageCard extends StatelessWidget {
  const EmptyGarageCard({super.key, required this.onAddVehicle});

  final VoidCallback onAddVehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Column(
        children: [
          const _Illustration(),
          const SizedBox(height: 16),
          Text(
            l10n.emptyGarageTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              l10n.emptyGarageBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAddVehicle,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              textStyle: theme.textTheme.labelLarge,
            ),
            icon: Icon(
              Icons.add_circle_outline,
              size: 20,
              color: AppTones.of(context).accentOnPrimary,
            ),
            label: Text(l10n.addVehicle),
          ),
        ],
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 144,
      height: 144,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scheme.surfaceContainerHigh.withValues(alpha: 0.6),
            scheme.surfaceContainerLow.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: SvgPicture.asset(
        'assets/images/empty_garage.svg',
        width: 112,
        height: 112,
        excludeFromSemantics: true,
        theme: SvgTheme(currentColor: scheme.secondary),
      ),
    );
  }
}
