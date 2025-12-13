import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/authentication_controller.dart';
import '../../themes/neo_brutal_theme.dart';
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
                  // Hero animation section
                  Container(
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
                  ),

                  const SizedBox(height: 40),

                  // Login Section
                  Container(
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
                            color: NeoBrutalColors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Google Sign In
                        _buildNeoBrutalButton(
                          onTap: authCtrl.signInWithGoogle,
                          text: 'Sign in with Google',
                          icon: 'assets/images/google.png',
                          isAssetIcon: true,
                          bgColor: NeoBrutalColors.white,
                          textColor: NeoBrutalColors.black,
                          shadowColor: NeoBrutalColors.lime,
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: NeoBrutalColors.white,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: NeoBrutalTheme.mono.copyWith(
                                  color: NeoBrutalColors.white,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: NeoBrutalColors.white,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Anonymous Sign In
                        _buildNeoBrutalButton(
                          onTap: authCtrl.signInAnonymously,
                          text: 'Continue as Guest',
                          iconData: Icons.person_outline_rounded,
                          bgColor: NeoBrutalColors.lime,
                          textColor: NeoBrutalColors.black,
                          shadowColor: NeoBrutalColors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNeoBrutalButton({
    required VoidCallback onTap,
    required String text,
    String? icon,
    IconData? iconData,
    bool isAssetIcon = false,
    required Color bgColor,
    required Color textColor,
    Color shadowColor = NeoBrutalColors.black,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: NeoBrutalTheme.brutalBox(
          color: bgColor,
          borderColor: NeoBrutalColors.black, // Always black border for buttons
          shadowColor: shadowColor,
          shadowOffset: 4,
          borderWidth: 2, // Thinner border for buttons
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isAssetIcon && icon != null)
              Image.asset(icon, height: 24)
            else if (iconData != null)
              Icon(iconData, color: textColor, size: 24),
            
            if (icon != null || iconData != null)
              const SizedBox(width: 12),
            
            Text(
              text.toUpperCase(),
              style: NeoBrutalTheme.heading.copyWith(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
