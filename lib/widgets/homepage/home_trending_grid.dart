import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../themes/neo_brutal_theme.dart';
import '../product_card.dart';

/// Trending products section displaying header and grid of cards
class HomeTrendingGrid extends StatelessWidget {
  final Future<List<Product>> trendingProductsFuture;

  const HomeTrendingGrid({super.key, required this.trendingProductsFuture});

  @override
  Widget build(BuildContext context) {
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
              shadows: const [
                Shadow(
                  offset: Offset(2, 2),
                  color: NeoBrutalColors.black,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Product>>(
          future: trendingProductsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
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
