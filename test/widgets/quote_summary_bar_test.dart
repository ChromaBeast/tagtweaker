import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tag_tweaker/models/quotation.dart';
import 'package:tag_tweaker/widgets/favourites/quote_summary_bar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows subtotal, tax and total', (tester) async {
    await tester.pumpWidget(
      wrap(
        const QuoteSummaryBar(
          itemCount: 2,
          totals: QuoteTotals(
            subtotal: 150000,
            taxPercent: 18,
            tax: 27000,
            total: 177000,
          ),
        ),
      ),
    );

    expect(find.text('2 ITEMS IN QUOTE'), findsOneWidget);
    expect(find.text('₹1,50,000'), findsOneWidget);
    expect(find.text('TAX (18%)'), findsOneWidget);
    expect(find.text('₹27,000'), findsOneWidget);
    expect(find.text('₹1,77,000'), findsOneWidget);
  });

  testWidgets('hides the tax row when no tax applies', (tester) async {
    await tester.pumpWidget(
      wrap(
        const QuoteSummaryBar(
          itemCount: 1,
          totals: QuoteTotals(subtotal: 999, taxPercent: 0, tax: 0, total: 999),
        ),
      ),
    );

    expect(find.text('1 ITEM IN QUOTE'), findsOneWidget);
    expect(find.textContaining('TAX'), findsNothing);
  });
}
