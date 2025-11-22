import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../pages/ui/pdf_preview_page.dart';

Future<void> genPDF(BuildContext context, Map<String, dynamic> map) async {
  final pdf = pw.Document();
  final image = await _getImage(map['thumbnail']);

  // App's primary teal color
  const tealColor = PdfColor.fromInt(0xFF4FD8C4);
  const darkGrey = PdfColor.fromInt(0xFF212121);
  const lightGrey = PdfColor.fromInt(0xFF757575);
  const veryLightGrey = PdfColor.fromInt(0xFFF5F5F5);

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        buildBackground: (context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Container(color: PdfColors.white),
        ),
      ),
      build: (pw.Context context) {
        return [
          // Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'TAG TWEAKER',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: tealColor,
                    ),
                  ),
                  pw.Text(
                    'PRODUCT CATALOG',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: lightGrey,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: tealColor,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  'OFFICIAL DOCUMENT',
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Divider(color: tealColor, thickness: 2),
          pw.SizedBox(height: 30),

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
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: pw.BoxDecoration(
                        color: veryLightGrey,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        map['brand']?.toString().toUpperCase() ?? 'BRAND',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: tealColor,
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
                            color: tealColor,
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
                            style: const pw.TextStyle(color: lightGrey),
                          ),
                        ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 40),

          // Specifications Table
          pw.Text(
            'SPECIFICATIONS',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: tealColor,
              letterSpacing: 1,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            decoration: const pw.BoxDecoration(
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
          pw.Text(
            'ABOUT THIS PRODUCT',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: tealColor,
              letterSpacing: 1,
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

          pw.Spacer(),

          // Footer
          pw.Divider(color: lightGrey, thickness: 0.5),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated by Tag Tweaker',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: lightGrey,
                ),
              ),
              pw.Text(
                'Page 1',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: lightGrey,
                ),
              ),
            ],
          ),
        ];
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/${map['title']}_catalog.pdf');
  await file.writeAsBytes(await pdf.save());
  try {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfPreviewScreen(pdfPath: file.path),
        ),
      );
    }
  } catch (e) {
    debugPrint('Error navigating to PDF preview screen: $e');
  }
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

Future<pw.MemoryImage?> _getImage(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return pw.MemoryImage(response.bodyBytes);
    } else {
      debugPrint(
          'Image failed with status ${response.statusCode}, using placeholder');
      return await _getPlaceholderImage();
    }
  } catch (e) {
    debugPrint('Error loading image from URL: $e, using placeholder');
    return await _getPlaceholderImage();
  }
}

Future<pw.MemoryImage?> _getPlaceholderImage() async {
  try {
    final placeholderUrl =
        'https://via.placeholder.com/400x400/4FD8C4/ffffff?text=Product+Image';
    final response = await http.get(Uri.parse(placeholderUrl));
    if (response.statusCode == 200) {
      return pw.MemoryImage(response.bodyBytes);
    }
  } catch (e) {
    debugPrint('Error loading placeholder image: $e');
  }
  return null;
}
