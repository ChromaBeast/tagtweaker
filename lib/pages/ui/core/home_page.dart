import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/authentication_controller.dart';
import 'package:tag_tweaker/controllers/product_controller.dart';
import 'package:tag_tweaker/pages/ui/category_page.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';
import 'package:tag_tweaker/widgets/grid_painter.dart';
import 'package:tag_tweaker/widgets/homepage/corousel_2.dart';
import 'package:tag_tweaker/widgets/neo_brutal_search_bar.dart';
import 'package:tag_tweaker/widgets/product_card.dart';
import '../../auth/login_page.dart';
import '../../../models/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  final Map<String, String> categoryImages = {
    'Smartphone': 'assets/categories/smartphone.png',
    'Laptop': 'assets/categories/laptop.png',
    'Controller': 'assets/categories/controller.png',
    'Audio': 'assets/categories/audio.png',
    'TV': 'assets/categories/tv.png',
    'Accessories': 'assets/categories/accessories.png',
  };

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final AuthenticationController authController =
        Get.find<AuthenticationController>();

    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Stack(
        children: [
          // Grid Pattern Background
          Container(
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

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(controller, authController),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildCategoriesRow(),
                  const SizedBox(height: 32),
                  const NeoBrutalCarousel(),
                  const SizedBox(height: 32),
                  const SizedBox(height: 32),
                  _buildInventoryHeader(controller),

                  const SizedBox(height: 32),
                  _buildTrendingProductsGrid(controller),
                  const SizedBox(height: 100), // Spacing for bottom nav
                ],
              ),
            ),
          ),

          // Bottom Nav Removed (Hosted in UIPage)
        ],
      ),
    );
  }

  Widget _buildAppBar(
    ProductController controller,
    AuthenticationController authController,
  ) {
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
                  shadows: [
                    const Shadow(
                      offset: Offset(2, 2),
                      color: NeoBrutalColors.lime,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  '${controller.products.length} PRODUCTS AVAILABLE',
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
                authController.signOut();
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
                      border: Border.all(
                        color: NeoBrutalColors.black,
                        width: 2,
                      ),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: NeoBrutalSearchBar(
        controller: searchController,
        hintText: 'SEARCH_PRODUCTS...',
      ),
    );
  }

  Widget _buildInventoryHeader(ProductController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Transform.rotate(
        angle: -0.02,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: NeoBrutalTheme.brutalBox(
            color: NeoBrutalColors.lime,
            borderColor: NeoBrutalColors.white,
            shadowColor: NeoBrutalColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "FULL INVENTORY",
                style: NeoBrutalTheme.heading.copyWith(
                  color: NeoBrutalColors.black,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: NeoBrutalColors.white,
                  border: Border.all(color: NeoBrutalColors.black, width: 2),
                ),
                child: Obx(
                  () => Text(
                    "${controller.products.length} ITEMS",
                    style: NeoBrutalTheme.mono.copyWith(
                      color: NeoBrutalColors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(Product.categories.length, (index) {
          final category = Product.categories[index];
          final imgUrl =
              categoryImages[category] ?? categoryImages.values.first;

          return GestureDetector(
            onTap: () {
              final controller = Get.find<ProductController>();
              final categoryProducts = controller.products
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .where((p) => p['category'] == category.toLowerCase())
                  .toList();

              Get.to(
                () => CategoryPage(
                  categoryList: categoryProducts,
                  category: category.toLowerCase(),
                  text: category,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 140, // Slightly wider to fit text
              decoration: NeoBrutalTheme.brutalBox(
                color: NeoBrutalColors.white,
                borderColor: NeoBrutalColors.black,
                shadowColor: NeoBrutalColors.black,
                shadowOffset: 4,
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset(imgUrl, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.toUpperCase(),
                    style: NeoBrutalTheme.heading.copyWith(
                      fontSize: 12,
                      color: NeoBrutalColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTrendingProductsGrid(ProductController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "TRENDING NOW",
            style: NeoBrutalTheme.heading.copyWith(
              fontSize: 24,
              color: NeoBrutalColors.lime,
              shadows: [
                const Shadow(
                  offset: Offset(2, 2),
                  color: NeoBrutalColors.black,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter for trending products
          // Assuming 'isTrending' field exists, otherwise use a fallback or first 6
          final allProducts = controller.products
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          final trendingProducts = allProducts
              .where((p) => p['isTrending'] == true)
              .toList();

          // Fallback if no trending products found (or field missing/false)
          final displayProducts = trendingProducts.isNotEmpty
              ? trendingProducts.take(6).toList()
              : allProducts.take(6).toList();

          if (displayProducts.isEmpty) {
            return const SizedBox.shrink();
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
              childAspectRatio: 0.60,
            ),
            itemCount: displayProducts.length,
            itemBuilder: (context, index) {
              final product = displayProducts[index];
              return ProductCard(
                product: product,
                isNew: product['isNew'] == true, // Optional: if data has it
              );
            },
          );
        }),
      ],
    );
  }
}
