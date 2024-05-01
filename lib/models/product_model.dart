import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product {
  static List<Map<String, dynamic>> products = [];

  fetchProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    // Update the 'products' list with the retrieved data
    products = querySnapshot.docs
        .where((doc) =>
            doc.data() is Map<String, dynamic>) // Filter for valid maps
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    products.sort((a, b) => b['rating'].compareTo(a['rating']));
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
