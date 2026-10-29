import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';

void main() {
  group('PricingRules', () {
    const rules = PricingRules(
      markupPercent: 12.5,
      categoryMarkupPercent: {'Laptop': 5},
      taxPercent: 18,
      rounding: PriceRounding.endingIn9,
    );

    test('round-trips through a map', () {
      expect(PricingRules.fromMap(rules.toMap()), rules);
    });

    test('fromMap tolerates missing, null and stringly-typed fields', () {
      expect(PricingRules.fromMap(null), const PricingRules());
      expect(
        PricingRules.fromMap({
          'markupPercent': '10',
          'taxPercent': 5,
          'rounding': 'unknown-mode',
          'categoryMarkupPercent': 'not a map',
        }),
        const PricingRules(markupPercent: 10, taxPercent: 5),
      );
    });

    test('markupFor falls back to the global markup', () {
      expect(rules.markupFor('Laptop'), 5);
      expect(rules.markupFor('Audio'), 12.5);
    });

    test('isIdentity', () {
      expect(const PricingRules().isIdentity, isTrue);
      expect(rules.isIdentity, isFalse);
    });

    test('equal rules have equal hash codes', () {
      final copy = PricingRules.fromMap(rules.toMap());
      expect(copy.hashCode, rules.hashCode);
    });
  });
}
