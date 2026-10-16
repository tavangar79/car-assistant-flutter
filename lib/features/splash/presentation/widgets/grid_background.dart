import 'package:flutter/material.dart';

/// Faint square grid (1px lines every 32px) painted behind the splash content.
class GridBackground extends StatelessWidget {
  const GridBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final lineColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03);
    return CustomPaint(
      painter: GridPainter(lineColor: lineColor),
      child: child,
    );
  }
}

class GridPainter extends CustomPainter {
  const GridPainter({required this.lineColor});

  static const cellSize = 32.0;

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = lineColor;
    for (var x = 0.0; x < size.width; x += cellSize) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 1, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += cellSize) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => oldDelegate.lineColor != lineColor;
}
