import 'package:flutter/material.dart';

/// Thin indeterminate bar: an amber segment sweeping right-to-left every 2.2s.
class SplashLoadingBar extends StatefulWidget {
  const SplashLoadingBar({super.key});

  @override
  State<SplashLoadingBar> createState() => _SplashLoadingBarState();
}

class _SplashLoadingBarState extends State<SplashLoadingBar> with SingleTickerProviderStateMixin {
  static const _pill = BorderRadius.all(Radius.circular(999));

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  // Mirrors the design's keyframes: translateX 100% → -20% → -120% of the segment width.
  late final Animation<double> _offset = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: -0.2).chain(CurveTween(curve: Curves.fastOutSlowIn)),
      weight: 50,
    ),
    TweenSequenceItem(
      tween: Tween(begin: -0.2, end: -1.2).chain(CurveTween(curve: Curves.fastOutSlowIn)),
      weight: 50,
    ),
  ]).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: 4,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer.withValues(alpha: 0.8),
        borderRadius: _pill,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: ClipRRect(
        borderRadius: _pill,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: FractionallySizedBox(
            widthFactor: 1 / 3,
            heightFactor: 1,
            child: AnimatedBuilder(
              animation: _offset,
              builder: (context, child) =>
                  FractionalTranslation(translation: Offset(_offset.value, 0), child: child),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: _pill,
                  boxShadow: [
                    BoxShadow(color: scheme.primary.withValues(alpha: 0.5), blurRadius: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
