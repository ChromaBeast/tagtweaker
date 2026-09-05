import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../themes/neo_brutal_theme.dart';

/// Animated background with floating geometric particles
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
