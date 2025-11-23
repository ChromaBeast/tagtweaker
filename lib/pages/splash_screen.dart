import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/splash_controller.dart';
import 'package:tag_tweaker/widgets/background_container.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the SplashController (runs navigation logic on init)
    Get.put(SplashController());
    return BackgroundContainer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glitchy Logo Text
            Text(
              'TAG TWEAKER',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                letterSpacing: 4,
                shadows: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                    duration: const Duration(seconds: 2),
                    color: Theme.of(context).colorScheme.secondary)
                .animate() // separate animation controller
                .fadeIn(duration: const Duration(milliseconds: 800))
                .scale(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600)),

            const SizedBox(height: 20),

            // Subtitle
            Text(
              'SYSTEM INITIALIZING...',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    letterSpacing: 2,
                  ),
            )
                .animate()
                .fadeIn(
                    delay: const Duration(milliseconds: 1000),
                    duration: const Duration(milliseconds: 800))
                .callback(callback: (_) => print('Animation complete')),
          ],
        ),
      ),
    );
  }
}
