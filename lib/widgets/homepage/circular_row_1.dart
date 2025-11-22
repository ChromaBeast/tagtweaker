import 'package:flutter/material.dart';

import '../../app/data/models/product_model.dart';
import '../../pages/ui/category_page.dart';

Widget circularRow(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    height: MediaQuery.of(context).size.height * 0.15,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: Product.categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = Product.categories[index].toLowerCase();
        final img = "assets/icons/$category.png";
        final categoryProducts = Product.products
            .where((element) => element['category'] == category)
            .toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: colorScheme.primary.withOpacity(0.12),
              highlightColor: colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      categoryList: categoryProducts,
                      category: category,
                      text: Product.categories[index],
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.width * 0.12,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        img,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Hero(
                      tag: Product.categories[index].toLowerCase(),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          Product.categories[index],
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
