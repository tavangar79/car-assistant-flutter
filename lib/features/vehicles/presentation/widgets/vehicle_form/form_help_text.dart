import 'package:flutter/material.dart';

import '../../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../../../core/theme/app_tones.dart';

/// The [error] under a field when there is one, otherwise the muted [help] line (if any).
class FormHelpText extends StatelessWidget {
  const FormHelpText({super.key, this.help, this.error});

  final String? help;
  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error case final message?) return AuthErrorText(message);
    if (help case final help?) {
      return Text(
        help,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTones.of(context).muted),
      );
    }
    return const SizedBox.shrink();
  }
}
