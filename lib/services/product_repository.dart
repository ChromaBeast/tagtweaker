import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

/// Repository for dynamic product Firestore queries with in-memory caching.
class ProductRepository extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'products';

  // In-memory query cache to eliminate redundant Firestore reads
  final Map<String, List<Product>> _cache = {};
  final Map<String, List<Product>> _searchCache = {};
  int? _cachedProductCount;

  @override
  void onInit() {
    super.onInit();
    // Pre-warm queries on service startup to eliminate cold read delay in UI
    prewarm();
  }

  /// Pre-warm common queries asynchronously
  void prewarm() {
    fetchCarouselProducts();
    fetchTrendingProducts(limit: 6);
    getProductCount();
  }

  /// Fetch products marked for carousel display.
  Future<List<Product>> fetchCarouselProducts({bool forceRefresh = false}) async {
    const key = 'carousel';
    if (!forceRefresh && _cache.containsKey(key)) {
      return _cache[key]!;
    }

    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('ui.carousel', isEqualTo: true)
          .get();

      final list = snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      _cache[key] = list;
      return list;
    } catch (e) {
      debugPrint('Error fetching carousel products: $e');
      return _cache[key] ?? [];
    }
  }

  /// Fetch trending products, optionally limited.
  Future<List<Product>> fetchTrendingProducts({int limit = 6, bool forceRefresh = false}) async {
    final key = 'trending_$limit';
    if (!forceRefresh && _cache.containsKey(key)) {
      return _cache[key]!;
    }

    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isTrending', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      final list = snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      _cache[key] = list;
      return list;
    } catch (e) {
      debugPrint('Error fetching trending products: $e');
      return _cache[key] ?? [];
    }
  }

  /// Fetch top-rated products as fallback when no trending products exist.
  Future<List<Product>> fetchTopRatedProducts({int limit = 6, bool forceRefresh = false}) async {
    final key = 'top_rated_$limit';
    if (!forceRefresh && _cache.containsKey(key)) {
      return _cache[key]!;
    }

    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      final list = snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      _cache[key] = list;
      return list;
    } catch (e) {
      debugPrint('Error fetching top-rated products: $e');
      return _cache[key] ?? [];
    }
  }

  /// Fetch products by category.
  Future<List<Product>> fetchProductsByCategory(String category, {bool forceRefresh = false}) async {
    final key = 'category_$category';
    if (!forceRefresh && _cache.containsKey(key)) {
      return _cache[key]!;
    }

    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .orderBy('rating', descending: true)
          .get();

      final list = snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      _cache[key] = list;
      return list;
    } catch (e) {
      debugPrint('Error fetching products for category $category: $e');
      return _cache[key] ?? [];
    }
  }

  /// Search products by title prefix with memory caching.
  Future<List<Product>> searchProducts(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    if (_searchCache.containsKey(trimmed)) {
      return _searchCache[trimmed]!;
    }

    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('title')
          .startAt([trimmed])
          .endAt(['$trimmed\uf8ff'])
          .get();

      final list = snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      _searchCache[trimmed] = list;
      return list;
    } catch (e) {
      debugPrint('Error searching products: $e');
      return _searchCache[trimmed] ?? [];
    }
  }

  /// Get total product count with caching.
  Future<int> getProductCount({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProductCount != null) {
      return _cachedProductCount!;
    }

    try {
      final snapshot = await _firestore.collection(_collection).count().get();
      _cachedProductCount = snapshot.count ?? 0;
      return _cachedProductCount!;
    } catch (e) {
      debugPrint('Error getting product count: $e');
      return _cachedProductCount ?? 0;
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
      debugPrint('Error fetching product by ID: $e');
      return null;
    }
  }

  /// Invalidate query cache.
  void invalidateCache() {
    _cache.clear();
    _searchCache.clear();
    _cachedProductCount = null;
  }
}
