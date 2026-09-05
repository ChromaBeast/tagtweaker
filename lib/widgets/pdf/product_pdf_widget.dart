import 'package:pdf/widgets.dart' as pw;
import '../../models/product_model.dart';
import 'neo_brutal_pdf_theme.dart';
import 'pdf_specs_section.dart';

/// PDF builder widget for individual product catalog pages
pw.Widget buildProductPdfWidget(Product product, pw.MemoryImage? image) {
  return pw.Column(
    children: [
      _buildHeroSection(product, image),
      pw.SizedBox(height: 40),
      buildPdfSpecsSection(product),
      pw.SizedBox(height: 40),
      _buildDescriptionSection(product),
      pw.SizedBox(height: 40),
      pw.Divider(color: NeoBrutalPdfColors.white, thickness: 0.5),
      pw.SizedBox(height: 40),
    ],
  );
}

pw.Widget _buildHeroSection(Product product, pw.MemoryImage? image) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        flex: 3,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: NeoBrutalPdfTheme.brutalBox(
                color: NeoBrutalPdfColors.lime,
                borderColor: NeoBrutalPdfColors.black,
                borderWidth: 2,
              ),
              child: pw.Text(
                product.brand.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: NeoBrutalPdfColors.black,
                  letterSpacing: 1,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              product.title,
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: NeoBrutalPdfColors.white,
                lineSpacing: 1.2,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Rs. ${product.price.toStringAsFixed(0)}',
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                    color: NeoBrutalPdfColors.lime,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            if (product.rating > 0)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: NeoBrutalPdfTheme.brutalBox(
                  color: NeoBrutalPdfColors.darkGrey,
                  borderColor: NeoBrutalPdfColors.white,
                ),
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      'RATING',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: NeoBrutalPdfColors.white,
                      ),
                    ),
                    pw.SizedBox(width: 6),
                    pw.Text(
                      '${product.rating}/5',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: NeoBrutalPdfColors.lime,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      pw.SizedBox(width: 20),
      pw.Expanded(
        flex: 2,
        child: pw.Container(
          height: 200,
          decoration: NeoBrutalPdfTheme.brutalBox(
            color: NeoBrutalPdfColors.darkGrey,
            borderColor: NeoBrutalPdfColors.white,
          ),
          child: image != null
              ? pw.ClipRect(child: pw.Image(image, fit: pw.BoxFit.contain))
              : pw.Center(
                  child: pw.Text(
                    'No Image',
                    style: const pw.TextStyle(color: NeoBrutalPdfColors.lightGrey),
                  ),
                ),
        ),
      ),
    ],
  );
}

pw.Widget _buildDescriptionSection(Product product) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'ABOUT THIS PRODUCT',
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: NeoBrutalPdfColors.lime,
          letterSpacing: 1,
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Text(
        product.description.isNotEmpty ? product.description : 'No description available.',
        style: const pw.TextStyle(
          fontSize: 11,
          color: NeoBrutalPdfColors.white,
          lineSpacing: 1.6,
        ),
        textAlign: pw.TextAlign.justify,
      ),
    ],
  );
}
