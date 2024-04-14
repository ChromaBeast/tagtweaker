import 'package:tag_tweaker/models/product_model.dart';

class SearchedProduct {
  static List<Map<String, dynamic>> products = Product.products;
  static void search(String query) {
    SearchedProduct.products = Product.products
        .where((product) => product['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }
}
