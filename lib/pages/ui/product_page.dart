import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';
import 'package:tag_tweaker/widgets/functions/share_individual.dart';
import 'package:tag_tweaker/widgets/grid_painter.dart';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductPage({super.key, required this.product});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageCarousel(context),
                        const SizedBox(height: 32),
                        _buildProductDetails(),
                        const SizedBox(height: 32),
                        _buildActionButtons(context),
                        const SizedBox(height: 32),
                        _buildSpecsSheet(),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  width: 48,
                  height: 48,
                  decoration: NeoBrutalTheme.brutalBox(
                    color: NeoBrutalColors.white,
                    borderColor: NeoBrutalColors.black,
                    shadowColor: NeoBrutalColors.lime,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: NeoBrutalColors.black,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PRODUCT",
                    style: NeoBrutalTheme.heading.copyWith(
                      fontSize: 16,
                      height: 1,
                      color: NeoBrutalColors.white,
                    ),
                  ),
                  Text(
                    "DETAILS",
                    style: NeoBrutalTheme.heading.copyWith(
                      fontSize: 16,
                      height: 1,
                      color: NeoBrutalColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Transform.rotate(
            angle: -0.035, // approx -2 deg
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: NeoBrutalTheme.brutalBox(
                color: NeoBrutalColors.lime,
                borderColor: NeoBrutalColors.black,
                shadowColor: NeoBrutalColors.white,
              ),
              child: Text(
                product['brand']?.toString().toUpperCase() ?? 'BRAND',
                style: NeoBrutalTheme.mono.copyWith(
                  color: NeoBrutalColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    final List<dynamic> images = product['images'] ?? [product['thumbnail']];

    return Container(
      width: double.infinity,
      // Maintain aspect ratio 4/5 roughly
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
          // Dashed Lines Decoration
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: _DashedLine(vertical: true),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: _DashedLine(vertical: true),
          ),
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: _DashedLine(vertical: false),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: _DashedLine(vertical: false),
          ),

          // Carousel
          Center(
            child: CarouselSlider(
              items: images.map((img) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: CustomNetworkImage(
                    img.toString(),
                    fit: BoxFit.contain,
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

          // Scale/Dimension Badge
          Positioned(
            top: 24,
            right: 24,
            child: Transform.rotate(
              angle: 0.05, // 3 deg
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: NeoBrutalTheme.brutalBox(
                  color: NeoBrutalColors.white,
                  borderColor: NeoBrutalColors.black,
                  shadowColor: NeoBrutalColors.black,
                  shadowOffset: 6,
                ),
                child: Text(
                  "17.23 cm", // Hardcoded per HTML or dynamic if available
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
    );
  }

  Widget _buildProductDetails() {
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
                  product['title']?.toString().toUpperCase() ?? 'PRODUCT TITLE',
                  style: NeoBrutalTheme.heading.copyWith(
                    fontSize: 32,
                    height: 1,
                    color: NeoBrutalColors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Transform.rotate(
                angle: -0.035, // -2 deg
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
                        "${product['rating'] ?? 4.7}",
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
                  color: Color(0xFFD1D5DB), // Gray 300
                  width: 4,
                  style: BorderStyle
                      .solid, // Flutter doesn't limit dash easily here
                ),
                // Note: Dashed line typically needs custom painter, using solid for simplicity or custom below
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
                      "₹${product['price']}",
                      style: NeoBrutalTheme.mono.copyWith(
                        color: NeoBrutalColors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "₹${(product['price'] * 1.2).toStringAsFixed(0)}", // Mock original price
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 0,
                  ),
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NeoButton(
            icon: Icons.favorite,
            label: "SAVE",
            bgColor: NeoBrutalColors.background,
            textColor: NeoBrutalColors.white,
            shadowColor: NeoBrutalColors.lime,
            hoverColor: NeoBrutalColors.lime,
            onTap: () => _addToFavourites(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _NeoButton(
            icon: Icons.share,
            label: "SHARE",
            bgColor: NeoBrutalColors.white,
            textColor: NeoBrutalColors.black,
            shadowColor: NeoBrutalColors.black,
            hoverColor: Colors.grey.shade100,
            onTap: () => genPDF(context, product),
          ),
        ),
      ],
    );
  }

  Future<void> _addToFavourites(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to save favourites')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(product['id'].toString())
          .set(product); // Assuming product map is compatible

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ADDED TO FAVOURITES',
              style: NeoBrutalTheme.mono.copyWith(color: NeoBrutalColors.white),
            ),
            backgroundColor: NeoBrutalColors.black,
            shape: const RoundedRectangleBorder(),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving favourite: $e')));
      }
    }
  }

  Widget _buildSpecsSheet() {
    return Container(
      decoration: NeoBrutalTheme.brutalBox(
        color: NeoBrutalColors.lime,
        borderColor: NeoBrutalColors.white,
        shadowColor: NeoBrutalColors.white,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: NeoBrutalColors.black, width: 4),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: NeoBrutalColors.black,
                    border: Border.all(color: NeoBrutalColors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: NeoBrutalColors.lime,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "SPECS SHEET",
                  style: NeoBrutalTheme.heading.copyWith(
                    color: NeoBrutalColors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // Description
          const SizedBox(height: 16),
          Text(
            product['description'] ?? '',
            style: NeoBrutalTheme.mono.copyWith(
              color: NeoBrutalColors.black,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NeoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color textColor;
  final Color shadowColor;
  final Color hoverColor;

  const _NeoButton({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.shadowColor,
    required this.hoverColor,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64, // roughly matching py-4
        decoration: NeoBrutalTheme.brutalBox(
          color: bgColor,
          borderColor: NeoBrutalColors.black,
          shadowColor: shadowColor,
          shadowOffset: 6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: NeoBrutalTheme.heading.copyWith(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  final bool vertical;

  const _DashedLine({required this.vertical});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double size = vertical
            ? constraints.maxHeight
            : constraints.maxWidth;
        const double dashWidth = 5;
        const double dashSpace = 5;
        final int dashCount = (size / (dashWidth + dashSpace)).floor();

        return Flex(
          direction: vertical ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: vertical ? 1 : dashWidth,
              height: vertical ? dashWidth : 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
              ),
            );
          }),
        );
      },
    );
  }
}
