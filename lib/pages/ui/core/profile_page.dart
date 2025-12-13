import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/profile_controller.dart';
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
                  Obx(() => ProfileIDCard(
                    user: controller.currentUser.value,
                    onEdit: controller.updateProfilePicture,
                    isLoading: controller.isLoading.value,
                  )),

                  const SizedBox(height: 48),

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
                          const Icon(Icons.logout, color: NeoBrutalColors.black),
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
