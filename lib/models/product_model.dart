import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final double rating;
  final String thumbnail;
  final List<String> images;
  final String category;
  final String brand;
  final String description;
  final bool isTrending;
  final bool isNew;
  final bool showInCarousel;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.images,
    required this.category,
    required this.brand,
    required this.description,
    this.isTrending = false,
    this.isNew = false,
    this.showInCarousel = false,
  });

  factory Product.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title']?.toString() ?? 'Unknown',
      price: double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
      rating: double.tryParse(data['rating']?.toString() ?? '0') ?? 0.0,
      thumbnail: data['thumbnail']?.toString() ?? '',
      images:
          (data['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      category: data['category']?.toString() ?? 'General',
      brand: data['brand']?.toString() ?? 'Generic',
      description: data['description']?.toString() ?? '',
      isTrending: data['isTrending'] == true,
      isNew: data['isNew'] == true,
      showInCarousel: data['ui']?['carousel'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'rating': rating,
      'thumbnail': thumbnail,
      'images': images,
      'category': category,
      'brand': brand,
      'description': description,
      'isTrending': isTrending,
      'isNew': isNew,
      'ui': {'carousel': showInCarousel},
    };
  }

  static const List<String> categories = [
    "Smartphone",
    "Laptop",
    "Controller",
    "Audio",
    "TV",
    "Accessories",
  ];
}
