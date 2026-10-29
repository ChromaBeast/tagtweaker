import 'package:tag_tweaker/models/product_model.dart';

Product makeProduct({
  String id = 'p1',
  String title = 'Sony WH-1000XM6',
  double price = 1000,
  String category = 'Audio',
  double rating = 4.5,
  String thumbnail = '',
  bool isTrending = false,
  bool showInCarousel = false,
}) {
  return Product(
    id: id,
    title: title,
    price: price,
    rating: rating,
    thumbnail: thumbnail,
    images: const [],
    category: category,
    brand: 'Brand',
    description: 'Description',
    isTrending: isTrending,
    showInCarousel: showInCarousel,
  );
}
