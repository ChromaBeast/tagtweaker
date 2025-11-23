import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tag_tweaker/models/product_model.dart';

class SamplePage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              for (int i = 0; i < Product.products.length; i++) {
                await firestore.collection('products').add(Product.products[i]);
              }
            },
            child: const Text('Add Products to Firestore'),
          ),
        ],
      ),
    );
  }
}
