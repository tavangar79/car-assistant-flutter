import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Frame of the sign-in pages: a scrollable [body] and a [dock] pinned to the bottom.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.body, required this.dock});

  final Widget body;
  final Widget dock;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
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
    );
  }
}
