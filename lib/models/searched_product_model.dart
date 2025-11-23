import 'package:tag_tweaker/models/product_model.dart';

class SearchedProduct {
  Product product = Product();
  static List<Map<String, dynamic>> products = [];

  void search(query) {
    products = Product.products
        .where((product) => product['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }
}
