import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/app/controllers/authentication_controller.dart';
import 'package:tag_tweaker/pages/ui/ui_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authCtrl =
        Get.find<AuthenticationController>();

    return Scaffold(
      body: Center(
        child: Obx(() {
          if (authCtrl.user.value != null) {
            // User is authenticated, navigate to UIPage
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAll(() => UIPage(selectedIndex: 0));
            });
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: AssetImage('assets/animations/animation.gif'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(color: Colors.black),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.grey[900],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Sign in to Tag Tweaker using',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildGoogleSignInButton(authCtrl),
                        const Text('or',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        _buildAnonymousSignInButton(authCtrl),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildGoogleSignInButton(AuthenticationController ctrl) {
    return InkWell(
      onTap: ctrl.signInWithGoogle,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Image.asset('assets/images/google.png', height: 30),
      ),
    );
  }

  Widget _buildAnonymousSignInButton(AuthenticationController ctrl) {
    return InkWell(
      onTap: ctrl.signInAnonymously,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Image.asset('assets/images/guest.png',
            height: 30, color: Colors.black),
      ),
    );
  }
}
