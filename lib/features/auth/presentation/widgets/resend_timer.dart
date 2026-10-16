import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/utils/format_countdown.dart';
import '../../../../l10n/app_localizations.dart';

/// Counts down [seconds], then shows a resend button. Give it a new key to restart.
class ResendTimer extends StatefulWidget {
  const ResendTimer({super.key, required this.seconds, required this.onResend});

  final int seconds;

  /// `null` disables the button (e.g. while a request is running).
  final VoidCallback? onResend;

  @override
  State<ResendTimer> createState() => _ResendTimerState();
}

class _ResendTimerState extends State<ResendTimer> {
  late int _left = widget.seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (_left > 0) _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer timer) {
    setState(() => _left--);
    if (_left <= 0) timer.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      child: Center(
        child: _left > 0
            ? Text(
                l10n.authResendIn(formatCountdown(_left, l10n.localeName)),
                style: Theme.of(context).textTheme.bodyLarge!
                    .copyWith(color: scheme.onSurfaceVariant),
              )
            : TextButton.icon(
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 56),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: widget.onResend,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.authResend),
              ),
      ),
    );
  }
}
