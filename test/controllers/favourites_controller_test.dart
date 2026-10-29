import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/controllers/favourites_controller.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/services/quotation_repository.dart';

import '../helpers/fixtures.dart';

void main() {
  late FakeFirebaseFirestore db;
  late MockFirebaseAuth auth;
  late FavouritesController controller;

  FavouritesController build() => FavouritesController(
    auth: auth,
    firestore: db,
    quotations: QuotationRepository(firestore: db),
  );

  setUp(() async {
    Get.testMode = true;
    db = FakeFirebaseFirestore();
    auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'alice'));
    await db
        .collection('users')
        .doc('alice')
        .collection('favourites')
        .doc('p1')
        .set(makeProduct(id: 'p1').toMap());
    controller = build();
  });

  tearDown(Get.reset);

  test('loads favourites for the signed-in user', () async {
    await controller.loadFavourites();
    expect(controller.isFavourite('p1'), isTrue);
    expect(controller.isFavourite('p2'), isFalse);
  });

  test('watchFavourites streams the user collection', () async {
    final products = await controller.watchFavourites().first;
    expect(products.map((p) => p.id), ['p1']);
  });

  test('updatePrice stores and clears manual overrides', () {
    controller.updatePrice('p1', '799');
    expect(controller.getPrice('p1', ''), '799');
    controller.updatePrice('p1', '   ');
    expect(controller.getPrice('p1', 'fallback'), 'fallback');
  });

  test('quote lines combine rules and manual overrides', () {
    controller.pricingRules.value = const PricingRules(
      markupPercent: 10,
      taxPercent: 18,
    );
    controller.updatePrice('p2', '500');

    final products = [
      makeProduct(id: 'p1', price: 1000),
      makeProduct(id: 'p2', price: 900),
    ];
    final lines = controller.buildQuoteLines(products);
    expect(lines.map((l) => l.unitPrice), [1100, 500]);

    final totals = controller.quoteTotals(products);
    expect(totals.subtotal, 1600);
    expect(totals.total, 1888);
  });

  test('pricing rules persist and reload per user', () async {
    const rules = PricingRules(markupPercent: 25);
    await controller.updatePricingRules(rules);

    final fresh = build();
    await fresh.loadPricingRules();
    expect(fresh.pricingRules.value, rules);
  });

  test('saveQuotation writes to history and returns the id', () async {
    final quote = controller.buildQuotation([makeProduct()], 'Acme');
    final saved = await controller.saveQuotation(quote);

    expect(saved?.id, isNotNull);
    final docs = await db
        .collection('users')
        .doc('alice')
        .collection('quotations')
        .get();
    expect(docs.docs.single.data()['clientName'], 'Acme');
  });

  test('saveQuotation returns null when signed out', () async {
    await auth.signOut();
    final quote = controller.buildQuotation([makeProduct()], 'Acme');
    expect(await controller.saveQuotation(quote), isNull);
  });

  testWidgets('toggleFavourite adds and removes with optimistic state', (
    tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: SizedBox()));

    final product = makeProduct(id: 'p2');
    final favs = db.collection('users').doc('alice').collection('favourites');

    await tester.runAsync(() => controller.toggleFavourite(product));
    expect(controller.isFavourite('p2'), isTrue);
    expect((await tester.runAsync(() => favs.doc('p2').get()))!.exists, true);

    controller.updatePrice('p2', '10');
    await tester.runAsync(() => controller.toggleFavourite(product));
    expect(controller.isFavourite('p2'), isFalse);
    expect(controller.getPrice('p2', 'none'), 'none');
    expect((await tester.runAsync(() => favs.doc('p2').get()))!.exists, false);

    // Let snackbar timers finish.
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  test('signing out clears per-user state', () async {
    controller.onInit();
    controller.updatePrice('p1', '1');
    controller.pricingRules.value = const PricingRules(markupPercent: 5);

    await auth.signOut();
    await Future<void>.delayed(Duration.zero);

    expect(controller.modifiedPrices, isEmpty);
    expect(controller.favouriteIds, isEmpty);
    expect(controller.pricingRules.value, const PricingRules());
    controller.onClose();
  });
}
