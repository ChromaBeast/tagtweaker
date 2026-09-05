import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../themes/neo_brutal_theme.dart';

/// Ambient glow effect for splash and intro backgrounds
class AmbientGlowBackground extends StatelessWidget {
  const AmbientGlowBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [NeoBrutalColors.background, NeoBrutalColors.black],
            ),
          ),
        ),
        // Lime glow (top-left)
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  NeoBrutalColors.lime.withValues(alpha: 0.15),
                  NeoBrutalColors.lime.withValues(alpha: 0.0),
                ],
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.2, 1.2),
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
              ),
        ),
        // Purple glow (bottom-right)
        Positioned(
          bottom: -100,
          right: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  NeoBrutalColors.purple.withValues(alpha: 0.12),
                  NeoBrutalColors.purple.withValues(alpha: 0.0),
                ],
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1.2, 1.2),
                end: const Offset(1.0, 1.0),
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
              ),
        ),
      ],
    );
  }
}
