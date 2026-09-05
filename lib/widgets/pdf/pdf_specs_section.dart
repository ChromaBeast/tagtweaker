import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/product_model.dart';
import 'neo_brutal_pdf_theme.dart';

/// Specifications table section for product PDF
pw.Widget buildPdfSpecsSection(Product product) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'SPECIFICATIONS',
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: NeoBrutalPdfColors.lime,
          letterSpacing: 1,
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            top: pw.BorderSide(color: NeoBrutalPdfColors.white, width: 2),
            bottom: pw.BorderSide(color: NeoBrutalPdfColors.white, width: 2),
          ),
        ),
        child: pw.Column(
          children: [
            buildPdfSpecRow('Product ID', '#${product.id}', NeoBrutalPdfColors.lime),
            buildPdfSpecRow('Category', product.category, NeoBrutalPdfColors.white),
            buildPdfSpecRow('Brand', product.brand, NeoBrutalPdfColors.lime),
          ],
        ),
      ),
    ],
  );
}

pw.Widget buildPdfSpecRow(String label, String value, PdfColor valueColor) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 12),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: NeoBrutalPdfColors.mediumGrey, width: 0.5),
      ),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: NeoBrutalPdfColors.white)),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    ),
  );
}
