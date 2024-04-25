import 'package:flutter/material.dart';
import 'package:tag_tweaker/models/favourite_products.dart';
import 'package:tag_tweaker/pages/ui/product_page.dart';
import 'package:tag_tweaker/widgets/functions/share_individual.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          title: const Text(
            'Favourite Products',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView.builder(
          itemCount: FavouriteProducts.products.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      FavouriteProducts.products[index]['thumbnail'],
                      fit: BoxFit.cover,
                      height: 200.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    FavouriteProducts.products[index]['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                                product: FavouriteProducts.products[index],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '\$${FavouriteProducts.products[index]['price']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                FavouriteProducts.toggleWishlist(
                                    FavouriteProducts.products[index]["id"]);
                              });
                            },
                            icon: FavouriteProducts.products[index]["ui"]
                                    ['isFavorite']
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey,
                                  ),
                          ),
                          IconButton(
                            onPressed: () {
                              genPDF(
                                  context, FavouriteProducts.products[index]);
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
                ],
              ),
            );
          },
        ));
  }
}

void goToProductPage(BuildContext context, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductPage(
        product: FavouriteProducts.products[index],
      ),
    ),
  );
}
