import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product_model.dart';
import '../../pages/ui/category_page.dart';
import '../../themes/neo_brutal_theme.dart';

/// Horizontal scrollable category list with Neo-Brutal styled cards
class HomeCategoriesRow extends StatelessWidget {
  const HomeCategoriesRow({super.key});

  static const Map<String, String> categoryImages = {
    'Smartphone': 'assets/categories/smartphone.webp',
    'Laptop': 'assets/categories/laptop.webp',
    'Controller': 'assets/categories/controller.webp',
    'Audio': 'assets/categories/audio.webp',
    'TV': 'assets/categories/tv.webp',
    'Accessories': 'assets/categories/accessories.webp',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(Product.categories.length, (index) {
          final category = Product.categories[index];
          final imgUrl =
              categoryImages[category] ?? categoryImages.values.first;

          return GestureDetector(
            onTap: () {
              Get.to(() => CategoryPage(category: category, text: category));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 140,
              decoration: NeoBrutalTheme.brutalBox(
                color: NeoBrutalColors.white,
                borderColor: NeoBrutalColors.black,
                shadowColor: NeoBrutalColors.black,
                shadowOffset: 4,
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset(imgUrl, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.toUpperCase(),
                    style: NeoBrutalTheme.heading.copyWith(
                      fontSize: 12,
                      color: NeoBrutalColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
