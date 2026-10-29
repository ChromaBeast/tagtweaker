import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/models/quotation.dart';
import 'package:tag_tweaker/services/pricing_engine.dart';

import '../helpers/fixtures.dart';

void main() {
  group('Quotation', () {
    const rules = PricingRules(markupPercent: 10, taxPercent: 18);
    final lines = PricingEngine.buildLines(
      [
        makeProduct(id: 'a', price: 1000),
        makeProduct(id: 'b', price: 200, category: 'Accessories'),
      ],
      rules,
      manualPrices: {'b': '250'},
    );
    final quote = Quotation(
      clientName: 'Acme Retail',
      createdAt: DateTime.utc(2026, 10, 1, 12),
      lines: lines,
      rules: rules,
      totals: PricingEngine.totals(lines, rules),
    );

    test('round-trips through a Firestore map', () {
      final restored = Quotation.fromMap(quote.toMap(), id: 'q1');

      expect(restored.id, 'q1');
      expect(restored.clientName, 'Acme Retail');
      expect(restored.createdAt.isAtSameMomentAs(quote.createdAt), isTrue);
      expect(restored.rules, rules);
      expect(restored.lines.map((l) => l.unitPrice), [1100, 250]);
      expect(restored.lines.last.isManualPrice, isTrue);
      expect(restored.totals.subtotal, 1350);
      expect(restored.totals.tax, 243);
      expect(restored.totals.total, 1593);
    });

    test('stores createdAt as a Timestamp and a denormalised itemCount', () {
      final map = quote.toMap();
      expect(map['createdAt'], isA<Timestamp>());
      expect(map['itemCount'], 2);
    });

    test('fromMap tolerates a malformed document', () {
      final restored = Quotation.fromMap({
        'lines': ['garbage', 42],
      });
      expect(restored.clientName, '');
      expect(restored.lines, isEmpty);
      expect(restored.totals.total, 0);
      expect(restored.rules, const PricingRules());
    });
  });
}
