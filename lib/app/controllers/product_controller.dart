import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      isLoading.value = true;
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      products.assignAll(snapshot.docs);
      isError.value = false;
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
