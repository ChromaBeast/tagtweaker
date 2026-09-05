import 'package:flutter/material.dart';

/// Highly optimized Canvas-based dashed line painter.
/// Replaces heavy widget trees (LayoutBuilder + List.generate of dozens of SizedBoxes).
class DashedLine extends StatelessWidget {
  final bool vertical;
  final Color? color;
  final double dashWidth;
  final double dashSpace;

  const DashedLine({
    super.key,
    required this.vertical,
    this.color,
    this.dashWidth = 5,
    this.dashSpace = 5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: vertical ? const Size(1, double.infinity) : const Size(double.infinity, 1),
      painter: _DashedLinePainter(
        vertical: vertical,
        color: color ?? Colors.white.withValues(alpha: 0.3),
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final bool vertical;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const _DashedLinePainter({
    required this.vertical,
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    double current = 0;
    final total = vertical ? size.height : size.width;

    while (current < total) {
      final end = (current + dashWidth).clamp(0.0, total);
      if (vertical) {
        canvas.drawLine(Offset(0, current), Offset(0, end), paint);
      } else {
        canvas.drawLine(Offset(current, 0), Offset(end, 0), paint);
      }
      current += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.vertical != vertical || oldDelegate.color != color;
}
