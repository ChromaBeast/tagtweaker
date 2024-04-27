import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tag_tweaker/models/favourite_products.dart';

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        title: const Text('Product Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                clipBehavior: Clip.antiAlias,
                height: MediaQuery.of(context).size.height * 0.5,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: widget.product['images'].map<Widget>((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Hero(
                      tag: image,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          image: DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: widget.product['title'],
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.product['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '\$${widget.product['price']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          FavouriteProducts.toggleWishlist(
                              widget.product["id"]);
                        });
                      },
                      icon: widget.product["ui"]['isFavorite']
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
                      onPressed: () {},
                      icon: const Icon(
                        Icons.share,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Product Description',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.product['description'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
