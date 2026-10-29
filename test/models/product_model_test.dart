import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/product_model.dart';

import '../helpers/fixtures.dart';

void main() {
  group('Product.fromSnapshot', () {
    late FakeFirebaseFirestore db;

    setUp(() => db = FakeFirebaseFirestore());

    test('parses a complete document', () async {
      await db.collection('products').doc('42').set({
        'title': 'Pixel 9',
        'price': 79999,
        'rating': 4.7,
        'thumbnail': 'https://example.com/p.webp',
        'images': ['a', 'b'],
        'category': 'Smartphone',
        'brand': 'Google',
        'description': 'Phone',
        'isTrending': true,
        'isNew': true,
        'ui': {'carousel': true},
      });

      final p = Product.fromSnapshot(
        await db.collection('products').doc('42').get(),
      );

      expect(p.id, '42');
      expect(p.title, 'Pixel 9');
      expect(p.price, 79999);
      expect(p.images, ['a', 'b']);
      expect(p.isTrending, isTrue);
      expect(p.isNew, isTrue);
      expect(p.showInCarousel, isTrue);
    });

    test('coerces string numbers and fills defaults', () async {
      await db.collection('products').doc('x').set({
        'price': '1299.5',
        'rating': 'not-a-number',
      });

      final p = Product.fromSnapshot(
        await db.collection('products').doc('x').get(),
      );

      expect(p.price, 1299.5);
      expect(p.rating, 0);
      expect(p.title, 'Unknown');
      expect(p.category, 'General');
      expect(p.brand, 'Generic');
      expect(p.images, isEmpty);
      expect(p.showInCarousel, isFalse);
    });

    test('toMap round-trips through Firestore', () async {
      final original = makeProduct(id: 'rt', isTrending: true);
      await db.collection('products').doc('rt').set(original.toMap());

      final restored = Product.fromSnapshot(
        await db.collection('products').doc('rt').get(),
      );

      expect(restored.toMap(), original.toMap());
    });
  });

  test('copyWith only changes the given fields', () {
    final p = makeProduct(price: 100);
    final q = p.copyWith(price: 80);
    expect(q.price, 80);
    expect(q.title, p.title);
    expect(q.id, p.id);
  });
}
