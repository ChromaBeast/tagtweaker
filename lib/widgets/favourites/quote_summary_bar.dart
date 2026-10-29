import 'package:flutter/material.dart';
import 'package:tag_tweaker/models/quotation.dart';
import 'package:tag_tweaker/themes/neo_brutal_theme.dart';
import 'package:tag_tweaker/utils/money.dart';

/// Live subtotal / tax / total strip for the quote being built.
class QuoteSummaryBar extends StatelessWidget {
  final int itemCount;
  final QuoteTotals totals;

  const QuoteSummaryBar({
    super.key,
    required this.itemCount,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: NeoBrutalTheme.brutalBox(
        color: NeoBrutalColors.black,
        borderColor: NeoBrutalColors.lime,
        shadowColor: NeoBrutalColors.lime,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$itemCount ${itemCount == 1 ? 'ITEM' : 'ITEMS'} IN QUOTE',
            style: NeoBrutalTheme.mono.copyWith(fontSize: 11, letterSpacing: 2),
          ),
          const SizedBox(height: 12),
          _row('SUBTOTAL', totals.subtotal),
          if (totals.taxPercent > 0)
            _row('TAX (${_pct(totals.taxPercent)}%)', totals.tax),
          const Divider(color: NeoBrutalColors.lightGrey, height: 20),
          _row('TOTAL', totals.total, emphasise: true),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool emphasise = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: NeoBrutalTheme.heading.copyWith(
              fontSize: emphasise ? 16 : 13,
            ),
          ),
          Text(
            '₹${formatMoney(value)}',
            style: NeoBrutalTheme.mono.copyWith(
              fontSize: emphasise ? 20 : 13,
              color: emphasise ? NeoBrutalColors.lime : NeoBrutalColors.white,
            ),
          ),
        ],
      ),
    );
  }

  static String _pct(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
}
