import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/services/product_repository.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/common/app_background.dart';
import 'package:tag_tweaker/widgets/neo_brutal_search_bar.dart';
import 'package:tag_tweaker/widgets/product_card.dart';

/// Category page displaying filtered catalog items
class CategoryPage extends StatefulWidget {
  final String category;
  final String text;

  const CategoryPage({super.key, required this.category, required this.text});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Product>> _productsFuture;
  final ProductRepository _repository = Get.find<ProductRepository>();

  @override
  void initState() {
    super.initState();
    _productsFuture = _repository.fetchProductsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoBrutalColors.background,
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                final categoryList = snapshot.data ?? [];
                final isLoading =
                    snapshot.connectionState == ConnectionState.waiting;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(context, categoryList.length, isLoading),
                      const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: NeoBrutalSearchBar(
                          hintText: 'FILTER MODELS...',
                          isRotated: true,
                        ),
                      ),
                      if (isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(48.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        _buildProductGrid(categoryList),
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildFilterFab(),
        ],
      ),
    );
  }

  Widget _buildFilterFab() {
    return Positioned(
      bottom: 96,
      right: 24,
      child: Container(
        width: 64,
        height: 64,
        decoration: NeoBrutalTheme.brutalBox(
          color: NeoBrutalColors.lime,
          shadowColor: NeoBrutalColors.white,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: const Center(
              child: Icon(
                Icons.filter_list,
                color: NeoBrutalColors.black,
                size: 36,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int itemCount, bool isLoading) {
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
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: NeoBrutalTheme.brutalBox(
                    color: NeoBrutalColors.lime,
                    borderColor: NeoBrutalColors.white,
                    borderWidth: 2,
                    shadowOffset: 0,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: NeoBrutalColors.black,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text.toUpperCase(),
                    style: NeoBrutalTheme.heading.copyWith(
                      fontSize: 32,
                      shadows: const [
                        Shadow(
                          offset: Offset(2, 2),
                          color: NeoBrutalColors.lime,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLoading
                        ? "CATEGORY // LOADING..."
                        : "CATEGORY // $itemCount ITEMS",
                    style: NeoBrutalTheme.mono.copyWith(
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Product> categoryList) {
    if (categoryList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.60,
      ),
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        final product = categoryList[index];
        return ProductCard(
          product: product,
          isNew: product.isNew,
          isBestSeller: index == 0,
        );
      },
    );
  }
}
