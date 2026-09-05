import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../themes/neo_brutal_theme.dart';
import '../custom_network_image.dart';
import 'dashed_line.dart';

/// Reusable Neo-Brutal image carousel with canvas-rendered dashed lines
class ProductImageCarousel extends StatelessWidget {
  final Product product;

  const ProductImageCarousel({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> images =
        product.images.isNotEmpty ? product.images : [product.thumbnail];

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width * 1.25,
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        border: Border.all(color: NeoBrutalColors.white, width: 4),
        boxShadow: const [
          BoxShadow(color: NeoBrutalColors.lime, offset: Offset(6, 6)),
        ],
      ),
      child: Stack(
        children: [
          // Canvas-based dashed lines
          const Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: DashedLine(vertical: true),
          ),
          const Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: DashedLine(vertical: true),
          ),
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: DashedLine(vertical: false),
          ),
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: DashedLine(vertical: false),
          ),

          // Carousel Slider
          Center(
            child: CarouselSlider(
              items: images.map((img) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: CustomNetworkImage(
                    img.toString(),
                    fit: BoxFit.contain,
                    loadingWidget: const SizedBox.shrink(),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                aspectRatio: 4 / 5,
                viewportFraction: 1.0,
                enableInfiniteScroll: images.length > 1,
                autoPlay: images.length > 1,
                autoPlayAnimationDuration: const Duration(seconds: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
