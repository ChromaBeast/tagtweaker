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
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        forceMaterialTransparency: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Tag Tweaker',
          style: TextStyle(fontFamily: 'Lobster'),
        ),
        actions: [
          Obx(() {
            final user = authController.user.value;
            if (user == null) {
              return IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Get.to(() => const LoginPage());
                },
              );
            }
            return Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.photoURL ??
                        'https://img.freepik.com/free-vector/user-circles-set_78370-4704.jpg?w=740&t=st=1719513439~exp=1719514039~hmac=5efd9918b6b74e119a89b55650072b39f6e2a284debb52d862b8f6b0f3dafec4',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await authController.signOut();
                    Get.offAll(() => const LoginPage());
                  },
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CustomHomePageShimmer();
        } else if (controller.products.isNotEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                circularRow(context),
                const SizedBox(height: 10),
                carouselSlider(context),
                const SizedBox(height: 10),
                imageBanner(),
                const SizedBox(height: 10),
                categoryRow("Trending", "Now", context),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Error loading products'));
        }
      }),
    );
  }
}
