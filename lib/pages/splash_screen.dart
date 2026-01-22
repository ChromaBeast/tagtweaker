import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/splash_controller.dart';
import '../../themes/neo_brutal_theme.dart';
import '../../widgets/splash/splash_components.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return const Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: _PremiumSplashContent(),
    );
  }
}

class _PremiumSplashContent extends StatelessWidget {
  const _PremiumSplashContent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: Ambient glow background
        const AmbientGlowBackground(),

        // Layer 2: Floating particles
        const PremiumParticleBackground(),

        // Layer 3: Logo and content
        Center(
          child: const AnimatedLogoReveal().animate().fadeIn(
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 200),
          ),
        ),
      ],
    );
  }
}
