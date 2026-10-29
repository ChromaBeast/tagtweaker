import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';

/// A single priced product on a client quotation.
///
/// Lines are snapshots: they keep the price that was quoted even if the
/// catalog price changes later.
class QuoteLine {
  final String productId;
  final String title;
  final String category;
  final String thumbnail;

  /// Catalog price at the time the quote was built.
  final double basePrice;

  /// Final per-unit price quoted to the client (after rules or override).
  final double unitPrice;
  final int quantity;

  /// Whether [unitPrice] was typed in by the merchant instead of derived
  /// from [PricingRules].
  final bool isManualPrice;

  const QuoteLine({
    required this.productId,
    required this.title,
    required this.category,
    required this.thumbnail,
    required this.basePrice,
    required this.unitPrice,
    this.quantity = 1,
    this.isManualPrice = false,
  });

  double get lineTotal => unitPrice * quantity;

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'title': title,
    'category': category,
    'thumbnail': thumbnail,
    'basePrice': basePrice,
    'unitPrice': unitPrice,
    'quantity': quantity,
    'isManualPrice': isManualPrice,
  };

  factory QuoteLine.fromMap(Map<String, dynamic> map) => QuoteLine(
    productId: map['productId']?.toString() ?? '',
    title: map['title']?.toString() ?? 'Unknown',
    category: map['category']?.toString() ?? 'General',
    thumbnail: map['thumbnail']?.toString() ?? '',
    basePrice: (map['basePrice'] as num?)?.toDouble() ?? 0,
    unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0,
    quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    isManualPrice: map['isManualPrice'] == true,
  );
}

/// Subtotal, tax and grand total of a set of quote lines.
class QuoteTotals {
  final double subtotal;
  final double taxPercent;
  final double tax;
  final double total;

  const QuoteTotals({
    required this.subtotal,
    required this.taxPercent,
    required this.tax,
    required this.total,
  });
}

/// A saved client quotation: priced lines plus the rules used to price them.
class Quotation {
  /// Firestore document id; null until the quotation is saved.
  final String? id;
  final String clientName;
  final DateTime createdAt;
  final List<QuoteLine> lines;
  final PricingRules rules;
  final QuoteTotals totals;

  const Quotation({
    this.id,
    required this.clientName,
    required this.createdAt,
    required this.lines,
    required this.rules,
    required this.totals,
  });

  int get itemCount => lines.fold(0, (total, l) => total + l.quantity);

  Map<String, dynamic> toMap() => {
    'clientName': clientName,
    'createdAt': Timestamp.fromDate(createdAt),
    'lines': lines.map((l) => l.toMap()).toList(),
    'rules': rules.toMap(),
    'subtotal': totals.subtotal,
    'taxPercent': totals.taxPercent,
    'tax': totals.tax,
    'total': totals.total,
    'itemCount': itemCount,
  };

  factory Quotation.fromMap(Map<String, dynamic> map, {String? id}) {
    final created = map['createdAt'];
    return Quotation(
      id: id,
      clientName: map['clientName']?.toString() ?? '',
      createdAt: created is Timestamp
          ? created.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      lines: (map['lines'] as List<dynamic>? ?? const [])
          .whereType<Map<Object?, Object?>>()
          .map((m) => QuoteLine.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
      rules: PricingRules.fromMap(
        map['rules'] is Map
            ? Map<String, dynamic>.from(map['rules'] as Map)
            : null,
      ),
      totals: QuoteTotals(
        subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
        taxPercent: (map['taxPercent'] as num?)?.toDouble() ?? 0,
        tax: (map['tax'] as num?)?.toDouble() ?? 0,
        total: (map['total'] as num?)?.toDouble() ?? 0,
      ),
    );
  }

  factory Quotation.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Quotation.fromMap(doc.data() ?? const {}, id: doc.id);
}
