import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/models/quotation.dart';

/// Pure pricing logic for client quotations. No Flutter or Firebase
/// dependencies, so every rule is unit-testable in isolation.
class PricingEngine {
  const PricingEngine._();

  /// Applies the category-aware markup and rounding in [rules] to [basePrice].
  static double applyRules(
    double basePrice,
    String category,
    PricingRules rules,
  ) {
    final marked = basePrice * (1 + rules.markupFor(category) / 100);
    return round(marked < 0 ? 0 : marked, rules.rounding);
  }

  static double round(double value, PriceRounding mode) {
    switch (mode) {
      case PriceRounding.none:
        return (value * 100).roundToDouble() / 100;
      case PriceRounding.nearestOne:
        return value.roundToDouble();
      case PriceRounding.nearestTen:
        return (value / 10).roundToDouble() * 10;
      case PriceRounding.endingIn9:
        if (value <= 0) return 0;
        // Round up to the next value ending in 9 (1230 -> 1239, 1239 -> 1239).
        return ((value + 1) / 10).ceilToDouble() * 10 - 1;
    }
  }

  /// Prices [product] for a quote. A [manualPrice] typed by the merchant
  /// is final and bypasses [rules].
  static QuoteLine priceProduct(
    Product product,
    PricingRules rules, {
    double? manualPrice,
    int quantity = 1,
  }) {
    final isManual = manualPrice != null;
    return QuoteLine(
      productId: product.id,
      title: product.title,
      category: product.category,
      thumbnail: product.thumbnail,
      basePrice: product.price,
      unitPrice: isManual
          ? manualPrice
          : applyRules(product.price, product.category, rules),
      quantity: quantity < 1 ? 1 : quantity,
      isManualPrice: isManual,
    );
  }

  /// Builds quote lines for [products], using [manualPrices] (productId ->
  /// raw user input) where a valid override exists.
  static List<QuoteLine> buildLines(
    Iterable<Product> products,
    PricingRules rules, {
    Map<String, String> manualPrices = const {},
  }) {
    return products
        .map(
          (p) => priceProduct(
            p,
            rules,
            manualPrice: parsePrice(manualPrices[p.id]),
          ),
        )
        .toList();
  }

  static QuoteTotals totals(List<QuoteLine> lines, PricingRules rules) {
    final subtotal = lines.fold<double>(0, (sum, l) => sum + l.lineTotal);
    final tax = _money(subtotal * rules.taxPercent / 100);
    return QuoteTotals(
      subtotal: _money(subtotal),
      taxPercent: rules.taxPercent,
      tax: tax,
      total: _money(subtotal + tax),
    );
  }

  /// Parses merchant price input such as `"1,299.50"` or `" 499 "`.
  /// Returns null for empty, malformed, negative or non-finite input.
  static double? parsePrice(String? raw) {
    if (raw == null) return null;
    final cleaned = raw.replaceAll(',', '').replaceAll('₹', '').trim();
    if (cleaned.isEmpty) return null;
    final value = double.tryParse(cleaned);
    if (value == null || !value.isFinite || value < 0) return null;
    return value;
  }

  static double _money(double v) => (v * 100).roundToDouble() / 100;
}
