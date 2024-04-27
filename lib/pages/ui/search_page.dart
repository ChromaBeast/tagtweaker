import 'package:flutter/material.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';

import '../../models/searched_product_model.dart';
import '../../themes/colors.dart';
import '../../widgets/functions/share_individual.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        centerTitle: true,
        title: const Text('Search Products'),
      ),
      body: Column(
        children: [
          _buildSearchTextField(),
          _buildProductList(),
        ],
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: TextField(
        controller: searchController,
        onChanged: (query) {
          setState(() {
            SearchedProduct.search(query);
          });
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          hintText: 'Search Products',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
        ),
        cursorColor: Colors.white,
      ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      child: Scrollbar(
        interactive: true,
        radius: const Radius.circular(16.0),
        thickness: 5.0,
        trackVisibility: false,
        child: Container(
          margin: const EdgeInsets.all(8),
          child: GridView.builder(
            itemCount: SearchedProduct.products.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                product: SearchedProduct.products[index],
                              ),
                            ),
                          );
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Hero(
                          tag: SearchedProduct.products[index]['thumbnail'],
                          child: Image.network(
                            SearchedProduct.products[index]['thumbnail'],
                            fit: BoxFit.contain,
                            height: 150.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                product: SearchedProduct.products[index],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          SearchedProduct.products[index]['title'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "By: ${SearchedProduct.products[index]['brand']}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: ratingColors[SearchedProduct
                                    .products[index]['rating']
                                    .toInt()],
                              ),
                              Text(
                                "${SearchedProduct.products[index]['rating'].toStringAsFixed(1)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                  product: SearchedProduct.products[index],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            '\$${SearchedProduct.products[index]['price']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            genPDF(context, SearchedProduct.products[index]);
                          },
                          icon: const Icon(
                            Icons.share,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
              mainAxisExtent: 300.0,
            ),
          ),
        ),
      ),
    );
  }
}
