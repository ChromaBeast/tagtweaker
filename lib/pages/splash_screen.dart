import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/splash_controller.dart';
import '../../themes/neo_brutal_theme.dart';
import 'dart:math' as math;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. The Code-Based Tunnel Animation
          const _NeoBrutalTunnel(),

          // 2. Glitchy Logo & Text Overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glitchy Logo Function
                SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      // Red Channel
                      Text(
                            'TAG TWEAKER',
                            style: NeoBrutalTheme.heading.copyWith(
                              fontSize: 48,
                              letterSpacing: 4,
                              color: Colors.red,
                            ),
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .move(
                            begin: const Offset(-2, 0),
                            end: const Offset(-4, 0),
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeInOut,
                          )
                          .fadeOut(begin: 0.5),

                      // Blue Channel
                      Text(
                            'TAG TWEAKER',
                            style: NeoBrutalTheme.heading.copyWith(
                              fontSize: 48,
                              letterSpacing: 4,
                              color: Colors.blue,
                            ),
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .move(
                            begin: const Offset(2, 0),
                            end: const Offset(4, 0),
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.bounceInOut,
                          )
                          .fadeOut(begin: 0.5),

                      // Main White Text
                      Text(
                            'TAG TWEAKER',
                            style: NeoBrutalTheme.heading.copyWith(
                              fontSize: 48,
                              letterSpacing: 4,
                              shadows: [
                                const BoxShadow(
                                  color: NeoBrutalColors.lime,
                                  offset: Offset(4, 4),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .shake(
                            hz: 8,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 1000),
                          )
                          .shimmer(
                            duration: 2000.ms,
                            color: NeoBrutalColors.lime,
                          ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Subtitle
                Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: NeoBrutalTheme.brutalBox(
                        color: NeoBrutalColors.black,
                        borderColor: NeoBrutalColors.lime,
                        borderWidth: 1,
                        shadowOffset: 0,
                      ),
                      child: Text(
                        'SYSTEM INITIALIZING...',
                        style: NeoBrutalTheme.mono.copyWith(
                          fontSize: 14,
                          letterSpacing: 3,
                          color: NeoBrutalColors.lime,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(
                      duration: const Duration(milliseconds: 1000),
                      delay: 500.ms,
                    )
                    .shimmer(
                      duration: const Duration(milliseconds: 1500),
                      color: NeoBrutalColors.white,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NeoBrutalTunnel extends StatefulWidget {
  const _NeoBrutalTunnel();

  @override
  State<_NeoBrutalTunnel> createState() => _NeoBrutalTunnelState();
}

class _NeoBrutalTunnelState extends State<_NeoBrutalTunnel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Loop continuously
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create multiple rectangles that scale up towards the user
    // To simulate an infinite tunnel, we space them out and fade them in/out
    final List<Widget> layers = [];
    const int count = 5;

    for (int i = 0; i < count; i++) {
      // Offset each layer's start time
      // 0.0 -> 1.0 progress for this layer
      final double startOffset = i / count;

      layers.add(
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Calculate effective progress for this layer
            // This modulo math makes it loop smoothly
            double progress = (_controller.value + startOffset) % 1.0;

            // Exponential scale looks more like "depth" (t^2 or t^3)
            // But linear feels more "brutal" and computer-y. Let's stick to exponential for depth perception.
            double scale = math.pow(progress * 10, 2).toDouble();
            if (scale < 0.1) scale = 0.1; // prevent 0 scale issues

            // Fade in at start, fade out at end
            double opacity = 1.0;
            if (progress < 0.2) {
              opacity = progress / 0.2;
            } else if (progress > 0.8) {
              opacity = (1.0 - progress) / 0.2;
            }

            // Alternate colors
            final Color color = (i % 2 == 0)
                ? NeoBrutalColors.lime
                : NeoBrutalColors.purple;

            return Center(
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color,
                        width:
                            8 /
                            scale, // Keep border visually consistent-ish or let it get huge?
                        // Let's actually let it get thick for brutalism, but maybe cap it.
                        // Actually fixed width border on scaling container will get massive.
                        // Let's try simplified:
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Stack(children: layers);
  }
}
