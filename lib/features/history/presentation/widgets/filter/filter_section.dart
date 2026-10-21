import 'package:flutter/material.dart';

/// A titled section of the filter page: the [title], an optional [hint] after it and a [trailing]
/// widget at the end, then [child].
class FilterSection extends StatelessWidget {
  const FilterSection({
    super.key,
    required this.title,
    required this.child,
    this.hint,
    this.trailing,
  });

  final String title;
  final String? hint;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
              if (hint case final hint?) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    hint,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
              const Spacer(),
              ?trailing,
            ],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

/// A small grey pill, e.g. "انتخاب شده: ۱ خودرو".
class FilterPill extends StatelessWidget {
  const FilterPill({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}
