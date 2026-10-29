import 'package:pdf/widgets.dart' as pw;
import 'package:tag_tweaker/models/quotation.dart';
import 'package:tag_tweaker/utils/money.dart';
import 'package:tag_tweaker/widgets/pdf/neo_brutal_pdf_theme.dart';

/// Client block, priced line-item table and totals for a quotation PDF.
///
/// Returned as a flat list (not a Column) so `MultiPage` can split the line
/// table across pages for long quotations.
List<pw.Widget> buildQuotationSummaryPdf(Quotation quote) {
  return [
    _clientBlock(quote),
    pw.SizedBox(height: 24),
    _lineTable(quote.lines),
    pw.SizedBox(height: 16),
    _totals(quote),
    pw.SizedBox(height: 40),
  ];
}

pw.Widget _clientBlock(Quotation quote) {
  final d = quote.createdAt;
  final date =
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';
  return pw.Container(
    padding: const pw.EdgeInsets.all(16),
    decoration: NeoBrutalPdfTheme.brutalBox(
      color: NeoBrutalPdfColors.darkGrey,
      borderColor: NeoBrutalPdfColors.lime,
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _label('PREPARED FOR'),
            pw.SizedBox(height: 4),
            pw.Text(
              quote.clientName.isEmpty ? 'Walk-in client' : quote.clientName,
              style: const pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: NeoBrutalPdfColors.white,
              ),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            _label('DATE'),
            pw.SizedBox(height: 4),
            pw.Text(
              date,
              style: const pw.TextStyle(
                fontSize: 12,
                color: NeoBrutalPdfColors.white,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _lineTable(List<QuoteLine> lines) {
  const header = pw.TextStyle(
    fontSize: 9,
    fontWeight: pw.FontWeight.bold,
    color: NeoBrutalPdfColors.black,
  );
  const cell = pw.TextStyle(fontSize: 10, color: NeoBrutalPdfColors.white);

  return pw.TableHelper.fromTextArray(
    headers: const ['#', 'ITEM', 'QTY', 'UNIT (Rs.)', 'AMOUNT (Rs.)'],
    data: [
      for (var i = 0; i < lines.length; i++)
        [
          '${i + 1}',
          lines[i].title,
          '${lines[i].quantity}',
          formatMoney(lines[i].unitPrice),
          formatMoney(lines[i].lineTotal),
        ],
    ],
    headerStyle: header,
    headerDecoration: const pw.BoxDecoration(color: NeoBrutalPdfColors.lime),
    cellStyle: cell,
    border: pw.TableBorder.all(color: NeoBrutalPdfColors.lightGrey, width: 0.5),
    columnWidths: const {
      0: pw.FixedColumnWidth(24),
      1: pw.FlexColumnWidth(5),
      2: pw.FixedColumnWidth(36),
      3: pw.FlexColumnWidth(2),
      4: pw.FlexColumnWidth(2),
    },
    cellAlignments: const {
      0: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
    },
    cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
  );
}

pw.Widget _totals(Quotation quote) {
  final t = quote.totals;
  return pw.Align(
    alignment: pw.Alignment.centerRight,
    child: pw.SizedBox(
      width: 220,
      child: pw.Column(
        children: [
          _totalRow('SUBTOTAL', t.subtotal),
          if (t.taxPercent > 0)
            _totalRow('TAX (${_pct(t.taxPercent)}%)', t.tax),
          pw.Divider(color: NeoBrutalPdfColors.white, thickness: 1),
          _totalRow('TOTAL', t.total, emphasise: true),
        ],
      ),
    ),
  );
}

pw.Widget _totalRow(String label, double value, {bool emphasise = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: emphasise ? 12 : 10,
            fontWeight: pw.FontWeight.bold,
            color: NeoBrutalPdfColors.white,
          ),
        ),
        pw.Text(
          'Rs. ${formatMoney(value)}',
          style: pw.TextStyle(
            fontSize: emphasise ? 16 : 10,
            fontWeight: pw.FontWeight.bold,
            color: emphasise
                ? NeoBrutalPdfColors.lime
                : NeoBrutalPdfColors.white,
          ),
        ),
      ],
    ),
  );
}

pw.Widget _label(String text) => pw.Text(
  text,
  style: const pw.TextStyle(
    fontSize: 8,
    letterSpacing: 2,
    fontWeight: pw.FontWeight.bold,
    color: NeoBrutalPdfColors.lime,
  ),
);

String _pct(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
