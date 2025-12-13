import 'package:flutter/material.dart';
import 'package:tag_tweaker/widgets/neumorphic_product_card.dart';

class CategoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> categoryList;
  final String category, text;
  const CategoryPage({
    super.key,
    required this.categoryList,
    required this.category,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Hero(
          tag: category,
          child: Material(
            color: Colors.transparent,
            child: Text(
              text,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          return NeumorphicProductCard(
            product: categoryList[index],
            showCategory: true,
            showBrandInRow: true, // Restore brand display
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.68,
        ),
      ),
    );
  }
}
