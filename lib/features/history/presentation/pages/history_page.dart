import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_bar.dart';
import '../../../../l10n/app_localizations.dart';

/// The History tab. A placeholder until the service history is designed.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: MainAppBar(title: l10n.navHistory),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
