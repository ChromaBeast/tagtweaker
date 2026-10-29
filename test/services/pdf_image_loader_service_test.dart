import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/services/pdf_image_loader_service.dart';

void main() {
  group('PdfImageLoaderService Tests', () {
    setUp(PdfImageLoaderService.clearCache);

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
  });
}
