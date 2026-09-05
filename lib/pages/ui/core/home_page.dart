import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/authentication_controller.dart';
import 'package:tag_tweaker/controllers/product_controller.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/services/product_repository.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/common/app_background.dart';
import 'package:tag_tweaker/widgets/homepage/corousel_2.dart';
import 'package:tag_tweaker/widgets/homepage/home_app_bar.dart';
import 'package:tag_tweaker/widgets/homepage/home_categories_row.dart';
import 'package:tag_tweaker/widgets/homepage/home_inventory_banner.dart';
import 'package:tag_tweaker/widgets/homepage/home_trending_grid.dart';
import 'package:tag_tweaker/widgets/neo_brutal_search_bar.dart';
import 'package:tag_tweaker/widgets/product_card.dart';

/// Main home catalog page with pre-warmed sections and instant cached rendering
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  // Search state
  final RxBool _isSearching = false.obs;
  final RxBool _isSearchMode = false.obs;
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

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final query = value.trim();
      if (query.isEmpty) {
        _searchResults.clear();
        _isSearching.value = false;
        _isSearchMode.value = false;
      } else {
        _isSearchMode.value = true;
        _isSearching.value = true;
        final results = await _repository.searchProducts(query);
        _searchResults.assignAll(results);
        _isSearching.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final AuthenticationController authController =
        Get.find<AuthenticationController>();

    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeAppBar(
                    productController: controller,
                    authController: authController,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: NeoBrutalSearchBar(
                      controller: searchController,
                      onChanged: _onSearchChanged,
                      hintText: 'SEARCH PRODUCTS...',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    if (_isSearchMode.value) {
                      return _buildSearchResults();
                    }
                    return Column(
                      children: [
                        const HomeCategoriesRow(),
                        const SizedBox(height: 32),
                        const NeoBrutalCarousel(),
                        const SizedBox(height: 32),
                        HomeInventoryBanner(productController: controller),
                        const SizedBox(height: 32),
                        HomeTrendingGrid(
                          trendingProductsFuture: _trendingProductsFuture,
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Obx(() {
        if (_isSearching.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (_searchResults.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "NO PRODUCTS FOUND",
                style: NeoBrutalTheme.heading.copyWith(
                  color: NeoBrutalColors.white,
                ),
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
}
