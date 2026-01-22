import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../themes/neo_brutal_theme.dart';

/// A premium animated background with floating geometric particles
class PremiumParticleBackground extends StatefulWidget {
  const PremiumParticleBackground({super.key});

  @override
  State<PremiumParticleBackground> createState() =>
      _PremiumParticleBackgroundState();
}

class _PremiumParticleBackgroundState extends State<PremiumParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final int _particleCount = 15;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _particles = List.generate(_particleCount, (_) => _Particle.random());
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
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final bool isLime;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.isLime,
  });

  factory _Particle.random() {
    final random = math.Random();
    return _Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: 4 + random.nextDouble() * 16,
      speed: 0.3 + random.nextDouble() * 0.7,
      opacity: 0.1 + random.nextDouble() * 0.3,
      isLime: random.nextBool(),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final animatedY = (particle.y + progress * particle.speed) % 1.0;
      final x = particle.x * size.width;
      final y = animatedY * size.height;

      // Fade in/out at edges
      double opacity = particle.opacity;
      if (animatedY < 0.1) {
        opacity *= animatedY / 0.1;
      } else if (animatedY > 0.9) {
        opacity *= (1.0 - animatedY) / 0.1;
      }

      final color = particle.isLime
          ? NeoBrutalColors.lime.withValues(alpha: opacity)
          : NeoBrutalColors.purple.withValues(alpha: opacity);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Draw geometric shapes (squares for NeoBrutal aesthetic)
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Animated logo reveal with staggered letter animation
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
        const _AnimatedDotsIndicator(),
      ],
    );
  }
}

/// Animated dots loading indicator (● ○ ○)
class _AnimatedDotsIndicator extends StatefulWidget {
  const _AnimatedDotsIndicator();

  @override
  State<_AnimatedDotsIndicator> createState() => _AnimatedDotsIndicatorState();
}

class _AnimatedDotsIndicatorState extends State<_AnimatedDotsIndicator>
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
            // Stagger the animation for each dot
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

/// Minimal premium loading indicator
class PremiumLoadingIndicator extends StatelessWidget {
  const PremiumLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated progress line
        SizedBox(
              width: 120,
              height: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: LinearProgressIndicator(
                  backgroundColor: NeoBrutalColors.mediumGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    NeoBrutalColors.lime.withValues(alpha: 0.8),
                  ),
                ),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(
              duration: const Duration(milliseconds: 1500),
              color: NeoBrutalColors.white.withValues(alpha: 0.3),
            ),
        const SizedBox(height: 16),
        // Subtle loading text
        Text(
              'INITIALIZING',
              style: NeoBrutalTheme.mono.copyWith(
                fontSize: 10,
                letterSpacing: 4,
                color: NeoBrutalColors.lime.withValues(alpha: 0.6),
              ),
            )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(
              begin: 1.0,
              end: 0.5,
              duration: const Duration(milliseconds: 1000),
            ),
      ],
    );
  }
}

/// Ambient glow effect for background
class AmbientGlowBackground extends StatelessWidget {
  const AmbientGlowBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient
        Container(
          decoration: BoxDecoration(
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
          child:
              Container(
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
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
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
          child:
              Container(
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
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
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
