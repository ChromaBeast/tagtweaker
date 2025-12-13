import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/widgets/grid_painter.dart';
import 'package:tag_tweaker/widgets/neo_brutal_search_bar.dart';
import 'package:tag_tweaker/widgets/product_card.dart';

import '../../themes/neo_brutal_theme.dart';

class CategoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> categoryList;
  final String category, text;

  const CategoryPage({
    super.key,
    required this.categoryList,
    required this.category,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                children: [
                  _buildHeader(context),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildSearchBar(),
                  ),
                  _buildProductGrid(),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),

          // Filter FAB
          Positioned(
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
                // Material for ripple
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
          ),

          // Bottom Nav Removed (Hosted in UIPage)
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                    shadowOffset:
                        0, // No shadow for back button in this interaction per HTML feel, or simpler style
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
                    text.toUpperCase(),
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
                  Text(
                    "CATEGORY // ${categoryList.length} ITEMS",
                    style: NeoBrutalTheme.mono.copyWith(
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // User avatar removed as per request
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return const NeoBrutalSearchBar(
      hintText: 'FILTER MODELS...',
      isRotated: true,
    );
  }

  Widget _buildProductGrid() {
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
        final bool isNew = index == 2; // Mock "New" tag for 3rd item
        final bool isBestSeller = index == 0; // Mock "Best Seller" for 1st

        return ProductCard(
          product: product,
          isNew: isNew,
          isBestSeller: isBestSeller,
        );
      },
    );
  }
}
