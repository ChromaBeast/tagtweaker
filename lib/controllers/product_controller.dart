import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var products = RxList<DocumentSnapshot>();
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

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();

      print('✅ DEBUG: Products fetched successfully!');
      print('📦 DEBUG: Total products count: ${snapshot.docs.length}');

      if (snapshot.docs.isNotEmpty) {
        print('📋 DEBUG: First product data: ${snapshot.docs.first.data()}');
        print(
            '📋 DEBUG: Product IDs: ${snapshot.docs.map((doc) => doc.id).toList()}');
      } else {
        print('⚠️ DEBUG: No products found in Firestore collection!');
      }

      products.assignAll(snapshot.docs);

      // IMPORTANT: Also populate the static Product.products list for UI widgets
      print('🔄 DEBUG: Populating Product.products static list...');
      Product.products = snapshot.docs
          .where((doc) => doc.data() is Map<String, dynamic>)
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      Product.products.sort((a, b) => b['rating'].compareTo(a['rating']));
      print(
          '✨ DEBUG: Product.products now has ${Product.products.length} items');

      isError.value = false;
    } catch (e) {
      print('❌ DEBUG: Error fetching products: $e');
      print('❌ DEBUG: Error type: ${e.runtimeType}');
      isError.value = true;
    } finally {
      isLoading.value = false;
      print(
          '🏁 DEBUG: Fetch products completed. isLoading: ${isLoading.value}, isError: ${isError.value}');
    }
  }
}
