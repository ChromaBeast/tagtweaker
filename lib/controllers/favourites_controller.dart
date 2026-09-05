import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pdf_preview_controller.dart';
import '../models/product_model.dart';
import '../pages/ui/pdf_preview_page.dart';
import '../services/catalog_pdf_service.dart';
import '../widgets/custom_snackbar.dart';

class FavouritesController extends GetxController {
  // Map to store local price overrides: ProductID -> New Price
  final RxMap<String, String> modifiedPrices = <String, String>{}.obs;

  // Cached set of favourite product IDs for instant optimistic UI sync
  final RxSet<String> favouriteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .get();
      favouriteIds.assignAll(snapshot.docs.map((doc) => doc.id));
    } catch (e) {
      debugPrint('Error loading favourites: $e');
    }
  }

  bool isFavourite(String productId) => favouriteIds.contains(productId);

  Future<bool> toggleFavourite(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnackbar.showError(
        title: 'LOGIN REQUIRED',
        message: 'Please login to save favourites',
      );
      return false;
    }

    final isFav = isFavourite(product.id);
    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favourites')
        .doc(product.id);

    // Optimistic local state update
    if (isFav) {
      favouriteIds.remove(product.id);
    } else {
      favouriteIds.add(product.id);
    }

    try {
      if (isFav) {
        await favRef.delete();
        CustomSnackbar.showSuccess(
          title: 'REMOVED',
          message: 'Product removed from favourites',
        );
      } else {
        await favRef.set(product.toMap());
        CustomSnackbar.showSuccess(
          title: 'SUCCESS',
          message: 'Product added to favourites',
        );
      }
      return true;
    } catch (e) {
      // Revert on error
      if (isFav) {
        favouriteIds.add(product.id);
      } else {
        favouriteIds.remove(product.id);
      }
      CustomSnackbar.showError(
        title: 'ERROR',
        message: 'Error updating favourites: $e',
      );
      return false;
    }
  }

  void updatePrice(String productId, String newPrice) {
    if (newPrice.isEmpty) {
      modifiedPrices.remove(productId);
    } else {
      modifiedPrices[productId] = newPrice;
    }
  }

  String getPrice(String productId, String originalPrice) {
    return modifiedPrices[productId] ?? originalPrice;
  }

  Future<void> generatePDF(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favourites')
        .get();

    if (snapshot.docs.isEmpty) {
      if (context.mounted) {
        CustomSnackbar.showError(
          title: 'EMPTY CATALOG',
          message: 'No items in the catalog to generate PDF.',
        );
      }
      return;
    }

    // Navigate immediately to the preview page
    Get.to(
      () => const PdfPreviewPage(),
      binding: BindingsBuilder(() {
        Get.put(
          PdfPreviewController(
            pdfGenerator: () => _generatePdfFile(snapshot.docs),
          ),
        );
      }),
    );
  }

  Future<String> _generatePdfFile(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    final items = docs.map((doc) {
      final product = Product.fromSnapshot(doc);
      if (modifiedPrices.containsKey(product.id)) {
        final modPrice = double.tryParse(modifiedPrices[product.id]!) ?? product.price;
        return product.copyWith(price: modPrice);
      }
      return product;
    }).toList();

    return CatalogPdfService.generateCatalogPdf(items);
  }
}
