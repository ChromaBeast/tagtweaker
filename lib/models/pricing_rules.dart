/// How computed unit prices are rounded before they are quoted.
enum PriceRounding {
  /// Keep two decimal places.
  none,

  /// Round to the nearest whole rupee.
  nearestOne,

  /// Round to the nearest ten.
  nearestTen,

  /// Charm pricing: round up to the next price ending in 9 (1234 -> 1239).
  endingIn9,
}

/// Quote-wide pricing rules a merchant applies on top of catalog prices.
///
/// Rules never touch the central catalog; they only shape the prices on a
/// client quotation. A manual per-item price always wins over these rules.
class PricingRules {
  /// Percentage added to every base price. Negative values act as a discount.
  final double markupPercent;

  /// Per-category markup that replaces [markupPercent] for that category.
  final Map<String, double> categoryMarkupPercent;

  /// Tax (e.g. GST) added on top of the quotation subtotal.
  final double taxPercent;

  final PriceRounding rounding;

  const PricingRules({
    this.markupPercent = 0,
    this.categoryMarkupPercent = const {},
    this.taxPercent = 0,
    this.rounding = PriceRounding.none,
  });

  /// Markup that applies to products in [category].
  double markupFor(String category) =>
      categoryMarkupPercent[category] ?? markupPercent;

  bool get isIdentity =>
      markupPercent == 0 &&
      categoryMarkupPercent.values.every((v) => v == 0) &&
      taxPercent == 0 &&
      rounding == PriceRounding.none;

  PricingRules copyWith({
    double? markupPercent,
    Map<String, double>? categoryMarkupPercent,
    double? taxPercent,
    PriceRounding? rounding,
  }) {
    return PricingRules(
      markupPercent: markupPercent ?? this.markupPercent,
      categoryMarkupPercent:
          categoryMarkupPercent ?? this.categoryMarkupPercent,
      taxPercent: taxPercent ?? this.taxPercent,
      rounding: rounding ?? this.rounding,
    );
  }

  Map<String, dynamic> toMap() => {
    'markupPercent': markupPercent,
    'categoryMarkupPercent': categoryMarkupPercent,
    'taxPercent': taxPercent,
    'rounding': rounding.name,
  };

  factory PricingRules.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const PricingRules();
    final categories = map['categoryMarkupPercent'];
    return PricingRules(
      markupPercent: _toDouble(map['markupPercent']),
      categoryMarkupPercent: categories is Map
          ? {
              for (final e in categories.entries)
                e.key.toString(): _toDouble(e.value),
            }
          : const {},
      taxPercent: _toDouble(map['taxPercent']),
      rounding: PriceRounding.values.firstWhere(
        (r) => r.name == map['rounding'],
        orElse: () => PriceRounding.none,
      ),
    );
  }

  static double _toDouble(Object? v) =>
      v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '') ?? 0;

  @override
  bool operator ==(Object other) =>
      other is PricingRules &&
      other.markupPercent == markupPercent &&
      other.taxPercent == taxPercent &&
      other.rounding == rounding &&
      other.categoryMarkupPercent.length == categoryMarkupPercent.length &&
      other.categoryMarkupPercent.entries.every(
        (e) => categoryMarkupPercent[e.key] == e.value,
      );

  @override
  int get hashCode => Object.hash(
    markupPercent,
    taxPercent,
    rounding,
    Object.hashAllUnordered(
      categoryMarkupPercent.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );
}
