import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/authentication_controller.dart';
import 'package:tag_tweaker/controllers/navigation_controller.dart';
import 'package:tag_tweaker/controllers/product_controller.dart';
import 'package:tag_tweaker/services/google_sign_in_service.dart';
import 'package:tag_tweaker/pages/splash_screen.dart';
import 'package:tag_tweaker/themes/dark_theme.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );

  // Initialize Google Sign-In service (v7.2.0+)
  // serverClientId is required on Android - this is the Web Client ID from Firebase Console
  await GoogleSignInService.instance.initialize(
    serverClientId: '768847026435-1fapgf0eqqle6vds1sp4tjpi8ljibd31.apps.googleusercontent.com',
  );

  // Initialize GetX controllers
  Get.put(AuthenticationController());
  Get.put(NavigationController());
  Get.put(ProductController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tag Tweaker",
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      home: const SplashScreen(),
    );
  }
}
