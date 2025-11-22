import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/app/controllers/authentication_controller.dart';
import 'package:tag_tweaker/app/controllers/product_controller.dart';
import '../../../widgets/homepage/category_row_4.dart';
import '../../../widgets/homepage/circular_row_1.dart';
import '../../../widgets/homepage/corousel_2.dart';
import '../../../widgets/homepage/custom_home_page_shimmer.dart';
import '../../../widgets/homepage/image_banner_3.dart';
import '../../auth/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final AuthenticationController authController =
        Get.find<AuthenticationController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 2,
        automaticallyImplyLeading: false,
        title: Text(
          'Tag Tweaker',
          style: textTheme.headlineSmall?.copyWith(
            fontFamily: 'Lobster',
            color: colorScheme.primary,
          ),
        ),
        centerTitle: false,
        actions: [
          Obx(() {
            final user = authController.user.value;
            if (user == null) {
              return FilledButton.tonal(
                onPressed: () {
                  Get.to(() => const LoginPage());
                },
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.login_rounded,
                      size: 18,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sign In',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      user.photoURL ??
                          'https://img.freepik.com/free-vector/user-circles-set_78370-4704.jpg?w=740&t=st=1719513439~exp=1719514039~hmac=5efd9918b6b74e119a89b55650072b39f6e2a284debb52d862b8f6b0f3dafec4',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.logout_rounded,
                    color: colorScheme.error,
                  ),
                  onPressed: () async {
                    await authController.signOut();
                    Get.offAll(() => const LoginPage());
                  },
                  tooltip: 'Sign Out',
                ),
              ],
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CustomHomePageShimmer();
        } else if (controller.products.isNotEmpty) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 8),
                circularRow(context),
                const SizedBox(height: 16),
                carouselSlider(context),
                const SizedBox(height: 16),
                imageBanner(context),
                const SizedBox(height: 16),
                categoryRow("Trending", "Now", context),
                const SizedBox(height: 16),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading products',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
