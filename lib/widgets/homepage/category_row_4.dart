import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../../pages/ui/product_page.dart';
import '../../themes/colors.dart';

Widget categoryRow(String text, String leading, BuildContext context) {
  List products = Product.products
      .where((element) => element['ui']["is$text"] == true)
      .toList();
  int len = products.length;
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(30),
    ),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$text $leading",
                style: const TextStyle(
                  fontSize: 20,
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
          margin: const EdgeInsets.only(left: 6, right: 6),
          height: MediaQuery.of(context).size.height * 0.32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: len,
            itemBuilder: (BuildContext context, int index) {
              final img = products[index]['thumbnail'];
              return InkWell(
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
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Hero(
                          tag: products[index]['thumbnail'],
                          child: Image.network(
                            img,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(products[index]['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, // High contrast text
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        "${products[index]['category']}",
                        style: TextStyle(
                          color: Colors.grey[50], //  Lighter text
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "by ${products[index]['brand']}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors
                                  .grey[400], // Slightly lighter 'by' text
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: ratingColors[
                                    products[index]['rating'].toInt()],
                              ),
                              Text(
                                "${products[index]['rating'].toStringAsFixed(1)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
