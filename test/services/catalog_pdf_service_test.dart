import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/models/quotation.dart';
import 'package:tag_tweaker/services/catalog_pdf_service.dart';
import 'package:tag_tweaker/services/pricing_engine.dart';

import '../helpers/fixtures.dart';

void main() {
  bool isPdf(List<int> bytes) =>
      bytes.length > 1000 && ascii.decode(bytes.sublist(0, 5)) == '%PDF-';

  group('CatalogPdfService.buildDocument', () {
    test('renders a catalog of several products', () async {
      final bytes = await CatalogPdfService.buildDocument(
        items: [
          makeProduct(id: 'a', title: 'Item A'),
          makeProduct(id: 'b', title: 'Item B'),
        ],
      );
      expect(isPdf(bytes), isTrue);
    });

    test('renders a quotation with a summary table', () async {
      const rules = PricingRules(taxPercent: 18);
      final products = [makeProduct(id: 'a'), makeProduct(id: 'b')];
      final lines = PricingEngine.buildLines(products, rules);
      final quote = Quotation(
        clientName: 'Acme Retail',
        createdAt: DateTime(2026, 10, 1),
        lines: lines,
        rules: rules,
        totals: PricingEngine.totals(lines, rules),
      );

      final withProducts = await CatalogPdfService.buildDocument(
        items: products,
        quotation: quote,
      );
      final summaryOnly = await CatalogPdfService.buildDocument(
        items: const [],
        quotation: quote,
      );

      expect(isPdf(withProducts), isTrue);
      expect(isPdf(summaryOnly), isTrue);
      expect(withProducts.length, greaterThan(summaryOnly.length));
    });

    test('a long quotation paginates instead of overflowing', () async {
      final products = [
        for (var i = 0; i < 120; i++) makeProduct(id: '$i', title: 'Item $i'),
      ];
      final lines = PricingEngine.buildLines(products, const PricingRules());
      final quote = Quotation(
        clientName: '',
        createdAt: DateTime(2026),
        lines: lines,
        rules: const PricingRules(),
        totals: PricingEngine.totals(lines, const PricingRules()),
      );

      final bytes = await CatalogPdfService.buildDocument(
        items: const [],
        quotation: quote,
      );
      expect(isPdf(bytes), isTrue);
    });
  });
}
