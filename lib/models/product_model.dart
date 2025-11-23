import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product {
  static List<Map<String, dynamic>> products = [];

  fetchProducts() async {
    print('🔄 DEBUG [Product Model]: Starting fetchProducts...');
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    print(
        '📥 DEBUG [Product Model]: Received ${querySnapshot.docs.length} documents from Firestore');

    // Update the 'products' list with the retrieved data
    products = querySnapshot.docs
        .where((doc) =>
            doc.data() is Map<String, dynamic>) // Filter for valid maps
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    print(
        '✨ DEBUG [Product Model]: Filtered to ${products.length} valid products');

    products.sort((a, b) => b['rating'].compareTo(a['rating']));

    print('✅ DEBUG [Product Model]: Products sorted and ready!');
    print(
        '📋 DEBUG [Product Model]: Product.products now has ${products.length} items');
    if (products.isNotEmpty) {
      print(
          '🎯 DEBUG [Product Model]: First product title: ${products.first['title']}');
    }
  }

  static List categories = [
    "Smartphone",
    "Laptop",
    "Controller",
    "Audio",
    "TV",
    "Accessories",
  ];

  List search(String query) {
    return products
        .where((product) => product['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  List filterByCategory(String category) {
    return products
        .where((product) => product['category'] == category)
        .toList();
  }

  static Future<List> getFavorites() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favourites')
        .get()
        .then((value) {
      print(value.docs.map((doc) => doc.data()).toList());
      return value.docs.map((doc) => doc.data()).toList();
    });
    return [];
  }
}
