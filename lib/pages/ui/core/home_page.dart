import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/authentication_controller.dart';
import 'package:tag_tweaker/controllers/product_controller.dart';
import 'package:tag_tweaker/pages/ui/category_page.dart';
import 'package:tag_tweaker/services/product_repository.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';
import 'package:tag_tweaker/widgets/grid_painter.dart';
import 'package:tag_tweaker/widgets/homepage/corousel_2.dart';
import 'package:tag_tweaker/widgets/neo_brutal_search_bar.dart';
import 'package:tag_tweaker/widgets/product_card.dart';
import 'package:tag_tweaker/pages/ui/core/profile_page.dart';
import 'package:tag_tweaker/models/product_model.dart';
import '../../auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  // Search state
  final RxBool _isSearching = false.obs;
  final RxBool _isSearchMode = false.obs; // Tracks if search text is present
  final RxList<Product> _searchResults = <Product>[].obs;

  // Trending products state
  late Future<List<Product>> _trendingProductsFuture;

  final ProductRepository _repository = Get.find<ProductRepository>();

  @override
  void initState() {
    super.initState();
    _loadTrendingProducts();
  }

  void _loadTrendingProducts() {
    _trendingProductsFuture = _repository.fetchTrendingProducts(limit: 6).then((
      trendingProducts,
    ) async {
      // Fallback to top-rated if no trending products
      if (trendingProducts.isEmpty) {
        return await _repository.fetchTopRatedProducts(limit: 6);
      }
      return trendingProducts;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

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
                  Obx(() {
                    if (_isSearchMode.value) {
                      return _buildSearchResults();
                    }
                    return Column(
                      children: [
                        _buildCategoriesRow(),
                        const SizedBox(height: 32),
                        const NeoBrutalCarousel(),
                        const SizedBox(height: 32),
                        const SizedBox(height: 32),
                        _buildInventoryHeader(controller),
                        const SizedBox(height: 32),
                        _buildTrendingProductsGrid(),
                      ],
                    );
                  }),
                  const SizedBox(height: 100), // Spacing for bottom nav
                ],
              ),
            ),
          ),
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
                  '${controller.productCount.value} PRODUCTS AVAILABLE',
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
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () async {
            if (value.isEmpty) {
              _searchResults.clear();
              _isSearching.value = false;
              _isSearchMode.value = false;
            } else {
              _isSearchMode.value = true;
              _isSearching.value = true;
              final results = await _repository.searchProducts(value);
              _searchResults.assignAll(results);
              _isSearching.value = false;
            }
          });
        },
        hintText: 'SEARCH_PRODUCTS...',
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Obx(() {
        if (_isSearching.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_searchResults.isEmpty) {
          return Center(
            child: Text(
              "NO PRODUCTS FOUND",
              style: NeoBrutalTheme.heading.copyWith(
                color: NeoBrutalColors.white,
              ),
            ),
          );
        }
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.60,
          ),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final product = _searchResults[index];
            return ProductCard(product: product);
          },
        );
      }),
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
                    "${controller.productCount.value} ITEMS",
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
              // Navigate to CategoryPage with just the category name
              // CategoryPage will fetch products dynamically
              Get.to(() => CategoryPage(category: category, text: category));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 140,
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

  Widget _buildTrendingProductsGrid() {
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
        FutureBuilder<List<Product>>(
          future: _trendingProductsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final displayProducts = snapshot.data ?? [];

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
                return ProductCard(product: product, isNew: product.isNew);
              },
            );
          },
        ),
      ],
    );
  }
}
