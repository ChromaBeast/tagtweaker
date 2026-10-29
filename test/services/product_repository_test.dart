import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/services/product_repository.dart';

import '../helpers/fixtures.dart';

void main() {
  late FakeFirebaseFirestore db;
  late DateTime now;
  late ProductRepository repo;

  Future<void> seed() async {
    final products = [
      makeProduct(
        id: '1',
        title: 'Sony WH-1000XM6',
        category: 'Audio',
        rating: 4.8,
        isTrending: true,
        showInCarousel: true,
      ),
      makeProduct(
        id: '2',
        title: 'Sony Bravia',
        category: 'TV',
        rating: 4.2,
        isTrending: true,
      ),
      makeProduct(
        id: '3',
        title: 'MacBook Air',
        category: 'Laptop',
        rating: 4.9,
        showInCarousel: true,
      ),
      makeProduct(id: '4', title: 'AirPods', category: 'Audio', rating: 4.1),
    ];
    for (final p in products) {
      await db.collection('products').doc(p.id).set(p.toMap());
    }
  }

  setUp(() async {
    db = FakeFirebaseFirestore();
    now = DateTime(2026, 1, 1, 12);
    repo = ProductRepository(
      firestore: db,
      clock: () => now,
      prewarmOnInit: false,
    );
    await seed();
  });

  group('queries', () {
    test('carousel returns only carousel products', () async {
      final result = await repo.fetchCarouselProducts();
      expect(result.map((p) => p.id), unorderedEquals(['1', '3']));
    });

    test('trending is ordered by rating and respects the limit', () async {
      final result = await repo.fetchTrendingProducts(limit: 1);
      expect(result.map((p) => p.id), ['1']);
    });

    test('top rated is ordered by rating', () async {
      final result = await repo.fetchTopRatedProducts(limit: 3);
      expect(result.map((p) => p.id), ['3', '1', '2']);
    });

    test('category filter', () async {
      final result = await repo.fetchProductsByCategory('Audio');
      expect(result.map((p) => p.id), ['1', '4']);
    });

    test('search matches by title prefix', () async {
      final result = await repo.searchProducts('Sony');
      expect(result.map((p) => p.title), ['Sony Bravia', 'Sony WH-1000XM6']);
      expect(await repo.searchProducts('Bose'), isEmpty);
      expect(await repo.searchProducts('   '), isEmpty);
    });

    test('product count', () async {
      expect(await repo.getProductCount(), 4);
    });

    test('fetch by id returns null for unknown products', () async {
      expect((await repo.fetchProductById('3'))?.title, 'MacBook Air');
      expect(await repo.fetchProductById('missing'), isNull);
    });
  });

  group('caching', () {
    test('serves cached results within the TTL', () async {
      await repo.fetchProductsByCategory('Audio');
      await db.collection('products').doc('4').delete();

      final cached = await repo.fetchProductsByCategory('Audio');
      expect(cached.map((p) => p.id), ['1', '4']);
    });

    test('re-fetches after the TTL expires', () async {
      await repo.fetchProductsByCategory('Audio');
      await db.collection('products').doc('4').delete();

      now = now.add(ProductRepository.ttl + const Duration(seconds: 1));
      final fresh = await repo.fetchProductsByCategory('Audio');
      expect(fresh.map((p) => p.id), ['1']);
    });

    test('forceRefresh bypasses the cache', () async {
      await repo.fetchCarouselProducts();
      await db.collection('products').doc('3').delete();

      final fresh = await repo.fetchCarouselProducts(forceRefresh: true);
      expect(fresh.map((p) => p.id), ['1']);
    });

    test('invalidateCache clears every cache', () async {
      await repo.getProductCount();
      await repo.searchProducts('Sony');
      await db.collection('products').doc('2').delete();

      repo.invalidateCache();
      expect(await repo.getProductCount(), 3);
      expect((await repo.searchProducts('Sony')).length, 1);
    });

    test('search cache is bounded', () async {
      for (var i = 0; i < 60; i++) {
        await repo.searchProducts('query$i');
      }
      // Oldest entry was evicted, so a new product shows up for it.
      await db
          .collection('products')
          .doc('9')
          .set(makeProduct(id: '9', title: 'query0 item').toMap());
      expect((await repo.searchProducts('query0')).length, 1);
      // A recent entry is still cached.
      await db
          .collection('products')
          .doc('10')
          .set(makeProduct(id: '10', title: 'query59 item').toMap());
      expect(await repo.searchProducts('query59'), isEmpty);
    });

    test('concurrent callers share one in-flight request', () async {
      final results = await Future.wait([
        repo.fetchTrendingProducts(),
        repo.fetchTrendingProducts(),
      ]);
      expect(identical(results[0], results[1]), isTrue);
    });
  });
}
