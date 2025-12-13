import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = true.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      print('🔍 DEBUG: Starting to fetch products...');
      isLoading.value = true;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      print('✅ DEBUG: Products fetched successfully!');
      print('📦 DEBUG: Total products count: ${snapshot.docs.length}');

      final loadedProducts = snapshot.docs
          .map((doc) => Product.fromSnapshot(doc))
          .toList();

      // Sort by rating desc
      loadedProducts.sort((a, b) => b.rating.compareTo(a.rating));

      products.assignAll(loadedProducts);
      filteredProducts.assignAll(loadedProducts);
      
      print('✨ DEBUG: Loaded ${products.length} products');

      isError.value = false;
    } catch (e) {
      print('❌ DEBUG: Error fetching products: $e');
      print('❌ DEBUG: Error type: ${e.runtimeType}');
      isError.value = true;
    } finally {
      isLoading.value = false;
      print(
        '🏁 DEBUG: Fetch products completed. isLoading: ${isLoading.value}, isError: ${isError.value}',
      );
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((product) {
          final title = product.title.toLowerCase();
          return title.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }
}
