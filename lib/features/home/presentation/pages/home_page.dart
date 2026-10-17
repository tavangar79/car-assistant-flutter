import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/presentation/widgets/vehicles_view.dart';

/// The Home tab. Until a dashboard is designed it shows the user's garage.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: AppLocalizations.of(context).navHome),
      body: const VehiclesView(),
    );
  }
}
