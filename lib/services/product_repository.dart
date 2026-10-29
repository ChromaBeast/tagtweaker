import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/models/product_model.dart';

/// A cached value plus the time it was stored, used for TTL expiry.
class _CacheEntry<T> {
  final T value;
  final DateTime storedAt;
  _CacheEntry(this.value, this.storedAt);
}

/// Repository for dynamic product Firestore queries with in-memory caching.
class ProductRepository extends GetxService {
  /// [firestore] and [clock] are injectable so the cache can be tested
  /// against a fake Firestore with controllable time.
  ProductRepository({
    FirebaseFirestore? firestore,
    DateTime Function()? clock,
    this.prewarmOnInit = true,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _clock = clock ?? DateTime.now;

  final FirebaseFirestore _firestore;
  final DateTime Function() _clock;
  final bool prewarmOnInit;
  static const String _collection = 'products';

  /// How long cached query results stay fresh before being re-fetched.
  static const Duration ttl = Duration(minutes: 10);

  /// Upper bound on cached search queries (oldest evicted first).
  static const int _maxSearchEntries = 50;

  /// Upper bound on documents returned by a single search / category query.
  static const int _maxResults = 100;

  // In-memory query cache to eliminate redundant Firestore reads
  final Map<String, _CacheEntry<List<Product>>> _cache = {};
  final Map<String, _CacheEntry<List<Product>>> _searchCache = {};
  _CacheEntry<int>? _cachedProductCount;

  // In-flight requests, so concurrent callers (e.g. prewarm + first build)
  // share a single Firestore read instead of issuing duplicates.
  final Map<String, Future<Object?>> _inFlight = {};

  @override
  void onInit() {
    super.onInit();
    // Pre-warm queries on service startup to eliminate cold read delay in UI
    if (prewarmOnInit) prewarm();
  }

  /// Pre-warm common queries asynchronously
  void prewarm() {
    fetchCarouselProducts();
    fetchTrendingProducts(limit: 6);
    getProductCount();
  }

  bool _isFresh(_CacheEntry<Object>? entry) =>
      entry != null && _clock().difference(entry.storedAt) < ttl;

  /// Runs [loader] at most once per [key] at a time; concurrent callers
  /// await the same future.
  Future<T> _dedupe<T>(String key, Future<T> Function() loader) {
    final existing = _inFlight[key];
    if (existing != null) return existing.then((v) => v as T);
    // Block body on purpose: `=> _inFlight.remove(key)` would return this
    // very future to whenComplete, which then waits on itself forever.
    final future = loader().whenComplete(() {
      _inFlight.remove(key);
    });
    _inFlight[key] = future;
    return future;
  }

  /// Cached + deduplicated list query. Falls back to stale data on error.
  Future<List<Product>> _cachedQuery(
    String key,
    Query<Map<String, dynamic>> Function() buildQuery, {
    bool forceRefresh = false,
  }) {
    final cached = _cache[key];
    if (!forceRefresh && _isFresh(cached)) {
      return Future.value(cached!.value);
    }

    return _dedupe(key, () async {
      try {
        final snapshot = await buildQuery().get();
        final list = snapshot.docs.map(Product.fromSnapshot).toList();
        _cache[key] = _CacheEntry(list, _clock());
        return list;
      } catch (e) {
        debugPrint('Error fetching products ($key): $e');
        return cached?.value ?? <Product>[];
      }
    });
  }

  /// Fetch products marked for carousel display.
  Future<List<Product>> fetchCarouselProducts({bool forceRefresh = false}) {
    return _cachedQuery(
      'carousel',
      () => _firestore
          .collection(_collection)
          .where('ui.carousel', isEqualTo: true)
          .limit(_maxResults),
      forceRefresh: forceRefresh,
    );
  }

  /// Fetch trending products, optionally limited.
  Future<List<Product>> fetchTrendingProducts({
    int limit = 6,
    bool forceRefresh = false,
  }) {
    return _cachedQuery(
      'trending_$limit',
      () => _firestore
          .collection(_collection)
          .where('isTrending', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(limit),
      forceRefresh: forceRefresh,
    );
  }

  /// Fetch top-rated products as fallback when no trending products exist.
  Future<List<Product>> fetchTopRatedProducts({
    int limit = 6,
    bool forceRefresh = false,
  }) {
    return _cachedQuery(
      'top_rated_$limit',
      () => _firestore
          .collection(_collection)
          .orderBy('rating', descending: true)
          .limit(limit),
      forceRefresh: forceRefresh,
    );
  }

  /// Fetch products by category.
  Future<List<Product>> fetchProductsByCategory(
    String category, {
    bool forceRefresh = false,
  }) {
    return _cachedQuery(
      'category_$category',
      () => _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .orderBy('rating', descending: true)
          .limit(_maxResults),
      forceRefresh: forceRefresh,
    );
  }

  /// Search products by title prefix with bounded memory caching.
  Future<List<Product>> searchProducts(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return Future.value(<Product>[]);

    final cached = _searchCache[trimmed];
    if (_isFresh(cached)) {
      // Re-insert to mark as most recently used.
      _searchCache.remove(trimmed);
      _searchCache[trimmed] = cached!;
      return Future.value(cached.value);
    }

    return _dedupe('search_$trimmed', () async {
      try {
        final snapshot = await _firestore
            .collection(_collection)
            .orderBy('title')
            .startAt([trimmed])
            .endAt(['$trimmed\uf8ff']) // \uf8ff = highest BMP code point
            .limit(_maxResults)
            .get();

        final list = snapshot.docs.map(Product.fromSnapshot).toList();
        _searchCache.remove(trimmed);
        _searchCache[trimmed] = _CacheEntry(list, _clock());
        while (_searchCache.length > _maxSearchEntries) {
          _searchCache.remove(_searchCache.keys.first);
        }
        return list;
      } catch (e) {
        debugPrint('Error searching products: $e');
        return cached?.value ?? <Product>[];
      }
    });
  }

  /// Get total product count with caching.
  Future<int> getProductCount({bool forceRefresh = false}) {
    final cached = _cachedProductCount;
    if (!forceRefresh && _isFresh(cached)) {
      return Future.value(cached!.value);
    }

    return _dedupe('count', () async {
      try {
        final snapshot = await _firestore.collection(_collection).count().get();
        final count = snapshot.count ?? 0;
        _cachedProductCount = _CacheEntry(count, _clock());
        return count;
      } catch (e) {
        debugPrint('Error getting product count: $e');
        return cached?.value ?? 0;
      }
    });
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
