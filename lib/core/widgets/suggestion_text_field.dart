import 'package:flutter/material.dart';

/// A text field that offers [suggestions] under it while it has focus: the most recent ones
/// while it is empty, then the ones containing what was typed (up to [maxSuggestions], never the
/// exact text). Tapping one fills the field. With no matches it is a plain field.
class SuggestionTextField extends StatefulWidget {
  const SuggestionTextField({
    super.key,
    required this.controller,
    required this.suggestions,
    this.decoration,
    this.onChanged,
    this.maxLength,
    this.style,
    this.textInputAction,
    this.maxSuggestions = 5,
  });

  final TextEditingController controller;
  final List<String> suggestions;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final int maxSuggestions;

  /// The suggestions that contain [query], excluding an exact match. An empty query offers the
  /// first [max] suggestions (most recent first, as the API orders them).
  static List<String> matches(List<String> suggestions, String query, {int max = 5}) {
    final needle = query.trim();
    if (needle.isEmpty) return suggestions.take(max).toList();
    return suggestions
        .where((option) => option.contains(needle) && option != needle)
        .take(max)
        .toList();
  }

  @override
  State<SuggestionTextField> createState() => _SuggestionTextFieldState();
}

class _SuggestionTextFieldState extends State<SuggestionTextField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_refresh);
    widget.controller.addListener(_refresh);
  }

  @override
  void didUpdateWidget(SuggestionTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_refresh);
      widget.controller.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    _focus.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _pick(String value) {
    widget.controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final options = _focus.hasFocus
        ? SuggestionTextField.matches(
            widget.suggestions,
            widget.controller.text,
            max: widget.maxSuggestions,
          )
        : const <String>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focus,
          onChanged: widget.onChanged,
          maxLength: widget.maxLength,
          style: widget.style,
          textInputAction: widget.textInputAction,
          decoration: widget.decoration,
        ),
        if (options.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final option in options)
                  ActionChip(
                    label: Text(option),
                    onPressed: () => _pick(option),
                    avatar: Icon(Icons.history, size: 16, color: scheme.onSurfaceVariant),
                    backgroundColor: scheme.surfaceContainer,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
