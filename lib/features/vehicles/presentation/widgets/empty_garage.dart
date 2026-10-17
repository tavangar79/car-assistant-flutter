import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'empty_garage_card.dart';
import 'garage_benefit_tile.dart';

/// Shown when the user has no vehicles (Stitch "گاراژ خالی"): the add card and what a vehicle file offers.
class EmptyGarage extends StatelessWidget {
  const EmptyGarage({super.key, required this.onAddVehicle});

  final VoidCallback onAddVehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        EmptyGarageCard(onAddVehicle: onAddVehicle),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  l10n.garageBenefitsTitle,
                  style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.secondary),
                ),
              ),
              Text(
                l10n.garageBenefitsSteps(3),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GarageBenefitTile(
          icon: Icons.pin_outlined,
          title: l10n.benefitPlateTitle,
          body: l10n.benefitPlateBody,
        ),
        const SizedBox(height: 8),
        GarageBenefitTile(
          icon: Icons.oil_barrel_outlined,
          title: l10n.benefitServiceTitle,
          body: l10n.benefitServiceBody,
        ),
        const SizedBox(height: 8),
        GarageBenefitTile(
          icon: Icons.receipt_long_outlined,
          title: l10n.benefitRecordsTitle,
          body: l10n.benefitRecordsBody,
        ),
      ],
    );
  }
}
