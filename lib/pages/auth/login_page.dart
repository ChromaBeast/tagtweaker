import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/authentication_controller.dart';
import '../../themes/neo_brutal_theme.dart';
import '../../widgets/neo_brutal_button.dart';
import '../../widgets/or_divider.dart';
import '../ui/ui_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authCtrl =
        Get.find<AuthenticationController>();

    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Center(
        child: Obx(() {
          if (authCtrl.isLoading.value) {
            return const CircularProgressIndicator(
              color: NeoBrutalColors.lime,
              backgroundColor: NeoBrutalColors.darkGrey,
            );
          }

          if (authCtrl.user.value != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAll(() => UIPage(selectedIndex: 0));
            });
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeroAnimation(context),
                  const SizedBox(height: 40),
                  _buildLoginSection(authCtrl),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeroAnimation(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      decoration: NeoBrutalTheme.brutalBox(
        color: NeoBrutalColors.white,
        shadowColor: NeoBrutalColors.lime,
        borderColor: NeoBrutalColors.black,
      ),
      child: ClipRect(
        child: Image.asset(
          'assets/animations/animation.gif',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildLoginSection(AuthenticationController authCtrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: NeoBrutalTheme.brutalBox(
        color: NeoBrutalColors.darkGrey,
        borderColor: NeoBrutalColors.white,
        shadowColor: NeoBrutalColors.purple,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'WELCOME BACK',
            textAlign: TextAlign.center,
            style: NeoBrutalTheme.heading.copyWith(
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to access your dashboard',
            textAlign: TextAlign.center,
            style: NeoBrutalTheme.body.copyWith(
              fontSize: 14,
              color: NeoBrutalColors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          NeoBrutalButton(
            onTap: authCtrl.signInWithGoogle,
            text: 'Sign in with Google',
            icon: 'assets/images/google.webp',
            isAssetIcon: true,
            bgColor: NeoBrutalColors.white,
            textColor: NeoBrutalColors.black,
            shadowColor: NeoBrutalColors.lime,
          ),
          const SizedBox(height: 16),
          const OrDivider(),
          const SizedBox(height: 16),
          NeoBrutalButton(
            onTap: authCtrl.signInAnonymously,
            text: 'Continue as Guest',
            iconData: Icons.person_outline_rounded,
            bgColor: NeoBrutalColors.lime,
            textColor: NeoBrutalColors.black,
            shadowColor: NeoBrutalColors.white,
          ),
        ],
      ),
    );
  }
}
