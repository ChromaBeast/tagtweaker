import 'favourite_products.dart';

class CatalogItems {
  static List<Map<String, dynamic>> items = FavouriteProducts.products
      .where((product) => product["ui"]["isInCatalog"] == true)
      .toList();
  static void updateCatalog() {
    items = FavouriteProducts.products
        .where((product) => product["ui"]["isInCatalog"] == true)
        .toList();
  }

  static void toggleCatalog(id) {
    for (var product in FavouriteProducts.products) {
      if (product["id"] == id) {
        product["ui"]["isInCatalog"] = !product["ui"]["isInCatalog"];
      }
    }
    updateCatalog();
  }
}
