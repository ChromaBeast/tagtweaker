import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/authentication_controller.dart';
import '../../controllers/product_controller.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/ui/core/profile_page.dart';
import '../../themes/neo_brutal_theme.dart';
import '../custom_network_image.dart';

/// Reusable Neo-Brutal app bar for the home screen
class HomeAppBar extends StatelessWidget {
  final ProductController productController;
  final AuthenticationController authController;

  const HomeAppBar({
    super.key,
    required this.productController,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: NeoBrutalColors.background,
        border: Border(
          bottom: BorderSide(color: NeoBrutalColors.white, width: 4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TAG\nTWEAKER',
                style: NeoBrutalTheme.heading.copyWith(
                  fontSize: 32,
                  shadows: const [
                    Shadow(offset: Offset(2, 2), color: NeoBrutalColors.lime),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  '${productController.productCount.value} PRODUCTS AVAILABLE',
                  style: NeoBrutalTheme.mono.copyWith(
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (authController.user.value == null) {
                Get.to(() => const LoginPage());
              } else {
                Get.to(() => const ProfilePage());
              }
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: NeoBrutalTheme.brutalBox(
                    color: NeoBrutalColors.purple,
                    borderWidth: 2,
                    shadowColor: NeoBrutalColors.white,
                    shadowOffset: 4,
                  ),
                  child: Obx(() {
                    final user = authController.user.value;
                    if (user?.photoURL != null) {
                      return CustomNetworkImage(
                        user!.photoURL!,
                        fit: BoxFit.cover,
                        errorWidget: Container(color: Colors.purple),
                      );
                    }
                    return const Icon(Icons.person, color: Colors.white);
                  }),
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: NeoBrutalColors.lime,
                      border: Border.all(color: NeoBrutalColors.black, width: 2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
