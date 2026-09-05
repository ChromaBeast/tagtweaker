import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../themes/neo_brutal_theme.dart';

/// Animated logo reveal with staggered typography animation
class AnimatedLogoReveal extends StatelessWidget {
  const AnimatedLogoReveal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TAG - smaller, lime accent
        Text(
          'TAG',
          style: NeoBrutalTheme.mono.copyWith(
            fontSize: 16,
            letterSpacing: 12,
            fontWeight: FontWeight.w400,
            color: NeoBrutalColors.lime,
          ),
        )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
            )
            .slideY(
              begin: -0.3,
              end: 0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
            ),

        const SizedBox(height: 4),

        // TWEAKER - larger, main title
        Text(
          'TWEAKER',
          style: NeoBrutalTheme.heading.copyWith(
            fontSize: 48,
            letterSpacing: 8,
            fontWeight: FontWeight.w900,
          ),
        )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            )
            .slideY(
              begin: 0.2,
              end: 0,
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            )
            .then(delay: const Duration(milliseconds: 500))
            .shimmer(
              duration: const Duration(milliseconds: 2000),
              color: NeoBrutalColors.lime.withValues(alpha: 0.4),
            ),

        const SizedBox(height: 60),

        // Animated dots loading indicator
        const AnimatedDotsIndicator(),
      ],
    );
  }
}

/// Animated dots loading indicator (● ○ ○)
class AnimatedDotsIndicator extends StatefulWidget {
  const AnimatedDotsIndicator({super.key});

  @override
  State<AnimatedDotsIndicator> createState() => _AnimatedDotsIndicatorState();
}

class _AnimatedDotsIndicatorState extends State<AnimatedDotsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final dotProgress = (progress * 3 - index).clamp(0.0, 1.0);
            final isActive = dotProgress > 0 && dotProgress < 1;
            final opacity = isActive ? 1.0 : 0.3;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NeoBrutalColors.lime.withValues(alpha: opacity),
                ),
              ),
            );
          }),
        );
      },
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 800),
    );
  }
}
