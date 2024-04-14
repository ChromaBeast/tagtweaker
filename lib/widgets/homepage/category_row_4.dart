import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../../pages/ui/product_page.dart';

Widget categoryRow(String text, String leading) {
  List products = Product.products
      .where((element) => element['ui']["is$text"] == true)
      .toList();
  int len = products.length;
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$text $leading",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Icon(Icons.play_arrow_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10.0),
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: len,
          itemBuilder: (BuildContext context, int index) {
            final img = products[index]['thumbnail'];
            return Row(
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              product: products[index],
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: products[index]["thumbnail"],
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.3,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            image: DecorationImage(
                              image: NetworkImage(img),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Hero(
                      tag: products[index]['id'].toString(),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(products[index]['title'],
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
      ),
    ],
  );
}
