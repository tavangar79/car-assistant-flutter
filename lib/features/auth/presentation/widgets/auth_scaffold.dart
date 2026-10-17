import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';

/// Frame of the sign-in pages: the light Stitch theme, a scrollable [body] and a [dock] pinned to
/// the bottom. Everything below reads the light theme from its own context.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.body, required this.dock});

  final Widget body;
  final Widget dock;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.light;
    return Theme(
      data: theme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(child: body),
                dock,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
