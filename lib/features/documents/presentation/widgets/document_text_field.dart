import 'package:flutter/material.dart';

import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../expenses/presentation/widgets/expense_field.dart';
import '../../../services/presentation/widgets/wizard/wizard_field.dart';

/// A labelled text field of the document form (the expense form's look) with its error under it.
class DocumentTextField extends StatelessWidget {
  const DocumentTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.maxLength,
    required this.onChanged,
    this.error,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final String? error;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExpenseField(
          label: label,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLength: maxLength,
            maxLines: maxLines,
            minLines: 1,
            textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: wizardInputDecoration(context, hint: hint, hasError: error != null),
          ),
        ),
        if (error case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
      ],
    );
  }
}
