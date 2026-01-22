import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';
import 'package:tag_tweaker/services/product_repository.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';
import 'package:tag_tweaker/models/product_model.dart';

class NeoBrutalCarousel extends StatefulWidget {
  const NeoBrutalCarousel({super.key});

  @override
  State<NeoBrutalCarousel> createState() => _NeoBrutalCarouselState();
}

class _NeoBrutalCarouselState extends State<NeoBrutalCarousel> {
  late Future<List<Product>> _carouselProductsFuture;

  @override
  void initState() {
    super.initState();
    _carouselProductsFuture = Get.find<ProductRepository>()
        .fetchCarouselProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _carouselProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final carouselProducts = snapshot.data ?? [];

        if (carouselProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        return CarouselSlider(
          items: carouselProducts.map((product) {
            return _buildCarouselItem(product);
          }).toList(),
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            height: 220,
            aspectRatio: 16 / 9,
            viewportFraction: 0.9,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }

  Widget _buildCarouselItem(Product product) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductPage(product: product));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: NeoBrutalTheme.brutalBox(
                color: NeoBrutalColors.white,
                borderColor: NeoBrutalColors.black,
                shadowColor: NeoBrutalColors.lime,
                shadowOffset: 6,
              ),
              child: ClipRRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomNetworkImage(product.thumbnail, fit: BoxFit.cover),
                    // Gradient layer for text legibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            color: NeoBrutalColors.lime,
                            child: Text(
                              product.title.toUpperCase(),
                              style: NeoBrutalTheme.heading.copyWith(
                                color: NeoBrutalColors.black,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // "FEATURED" Badge
            Positioned(
              top: -6,
              right: -6,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: NeoBrutalColors.lime,
                    border: Border.all(color: NeoBrutalColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: NeoBrutalColors.black,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "FEATURED",
                    style: NeoBrutalTheme.heading.copyWith(
                      color: NeoBrutalColors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
