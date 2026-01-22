import 'package:get/get.dart';
import '../services/product_repository.dart';

/// Lightweight controller for shared product state.
/// Individual pages use ProductRepository directly for their specific queries.
class ProductController extends GetxController {
  final ProductRepository _repository = Get.find<ProductRepository>();

  // Shared state for product count (used in header display)
  var productCount = 0.obs;
  var isCountLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProductCount();
  }

  Future<void> _loadProductCount() async {
    try {
      isCountLoading.value = true;
      productCount.value = await _repository.getProductCount();
    } catch (e) {
      print('❌ Error loading product count: $e');
    } finally {
      isCountLoading.value = false;
    }
  }

  /// Refresh product count (call after adding/removing products)
  Future<void> refreshProductCount() async {
    await _loadProductCount();
  }
}
