import 'package:flutter/material.dart';

import '../../models/categories.dart';
import '../../models/product_model.dart';
import '../../pages/ui/category_page.dart';

Widget circularRow() {
  return Container(
    padding: const EdgeInsets.all(10.0),
    height: 180,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: Category.categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = Category.categories[index].toLowerCase();
        final img = "assets/icons/$category.png";
        final categoryProducts = Product.products
            .where((element) => element['category'] == category)
            .toList();
        return Row(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryPage(
                          categoryList: categoryProducts,
                          category: category,
                          text: Category.categories[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.18,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.85),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(img),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Hero(
                  tag: Category.categories[index].toLowerCase(),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(Category.categories[index],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
          ],
        );
      },
    ),
  );
}
