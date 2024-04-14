import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tag_tweaker/pages/ui/splash_screen.dart';
import 'package:tag_tweaker/themes/dark_theme.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tag Tweaker",
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      home: const SplashScreen(),
    );
  }
}
