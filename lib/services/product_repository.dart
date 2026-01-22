import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

/// Repository for dynamic product Firestore queries.
/// Each method queries the database directly instead of loading all products.
class ProductRepository extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'products';

  /// Fetch products marked for carousel display.
  Future<List<Product>> fetchCarouselProducts() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('ui.carousel', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    } catch (e) {
      print('❌ Error fetching carousel products: $e');
      return [];
    }
  }

  /// Fetch trending products, optionally limited.
  Future<List<Product>> fetchTrendingProducts({int limit = 6}) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isTrending', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    } catch (e) {
      print('❌ Error fetching trending products: $e');
      return [];
    }
  }

  /// Fetch top-rated products as fallback when no trending products exist.
  Future<List<Product>> fetchTopRatedProducts({int limit = 6}) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    } catch (e) {
      print('❌ Error fetching top-rated products: $e');
      return [];
    }
  }

  /// Fetch products by category.
  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    } catch (e) {
      print('❌ Error fetching products for category $category: $e');
      return [];
    }
  }

  /// Search products by title prefix.
  /// Firestore doesn't support full-text search, so we use startAt/endAt.
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    try {
      // Firestore range query for prefix matching
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('title')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();

      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    } catch (e) {
      print('❌ Error searching products: $e');
      return [];
    }
  }

  /// Get total product count for display purposes.
  Future<int> getProductCount() async {
    try {
      final snapshot = await _firestore.collection(_collection).count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('❌ Error getting product count: $e');
      return 0;
    }
  }

  /// Fetch a single product by ID.
  Future<Product?> fetchProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Product.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      print('❌ Error fetching product by ID: $e');
      return null;
    }
  }
}
