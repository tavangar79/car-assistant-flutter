import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// A centred load error: one localized [message] and a retry button.
class LoadErrorView extends StatelessWidget {
  const LoadErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: Text(AppLocalizations.of(context).retry)),
        ],
      ),
    );
  }
}
