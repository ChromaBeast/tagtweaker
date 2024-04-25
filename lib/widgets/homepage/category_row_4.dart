import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../models/product_model.dart';
import '../../pages/ui/product_page.dart';

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
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
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
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: len,
            itemBuilder: (BuildContext context, int index) {
              final img = products[index]['thumbnail'];
              return Row(
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
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.all(10),
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
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.2,
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
                          const SizedBox(height: 10),
                          Expanded(
                            flex: 1,
                            child: Text(products[index]['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, // High contrast text
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                          RatingBar.builder(
                            initialRating: products[index]['rating'],
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            updateOnDrag: false,
                            itemCount: 5,
                            itemSize: 20, // Adjust the size of the stars
                            itemBuilder: (context, _) => const Icon(
                              Icons.circle,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (double value) {},
                            ignoreGestures: true,
                          ),
                          Text(
                            "${products[index]['category']}",
                            style: TextStyle(
                              color: Colors.grey[50], //  Lighter text
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            "by ${products[index]['brand']}",
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors
                                  .grey[400], // Slightly lighter 'by' text
                              fontSize: 16,
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
        ),
      ],
    ),
  );
}
