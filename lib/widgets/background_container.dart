import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final bool withGlow;

  const BackgroundContainer({
    super.key,
    required this.child,
    this.withGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Deep Void Background
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF050510),
            ),
          ),
          
          // Ambient Glows
          if (withGlow) ...[
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00F0FF).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .scale(duration: 4.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFBC13FE).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .scale(duration: 5.seconds, begin: const Offset(1, 1), end: const Offset(1.3, 1.3)),
            ),
          ],

          // Grid Pattern Overlay (Optional, adds tech feel)
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          ),

          // Content
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    const double spacing = 40;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
