import 'package:flutter/material.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';

import '../../themes/colors.dart';

class TrendingNowPage extends StatelessWidget {
  final List products;

  const TrendingNowPage({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        title: const Text('Trending Now'),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: GridView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
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
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.4,
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
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Hero(
                          tag: products[index]['thumbnail'],
                          child: Image.network(
                            products[index]['thumbnail'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(products[index]['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, // High contrast text
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
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
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Row(
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
                        ),
                        Expanded(
                          child: Text(
                            "by ${products[index]['brand']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors
                                  .grey[400], // Slightly lighter 'by' text
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.75,
          ),
        ),
      ),
    );
  }
}
