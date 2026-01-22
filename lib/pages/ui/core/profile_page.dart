import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/profile_controller.dart';
import 'package:tag_tweaker/controllers/authentication_controller.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';
import 'package:tag_tweaker/widgets/grid_painter.dart';
import 'package:tag_tweaker/widgets/profile_id_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://www.transparenttextures.com/patterns/carbon-fibre.png",
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: CustomPaint(painter: GridPainter(), child: Container()),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: NeoBrutalTheme.brutalBox(
                                color: NeoBrutalColors.white,
                                borderColor: NeoBrutalColors.black,
                                shadowColor: NeoBrutalColors.black,
                                shadowOffset: 4,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: NeoBrutalColors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'YOUR\nPROFILE',
                            style: NeoBrutalTheme.heading.copyWith(
                              fontSize: 24,
                              height: 0.9,
                              shadows: [
                                const Shadow(
                                  offset: Offset(2, 2),
                                  color: NeoBrutalColors.lime,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Profile Card
                  Obx(
                    () => ProfileIDCard(
                      user: controller.currentUser.value,
                      onEdit: controller.updateProfilePicture,
                      onNameEdit: () => controller.updateDisplayName(context),
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Upgrade Banner (only for guests)
                  Obx(() {
                    final authCtrl = Get.find<AuthenticationController>();
                    // Access reactive user.value to trigger Obx updates
                    final isAnonymous =
                        authCtrl.user.value?.isAnonymous ?? false;
                    if (!isAnonymous) return const SizedBox.shrink();

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: NeoBrutalTheme.brutalBox(
                        color: NeoBrutalColors.purple,
                        borderColor: NeoBrutalColors.white,
                        shadowColor: NeoBrutalColors.lime,
                        shadowOffset: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.upgrade_rounded,
                                color: NeoBrutalColors.white,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'UPGRADE YOUR ACCOUNT',
                                  style: NeoBrutalTheme.heading.copyWith(
                                    fontSize: 16,
                                    color: NeoBrutalColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Link your Google account to save your data and access it across devices.',
                            style: NeoBrutalTheme.body.copyWith(
                              fontSize: 13,
                              color: NeoBrutalColors.white.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: authCtrl.linkGoogleAccount,
                            child: Container(
                              height: 48,
                              decoration: NeoBrutalTheme.brutalBox(
                                color: NeoBrutalColors.white,
                                borderColor: NeoBrutalColors.black,
                                shadowColor: NeoBrutalColors.black,
                                shadowOffset: 4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/google.png',
                                    height: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'LINK WITH GOOGLE',
                                    style: NeoBrutalTheme.heading.copyWith(
                                      fontSize: 14,
                                      color: NeoBrutalColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Logout Button
                  GestureDetector(
                    onTap: () => controller.logout(context),
                    child: Container(
                      height: 64,
                      decoration: NeoBrutalTheme.brutalBox(
                        color: NeoBrutalColors.orange,
                        borderColor: NeoBrutalColors.black,
                        shadowColor: NeoBrutalColors.black,
                        shadowOffset: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout,
                            color: NeoBrutalColors.black,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'LOGOUT',
                            style: NeoBrutalTheme.heading.copyWith(
                              fontSize: 16,
                              color: NeoBrutalColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
