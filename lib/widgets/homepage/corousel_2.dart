import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../../pages/ui/product_page.dart';
import 'package:tag_tweaker/widgets/custom_network_image.dart';

Widget carouselSlider(context) {
  List<Widget> items = Product.products
      .where((product) => product["ui"]['carousel'] == true)
      .map((product) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(
                    product: product,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CustomNetworkImage(
                product['thumbnail'].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ))
      .toList();

  return CarouselSlider(
      items: items,
      options: CarouselOptions(
        scrollPhysics: const BouncingScrollPhysics(),
        height: 250,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.easeInOutCubicEmphasized,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ));
}
