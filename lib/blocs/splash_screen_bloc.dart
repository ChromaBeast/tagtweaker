import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tag_tweaker/pages/auth/login_page.dart';
import 'package:tag_tweaker/pages/ui/ui_screen.dart';

import '../models/product_model.dart';

// Events
abstract class SplashScreenEvent {}

class SplashScreenStarted extends SplashScreenEvent {}

// States
class SplashScreenState {}

class SplashScreenLoading extends SplashScreenState {}

class SplashScreenComplete extends SplashScreenState {
  final Widget destination;
  SplashScreenComplete({required this.destination});
}

// BLoC
class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenState()) {
    on<SplashScreenStarted>((event, emit) async {
      Product product = Product();
      product.fetchProducts();
      emit(SplashScreenLoading());
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      await Future.delayed(const Duration(seconds: 3));
      if (isLoggedIn) {
        emit(SplashScreenComplete(destination: UIPage(selectedIndex: 0)));
      } else {
        emit(SplashScreenComplete(destination: const LoginPage()));
      }
    });
  }
}
