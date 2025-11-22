import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/app/controllers/authentication_controller.dart';
import 'package:tag_tweaker/app/controllers/navigation_controller.dart';
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
  // Initialize GetX controllers
  Get.put(AuthenticationController());
  Get.put(NavigationController());
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
