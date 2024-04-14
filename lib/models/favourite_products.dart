import 'package:tag_tweaker/models/product_model.dart';

class FavouriteProducts {
  static List<Map<String, dynamic>> products = Product.products
      .where((product) => product["ui"]["isFavorite"] == true)
      .toList();
  static void updateWishlist() {
    products = Product.products
        .where((product) => product["ui"]["isFavorite"] == true)
        .toList();
  }

  static void toggleWishlist(id) {
    for (var product in Product.products) {
      if (product["id"] == id) {
        product["ui"]["isFavorite"] = !product["ui"]["isFavorite"];
      }
    }
    updateWishlist();
  }
}
