import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildProductPdfWidget(
  Map<String, dynamic> map,
  pw.MemoryImage? image,
  PdfColor accentColor,
  PdfColor darkGrey,
  PdfColor lightGrey,
  PdfColor veryLightGrey,
) {
  return pw.Column(
    children: [
      // Hero Section
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Left: Text Info
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding:
                      const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: veryLightGrey,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    map['brand']?.toString().toUpperCase() ?? 'BRAND',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: accentColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  map['title'],
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: darkGrey,
                    lineSpacing: 1.2,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Rs. ${map['price']}',
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    if (map['discountPercentage'] != null &&
                        map['discountPercentage'] > 0) ...[
                      pw.SizedBox(width: 10),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 6),
                        child: pw.Text(
                          '${map['discountPercentage']}% OFF',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                pw.SizedBox(height: 20),
                if (map['rating'] != null)
                  pw.Row(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: lightGrey),
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Text(
                              'RATING',
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                                color: lightGrey,
                              ),
                            ),
                            pw.SizedBox(width: 6),
                            pw.Text(
                              '${map['rating']}/5',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          pw.SizedBox(width: 20),
          // Right: Image
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              height: 200,
              decoration: pw.BoxDecoration(
                color: veryLightGrey,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: image != null
                  ? pw.ClipRRect(
                      horizontalRadius: 8,
                      verticalRadius: 8,
                      child: pw.Image(image, fit: pw.BoxFit.contain),
                    )
                  : pw.Center(
                      child: pw.Text(
                        'No Image',
                        style: const pw.TextStyle(color: PdfColors.grey500),
                      ),
                    ),
            ),
          ),
        ],
      ),

      pw.SizedBox(height: 40),

      // Specifications Table
      pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
          'SPECIFICATIONS',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: accentColor,
            letterSpacing: 1,
          ),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border(
            top: pw.BorderSide(color: lightGrey, width: 0.5),
            bottom: pw.BorderSide(color: lightGrey, width: 0.5),
          ),
        ),
        child: pw.Column(
          children: [
            _buildModernSpecRow(
                'Product ID', '#${map['id']}', darkGrey, lightGrey),
            _buildModernSpecRow(
                'Category', map['category'] ?? 'N/A', darkGrey, lightGrey),
            if (map['stock'] != null)
              _buildModernSpecRow('Stock Status',
                  '${map['stock']} units available', darkGrey, lightGrey),
          ],
        ),
      ),

      pw.SizedBox(height: 40),

      // Description
      pw.Align(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
          'ABOUT THIS PRODUCT',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: accentColor,
            letterSpacing: 1,
          ),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Text(
        map['description']?.toString() ?? 'No description available.',
        style: pw.TextStyle(
          fontSize: 11,
          color: darkGrey,
          lineSpacing: 1.6,
        ),
        textAlign: pw.TextAlign.justify,
      ),

      pw.SizedBox(height: 40),
      pw.Divider(color: lightGrey, thickness: 0.5),
      pw.SizedBox(height: 40),
    ],
  );
}

pw.Widget _buildModernSpecRow(
    String label, String value, PdfColor valueColor, PdfColor labelColor) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 12),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5),
      ),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: labelColor,
          ),
        ),
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
