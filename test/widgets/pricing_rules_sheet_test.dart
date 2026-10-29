import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/widgets/favourites/pricing_rules_sheet.dart';

void main() {
  Future<PricingRules?> openAndApply(
    WidgetTester tester, {
    PricingRules initial = const PricingRules(),
    String? markup,
    String? tax,
    String? rounding,
  }) async {
    PricingRules? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async =>
                result = await PricingRulesSheet.show(context, initial),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    if (markup != null) {
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('markupField')),
          matching: find.byType(TextField),
        ),
        markup,
      );
    }
    if (tax != null) {
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('taxField')),
          matching: find.byType(TextField),
        ),
        tax,
      );
    }
    if (rounding != null) await tester.tap(find.text(rounding));
    await tester.pump();

    await tester.tap(find.byKey(const Key('applyRules')));
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('returns the edited rules', (tester) async {
    final rules = await openAndApply(
      tester,
      markup: '15',
      tax: '18',
      rounding: '₹10',
    );
    expect(
      rules,
      const PricingRules(
        markupPercent: 15,
        taxPercent: 18,
        rounding: PriceRounding.nearestTen,
      ),
    );
  });

  testWidgets('accepts a negative markup as a discount', (tester) async {
    final rules = await openAndApply(tester, markup: '-10');
    expect(rules?.markupPercent, -10);
  });

  testWidgets('clamps out-of-range values', (tester) async {
    final rules = await openAndApply(tester, markup: '9999', tax: '250');
    expect(rules?.markupPercent, 500);
    expect(rules?.taxPercent, 100);
  });

  testWidgets('keeps category markups from the initial rules', (tester) async {
    final rules = await openAndApply(
      tester,
      initial: const PricingRules(categoryMarkupPercent: {'Laptop': 5}),
      markup: '10',
    );
    expect(rules?.categoryMarkupPercent, {'Laptop': 5});
  });
}
