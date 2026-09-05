import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../themes/neo_brutal_theme.dart';

/// Rotated Neo-Brutal inventory count banner
class HomeInventoryBanner extends StatelessWidget {
  final ProductController productController;

  const HomeInventoryBanner({super.key, required this.productController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Transform.rotate(
        angle: -0.02,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: NeoBrutalTheme.brutalBox(
            color: NeoBrutalColors.lime,
            borderColor: NeoBrutalColors.white,
            shadowColor: NeoBrutalColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "FULL INVENTORY",
                style: NeoBrutalTheme.heading.copyWith(
                  color: NeoBrutalColors.black,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: NeoBrutalColors.white,
                  border: Border.all(color: NeoBrutalColors.black, width: 2),
                ),
                child: Obx(
                  () => Text(
                    "${productController.productCount.value} ITEMS",
                    style: NeoBrutalTheme.mono.copyWith(
                      color: NeoBrutalColors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
