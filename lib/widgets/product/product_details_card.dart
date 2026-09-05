import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../themes/neo_brutal_theme.dart';

/// Reusable Neo-Brutal card displaying product title, rating, and pricing
class ProductDetailsCard extends StatelessWidget {
  final Product product;

  const ProductDetailsCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: NeoBrutalTheme.brutalBox(
        color: NeoBrutalColors.white,
        borderColor: NeoBrutalColors.black,
        shadowColor: NeoBrutalColors.lime,
        shadowOffset: 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.title.toUpperCase(),
                  style: NeoBrutalTheme.heading.copyWith(
                    fontSize: 32,
                    height: 1,
                    color: NeoBrutalColors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Transform.rotate(
                angle: -0.035,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: NeoBrutalColors.black,
                    border: Border.all(color: NeoBrutalColors.black, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: NeoBrutalColors.lime,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${product.rating}",
                        style: NeoBrutalTheme.heading.copyWith(
                          color: NeoBrutalColors.lime,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Price Area
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFD1D5DB),
                  width: 4,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "₹${product.price.toStringAsFixed(0)}",
                      style: NeoBrutalTheme.mono.copyWith(
                        color: NeoBrutalColors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "₹${(product.price * 1.2).toStringAsFixed(0)}",
                      style: NeoBrutalTheme.mono.copyWith(
                        color: Colors.grey,
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red,
                        decorationThickness: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: NeoBrutalColors.lime,
                    border: Border.all(color: NeoBrutalColors.black, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  child: Text(
                    "INCLUSIVE OF ALL TAXES",
                    style: NeoBrutalTheme.mono.copyWith(
                      color: NeoBrutalColors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
