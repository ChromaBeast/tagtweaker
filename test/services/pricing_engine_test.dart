import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/services/pricing_engine.dart';

import '../helpers/fixtures.dart';

void main() {
  group('PricingEngine.applyRules', () {
    test('identity rules leave the price unchanged', () {
      expect(
        PricingEngine.applyRules(1234.5, 'Audio', const PricingRules()),
        1234.5,
      );
    });

    test('applies global markup and discount', () {
      expect(
        PricingEngine.applyRules(
          1000,
          'Audio',
          const PricingRules(markupPercent: 15),
        ),
        1150,
      );
      expect(
        PricingEngine.applyRules(
          1000,
          'Audio',
          const PricingRules(markupPercent: -10),
        ),
        900,
      );
    });

    test('category markup overrides the global markup', () {
      const rules = PricingRules(
        markupPercent: 10,
        categoryMarkupPercent: {'Laptop': 5},
      );
      expect(PricingEngine.applyRules(1000, 'Laptop', rules), 1050);
      expect(PricingEngine.applyRules(1000, 'Audio', rules), 1100);
    });

    test('never produces a negative price', () {
      expect(
        PricingEngine.applyRules(
          100,
          'Audio',
          const PricingRules(markupPercent: -150),
        ),
        0,
      );
    });
  });

  group('PricingEngine.round', () {
    test('none keeps two decimals', () {
      expect(PricingEngine.round(10.006, PriceRounding.none), 10.01);
    });

    test('nearestOne and nearestTen', () {
      expect(PricingEngine.round(1234.5, PriceRounding.nearestOne), 1235);
      expect(PricingEngine.round(1234, PriceRounding.nearestTen), 1230);
      expect(PricingEngine.round(1235, PriceRounding.nearestTen), 1240);
    });

    test('endingIn9 rounds up to the next price ending in 9', () {
      expect(PricingEngine.round(1230, PriceRounding.endingIn9), 1239);
      expect(PricingEngine.round(1239, PriceRounding.endingIn9), 1239);
      expect(PricingEngine.round(1239.5, PriceRounding.endingIn9), 1249);
      expect(PricingEngine.round(1240, PriceRounding.endingIn9), 1249);
      expect(PricingEngine.round(0, PriceRounding.endingIn9), 0);
    });
  });

  group('PricingEngine.priceProduct', () {
    const rules = PricingRules(markupPercent: 20);

    test('derives unit price from rules', () {
      final line = PricingEngine.priceProduct(makeProduct(price: 500), rules);
      expect(line.unitPrice, 600);
      expect(line.basePrice, 500);
      expect(line.isManualPrice, isFalse);
    });

    test('manual price wins over rules', () {
      final line = PricingEngine.priceProduct(
        makeProduct(price: 500),
        rules,
        manualPrice: 450,
      );
      expect(line.unitPrice, 450);
      expect(line.isManualPrice, isTrue);
    });

    test('quantity is clamped to at least one', () {
      final line = PricingEngine.priceProduct(
        makeProduct(price: 500),
        rules,
        quantity: 0,
      );
      expect(line.quantity, 1);
    });
  });

  group('PricingEngine.buildLines', () {
    test('uses valid overrides and ignores malformed ones', () {
      final lines = PricingEngine.buildLines(
        [
          makeProduct(id: 'a', price: 100),
          makeProduct(id: 'b', price: 200),
          makeProduct(id: 'c', price: 300),
        ],
        const PricingRules(markupPercent: 10),
        manualPrices: {'a': '1,050', 'b': 'abc'},
      );

      expect(lines.map((l) => l.unitPrice), [1050, 220, 330]);
      expect(lines.map((l) => l.isManualPrice), [true, false, false]);
    });
  });

  group('PricingEngine.totals', () {
    test('sums line totals and adds tax', () {
      final lines = PricingEngine.buildLines([
        makeProduct(id: 'a', price: 1000),
        makeProduct(id: 'b', price: 500),
      ], const PricingRules());

      final totals = PricingEngine.totals(
        lines,
        const PricingRules(taxPercent: 18),
      );
      expect(totals.subtotal, 1500);
      expect(totals.tax, 270);
      expect(totals.total, 1770);
      expect(totals.taxPercent, 18);
    });

    test('empty quote totals to zero', () {
      final totals = PricingEngine.totals(const [], const PricingRules());
      expect(totals.total, 0);
    });

    test('rounds tax to paise', () {
      final lines = PricingEngine.buildLines([
        makeProduct(price: 99.99),
      ], const PricingRules());
      final totals = PricingEngine.totals(
        lines,
        const PricingRules(taxPercent: 12.5),
      );
      expect(totals.tax, 12.5);
      expect(totals.total, 112.49);
    });
  });

  group('PricingEngine.parsePrice', () {
    test('accepts formatted input', () {
      expect(PricingEngine.parsePrice('1,299.50'), 1299.5);
      expect(PricingEngine.parsePrice(' ₹499 '), 499);
      expect(PricingEngine.parsePrice('0'), 0);
    });

    test('rejects empty, malformed, negative and non-finite input', () {
      expect(PricingEngine.parsePrice(null), isNull);
      expect(PricingEngine.parsePrice('   '), isNull);
      expect(PricingEngine.parsePrice('12abc'), isNull);
      expect(PricingEngine.parsePrice('-5'), isNull);
      expect(PricingEngine.parsePrice('Infinity'), isNull);
      expect(PricingEngine.parsePrice('NaN'), isNull);
    });
  });
}
