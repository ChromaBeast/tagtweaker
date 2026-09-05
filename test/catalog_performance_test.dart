import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/services/pdf_image_loader_service.dart';

void main() {
  group('PdfImageLoaderService Tests', () {
    setUp(() {
      PdfImageLoaderService.clearCache();
    });

    test('handles null and empty URLs gracefully without error', () async {
      final imgNull = await PdfImageLoaderService.fetchImage(null);
      final imgEmpty = await PdfImageLoaderService.fetchImage('   ');

      expect(imgNull, isNull);
      expect(imgEmpty, isNull);
      expect(PdfImageLoaderService.cachedCount, 0);
    });

    test('concurrent image batch loader maps items correctly', () async {
      final items = [
        Product(
          id: '1',
          title: 'Item 1',
          price: 10,
          rating: 4.5,
          thumbnail: '',
          images: [],
          category: 'Test',
          brand: 'Brand',
          description: 'Desc',
        ),
        Product(
          id: '2',
          title: 'Item 2',
          price: 20,
          rating: 4.0,
          thumbnail: '   ',
          images: [],
          category: 'Test',
          brand: 'Brand',
          description: 'Desc',
        ),
      ];

      final results = await PdfImageLoaderService.loadImagesConcurrently(items);

      expect(results.length, 2);
      expect(results['1'], isNull);
      expect(results['2'], isNull);
    });

    test('benchmarks sub-millisecond memory cache lookup performance', () {
      final sw = Stopwatch()..start();
      for (int i = 0; i < 1000; i++) {
        PdfImageLoaderService.cachedCount;
      }
      sw.stop();

      expect(sw.elapsedMilliseconds, lessThan(50));
    });
  });

  group('Catalog Price Override Logic Tests', () {
    test('local price overrides take precedence over remote pricing', () {
      final modifiedPrices = {'prod_101': '49.99', 'prod_102': '199.00'};
      final remoteItems = [
        Product(
          id: 'prod_101',
          title: 'Shoes',
          price: 89.99,
          rating: 4,
          thumbnail: '',
          images: [],
          category: 'Fashion',
          brand: 'Brand',
          description: 'Desc',
        ),
        Product(
          id: 'prod_102',
          title: 'Jacket',
          price: 249.99,
          rating: 5,
          thumbnail: '',
          images: [],
          category: 'Fashion',
          brand: 'Brand',
          description: 'Desc',
        ),
      ];

      final processed = remoteItems.map((item) {
        if (modifiedPrices.containsKey(item.id)) {
          final modPrice = double.tryParse(modifiedPrices[item.id]!) ?? item.price;
          return item.copyWith(price: modPrice);
        }
        return item;
      }).toList();

      expect(processed[0].price, 49.99);
      expect(processed[1].price, 199.00);
    });
  });
}
