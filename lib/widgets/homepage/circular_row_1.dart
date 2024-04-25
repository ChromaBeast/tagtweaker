import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../../pages/ui/category_page.dart';

Widget circularRow(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.all(10.0),
    height: MediaQuery.of(context).size.height * 0.17,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: Product.categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = Product.categories[index].toLowerCase();
        final img = "assets/icons/$category.png";
        final categoryProducts = Product.products
            .where((element) => element['category'] == category)
            .toList();
        return Row(
          children: [
            InkWell(
              splashColor: Colors.transparent,
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
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(img),
                      ),
                    ),
                    Hero(
                      tag: Product.categories[index].toLowerCase(),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(Product.categories[index],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
