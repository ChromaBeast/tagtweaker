import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isNew;
  final bool isBestSeller;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.isNew = false,
    this.isBestSeller = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Get.to(() => ProductPage(product: product));
          },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: NeoBrutalTheme.brutalBox(
              color: NeoBrutalColors.darkGrey,
              shadowColor: NeoBrutalColors.lime,
              shadowOffset: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: NeoBrutalColors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: NeoBrutalColors.white,
                          width: 4,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: CustomNetworkImage(
                      product['thumbnail'] ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Details
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['title'] ?? 'Unknown',
                          style: NeoBrutalTheme.heading.copyWith(
                            fontSize: 16,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (product['category'] ?? '').toString().toUpperCase(),
                          style: NeoBrutalTheme.mono.copyWith(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.only(top: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: NeoBrutalColors.mediumGrey,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: NeoBrutalColors.lime,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${product['rating'] ?? 0.0}",
                                    style: NeoBrutalTheme.heading.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                color: NeoBrutalColors.mediumGrey,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Text(
                                  "BY ${product['brand'].toString().toUpperCase()}",
                                  style: NeoBrutalTheme.heading.copyWith(
                                    fontSize: 8,
                                    color: NeoBrutalColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isBestSeller)
            Positioned(
              top: -8,
              right: -8,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: NeoBrutalColors.lime,
                    border: Border.all(color: NeoBrutalColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: NeoBrutalColors.white,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "BEST SELLER",
                    style: NeoBrutalTheme.heading.copyWith(
                      color: NeoBrutalColors.black,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          if (isNew)
            Positioned(
              top: -8,
              left: -8,
              child: Transform.rotate(
                angle: -0.05,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: NeoBrutalColors.white,
                    border: Border.all(color: NeoBrutalColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: NeoBrutalColors.lime,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "NEW",
                    style: NeoBrutalTheme.heading.copyWith(
                      color: NeoBrutalColors.black,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}