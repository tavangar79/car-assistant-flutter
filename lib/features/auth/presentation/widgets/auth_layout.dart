import 'package:flutter/material.dart';

import '../../../../core/widgets/grid_background.dart';

/// Shared frame of the auth pages: grid background, scrollable [content] and a primary [action]
/// pinned to the bottom (thumb zone), staying above the keyboard.
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.content, required this.action});

  final List<Widget> content;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return GridBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: content),
                ),
              ),
              const SizedBox(height: 16),
              action,
            ],
          ),
        ),
      ),
    );
  }
}
