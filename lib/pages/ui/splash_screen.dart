import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tag_tweaker/pages/ui/ui_screen.dart';

import '../auth/login_page.dart';

// make splash screen which redirects to the UIPage after a delay

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirebaseAuth.instance.currentUser == null
              ? const LoginPage()
              : const UIPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        'assets/animations/splash_animation.json',
        animate: true,
        frameRate: FrameRate.max,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
