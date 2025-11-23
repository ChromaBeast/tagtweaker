import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/authentication_controller.dart';
import 'package:tag_tweaker/pages/ui/ui_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authCtrl =
        Get.find<AuthenticationController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Obx(() {
          if (authCtrl.isLoading.value) {
            return CircularProgressIndicator(
              color: colorScheme.primary,
            );
          }

          if (authCtrl.user.value != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAll(() => UIPage(selectedIndex: 0));
            });
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              // Hero animation section
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  image: const DecorationImage(
                    image: AssetImage('assets/animations/animation.gif'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Bottom login card with M3 styling
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign in to Tag Tweaker',
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildGoogleSignInButton(authCtrl, colorScheme),
                          const SizedBox(width: 24),
                          Text(
                            'or',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 24),
                          _buildAnonymousSignInButton(authCtrl, colorScheme),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildGoogleSignInButton(
      AuthenticationController ctrl, ColorScheme colorScheme) {
    return Material(
      elevation: 2,
      shape: const CircleBorder(),
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      child: InkWell(
        onTap: ctrl.signInWithGoogle,
        customBorder: const CircleBorder(),
        splashColor: colorScheme.primary.withOpacity(0.12),
        highlightColor: colorScheme.primary.withOpacity(0.08),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Image.asset('assets/images/google.png', height: 32),
        ),
      ),
    );
  }

  Widget _buildAnonymousSignInButton(
      AuthenticationController ctrl, ColorScheme colorScheme) {
    return Material(
      elevation: 2,
      shape: const CircleBorder(),
      color: colorScheme.primaryContainer,
      child: InkWell(
        onTap: ctrl.signInAnonymously,
        customBorder: const CircleBorder(),
        splashColor: colorScheme.primary.withOpacity(0.12),
        highlightColor: colorScheme.primary.withOpacity(0.08),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.person_outline_rounded,
            size: 32,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
