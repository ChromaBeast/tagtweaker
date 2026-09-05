import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/favourites_controller.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/widgets/common/app_background.dart';
import 'package:tag_tweaker/widgets/functions/share_individual.dart';
import 'package:tag_tweaker/widgets/product/neo_action_button.dart';
import 'package:tag_tweaker/widgets/product/product_details_card.dart';
import 'package:tag_tweaker/widgets/product/product_image_carousel.dart';
import 'package:tag_tweaker/widgets/product/product_specs_sheet.dart';

/// Product detail view displaying gallery, pricing, specs, and actions
class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final FavouritesController favController = Get.find<FavouritesController>();

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
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductImageCarousel(product: product),
                        const SizedBox(height: 32),
                        ProductDetailsCard(product: product),
                        const SizedBox(height: 32),
                        _buildActionButtons(context, favController),
                        const SizedBox(height: 32),
                        ProductSpecsSheet(description: product.description),
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
            angle: -0.035,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: NeoBrutalTheme.brutalBox(
                color: NeoBrutalColors.lime,
                borderColor: NeoBrutalColors.black,
                shadowColor: NeoBrutalColors.white,
              ),
              child: Text(
                product.brand.toUpperCase(),
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

  Widget _buildActionButtons(
    BuildContext context,
    FavouritesController favController,
  ) {
    return Obx(() {
      final isSaved = favController.isFavourite(product.id);
      return Row(
        children: [
          Expanded(
            child: NeoActionButton(
              icon: isSaved ? Icons.favorite : Icons.favorite_border,
              label: isSaved ? "SAVED" : "SAVE",
              bgColor: isSaved ? NeoBrutalColors.lime : NeoBrutalColors.background,
              textColor: isSaved ? NeoBrutalColors.black : NeoBrutalColors.white,
              shadowColor: NeoBrutalColors.lime,
              onTap: () => favController.toggleFavourite(product),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: NeoActionButton(
              icon: Icons.share,
              label: "SHARE",
              bgColor: NeoBrutalColors.white,
              textColor: NeoBrutalColors.black,
              shadowColor: NeoBrutalColors.black,
              onTap: () => genPDF(context, product),
            ),
          ),
        ],
      );
    });
  }
}
