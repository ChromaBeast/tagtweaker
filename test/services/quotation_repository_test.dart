import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/models/quotation.dart';
import 'package:tag_tweaker/services/pricing_engine.dart';
import 'package:tag_tweaker/services/quotation_repository.dart';

import '../helpers/fixtures.dart';

Quotation _quote(String client, DateTime at) {
  final lines = PricingEngine.buildLines([
    makeProduct(price: 100),
  ], const PricingRules());
  return Quotation(
    clientName: client,
    createdAt: at,
    lines: lines,
    rules: const PricingRules(),
    totals: PricingEngine.totals(lines, const PricingRules()),
  );
}

void main() {
  late FakeFirebaseFirestore db;
  late QuotationRepository repo;

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = QuotationRepository(firestore: db);
  });

  test('saves quotations under the owner and streams newest first', () async {
    await repo.save('alice', _quote('Old', DateTime(2026, 1, 1)));
    await repo.save('alice', _quote('New', DateTime(2026, 2, 1)));
    await repo.save('bob', _quote('Other user', DateTime(2026, 3, 1)));

    final quotes = await repo.watch('alice').first;
    expect(quotes.map((q) => q.clientName), ['New', 'Old']);
    expect(quotes.every((q) => q.id != null), isTrue);
  });

  test('delete removes a quotation', () async {
    final id = await repo.save('alice', _quote('Acme', DateTime(2026)));
    await repo.delete('alice', id);
    expect(await repo.watch('alice').first, isEmpty);
  });

  test('pricing rules default to identity and persist', () async {
    expect(await repo.loadRules('alice'), const PricingRules());

    const rules = PricingRules(
      markupPercent: 15,
      taxPercent: 18,
      rounding: PriceRounding.nearestTen,
    );
    await repo.saveRules('alice', rules);
    expect(await repo.loadRules('alice'), rules);
    expect(await repo.loadRules('bob'), const PricingRules());
  });
}
