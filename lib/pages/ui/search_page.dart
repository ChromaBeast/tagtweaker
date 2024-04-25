import 'package:flutter/material.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';

import '../../models/searched_product_model.dart';
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
        child: ListView.builder(
          itemCount: SearchedProduct.products.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8.0),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            product: SearchedProduct.products[index],
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Hero(
                        tag: SearchedProduct.products[index]['thumbnail'],
                        child: Image.network(
                          SearchedProduct.products[index]['thumbnail'],
                          fit: BoxFit.contain,
                          height: 200.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
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
                      SearchedProduct.products[index]['title'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
        ),
      ),
    );
  }
}
