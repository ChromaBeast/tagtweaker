import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/splash_screen_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashScreenBloc()..add(SplashScreenStarted()),
      child: BlocListener<SplashScreenBloc, SplashScreenState>(
          listener: (context, state) {
            if (state is SplashScreenComplete) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => state.destination),
              );
            }
          },
          child: Center(
            child: Image.asset('assets/animations/splash_screen.gif'),
          )),
    );
  }
}
