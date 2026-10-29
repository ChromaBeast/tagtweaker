import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/pdf_preview_controller.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/models/quotation.dart';
import 'package:tag_tweaker/pages/ui/pdf_preview_page.dart';
import 'package:tag_tweaker/services/catalog_pdf_service.dart';
import 'package:tag_tweaker/services/pricing_engine.dart';
import 'package:tag_tweaker/services/quotation_repository.dart';
import 'package:tag_tweaker/widgets/custom_snackbar.dart';
import 'package:tag_tweaker/widgets/favourites/client_name_dialog.dart';

class FavouritesController extends GetxController {
  /// Dependencies are injectable so the controller can run against
  /// `fake_cloud_firestore` and `firebase_auth_mocks` in tests.
  FavouritesController({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    QuotationRepository? quotations,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _quotationsOverride = quotations;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final QuotationRepository? _quotationsOverride;

  QuotationRepository get _quotations =>
      _quotationsOverride ?? Get.find<QuotationRepository>();

  // Map to store local price overrides: ProductID -> New Price
  final RxMap<String, String> modifiedPrices = <String, String>{}.obs;

  // Cached set of favourite product IDs for instant optimistic UI sync
  final RxSet<String> favouriteIds = <String>{}.obs;

  /// Quote-wide pricing rules (markup, tax, rounding), persisted per user.
  final Rx<PricingRules> pricingRules = const PricingRules().obs;

  StreamSubscription<User?>? _authSub;

  String? get currentUid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _favourites(String uid) =>
      _firestore.collection('users').doc(uid).collection('favourites');

  @override
  void onInit() {
    super.onInit();
    // The controller is created at app start, before login. Track auth state
    // so favourites load after sign-in and one user's favourites / tweaked
    // prices never leak into the next user's session.
    _authSub = _auth.authStateChanges().listen((user) {
      favouriteIds.clear();
      modifiedPrices.clear();
      pricingRules.value = const PricingRules();
      if (user != null) {
        loadFavourites();
        loadPricingRules();
      }
    });
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  /// Live stream of the signed-in user's favourite products.
  Stream<List<Product>> watchFavourites() {
    final uid = currentUid;
    if (uid == null) return Stream.value(const []);
    return _favourites(
      uid,
    ).snapshots().map((s) => s.docs.map(Product.fromSnapshot).toList());
  }

  Future<void> loadFavourites() async {
    final uid = currentUid;
    if (uid == null) return;

    try {
      final snapshot = await _favourites(uid).get();
      favouriteIds.assignAll(snapshot.docs.map((doc) => doc.id));
    } catch (e) {
      debugPrint('Error loading favourites: $e');
    }
  }

  Future<void> loadPricingRules() async {
    final uid = currentUid;
    if (uid == null) return;
    try {
      pricingRules.value = await _quotations.loadRules(uid);
    } catch (e) {
      debugPrint('Error loading pricing rules: $e');
    }
  }

  Future<void> updatePricingRules(PricingRules rules) async {
    final previous = pricingRules.value;
    pricingRules.value = rules;
    final uid = currentUid;
    if (uid == null) return;
    try {
      await _quotations.saveRules(uid, rules);
    } catch (e) {
      pricingRules.value = previous;
      CustomSnackbar.showError(
        title: 'ERROR',
        message: 'Could not save pricing rules',
      );
      debugPrint('updatePricingRules error: $e');
    }
  }

  bool isFavourite(String productId) => favouriteIds.contains(productId);

  Future<bool> toggleFavourite(Product product) async {
    final uid = currentUid;
    if (uid == null) {
      CustomSnackbar.showError(
        title: 'LOGIN REQUIRED',
        message: 'Please login to save favourites',
      );
      return false;
    }

    final isFav = isFavourite(product.id);
    final favRef = _favourites(uid).doc(product.id);

    // Optimistic local state update
    if (isFav) {
      favouriteIds.remove(product.id);
    } else {
      favouriteIds.add(product.id);
    }

    try {
      if (isFav) {
        await favRef.delete();
        modifiedPrices.remove(product.id);
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
        message: 'Error updating favourites',
      );
      debugPrint('toggleFavourite error: $e');
      return false;
    }
  }

  void updatePrice(String productId, String newPrice) {
    if (newPrice.trim().isEmpty) {
      modifiedPrices.remove(productId);
    } else {
      modifiedPrices[productId] = newPrice;
    }
  }

  /// Manual price typed for [productId], or [fallback] when there is none.
  String getPrice(String productId, String fallback) {
    return modifiedPrices[productId] ?? fallback;
  }

  /// Price a product would be quoted at under the current rules, ignoring
  /// any manual override.
  double rulePrice(Product product) => PricingEngine.applyRules(
    product.price,
    product.category,
    pricingRules.value,
  );

  /// Priced quote lines for [products] using the current rules and any
  /// manual price overrides.
  List<QuoteLine> buildQuoteLines(Iterable<Product> products) =>
      PricingEngine.buildLines(
        products,
        pricingRules.value,
        manualPrices: modifiedPrices,
      );

  QuoteTotals quoteTotals(Iterable<Product> products) =>
      PricingEngine.totals(buildQuoteLines(products), pricingRules.value);

  /// Builds a [Quotation] for [products] addressed to [clientName].
  Quotation buildQuotation(Iterable<Product> products, String clientName) {
    final rules = pricingRules.value;
    final lines = buildQuoteLines(products);
    return Quotation(
      clientName: clientName,
      createdAt: DateTime.now(),
      lines: lines,
      rules: rules,
      totals: PricingEngine.totals(lines, rules),
    );
  }

  /// Saves [quote] to the user's history. Returns the saved quotation (with
  /// its id), or null if saving failed.
  Future<Quotation?> saveQuotation(Quotation quote) async {
    final uid = currentUid;
    if (uid == null) return null;
    try {
      final id = await _quotations.save(uid, quote);
      return Quotation(
        id: id,
        clientName: quote.clientName,
        createdAt: quote.createdAt,
        lines: quote.lines,
        rules: quote.rules,
        totals: quote.totals,
      );
    } catch (e) {
      debugPrint('saveQuotation error: $e');
      return null;
    }
  }

  /// Asks for a client name, saves the quotation to history and opens the
  /// PDF preview.
  Future<void> generatePDF(BuildContext context) async {
    final uid = currentUid;
    if (uid == null) return;

    final snapshot = await _favourites(uid).get();

    if (snapshot.docs.isEmpty) {
      CustomSnackbar.showError(
        title: 'EMPTY CATALOG',
        message: 'No items in the catalog to generate PDF.',
      );
      return;
    }

    if (!context.mounted) return;
    final clientName = await ClientNameDialog.show(context);
    if (clientName == null) return;

    final products = snapshot.docs.map(Product.fromSnapshot).toList();
    final quote = buildQuotation(products, clientName);
    final saved = await saveQuotation(quote);
    if (saved == null) {
      CustomSnackbar.showError(
        title: 'NOT SAVED',
        message: 'Quotation could not be saved to history.',
      );
    }

    // Navigate immediately to the preview page
    unawaited(
      Get.to(
        () => const PdfPreviewPage(),
        binding: BindingsBuilder(() {
          Get.put(
            PdfPreviewController(
              pdfGenerator: () =>
                  CatalogPdfService.generateQuotationPdf(quote, products),
            ),
          );
        }),
      ),
    );
  }
}
