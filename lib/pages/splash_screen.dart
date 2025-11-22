import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/app/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the SplashController (runs navigation logic on init)
    Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: Image.asset('assets/animations/splash_screen.gif'),
      ),
    );
  }
}
