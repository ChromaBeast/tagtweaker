import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/product_model.dart';
import '../widgets/pdf/neo_brutal_pdf_theme.dart';
import '../widgets/pdf/product_pdf_widget.dart';
import 'pdf_image_loader_service.dart';

/// Modular service responsible for building and compiling Neo-Brutal PDF Catalogs.
class CatalogPdfService {
  /// Compiles a list of Product models into an on-device PDF catalog.
  static Future<String> generateCatalogPdf(List<Product> items) async {
    try {
      // Fetch all images concurrently in parallel with memory caching
      final images = await PdfImageLoaderService.loadImagesConcurrently(items);

      final pdf = pw.Document();
      final List<pw.Widget> pdfContent = [];

      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final image = images[item.id];

        pdfContent.add(buildProductPdfWidget(item, image));

        if (i < items.length - 1) {
          pdfContent.add(pw.SizedBox(height: 20));
          pdfContent.add(pw.Divider(color: NeoBrutalPdfColors.mediumGrey, thickness: 1));
          pdfContent.add(pw.SizedBox(height: 20));
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(40),
            buildBackground: (context) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: NeoBrutalPdfColors.background),
            ),
          ),
          header: (context) => _buildHeader(),
          footer: (context) => _buildFooter(context),
          build: (pw.Context context) => pdfContent,
        ),
      );

      final output = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${output.path}/tag_tweaker_catalog_$timestamp.pdf');
      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      debugPrint('CatalogPdfService error: $e');
      throw Exception('Error generating PDF: $e');
    }
  }

  static pw.Widget _buildHeader() {
    return pw.Column(
      children: [
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
                    color: NeoBrutalPdfColors.white,
                  ),
                ),
                pw.Text(
                  'PRODUCT CATALOG',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: NeoBrutalPdfColors.lime,
                    letterSpacing: 2,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: NeoBrutalPdfTheme.brutalBox(
                color: NeoBrutalPdfColors.purple,
                borderColor: NeoBrutalPdfColors.white,
              ),
              child: pw.Text(
                'OFFICIAL DOCUMENT',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: NeoBrutalPdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: NeoBrutalPdfColors.white, thickness: 2),
        pw.SizedBox(height: 30),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(color: NeoBrutalPdfColors.lightGrey, thickness: 0.5),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Tag Tweaker © ${DateTime.now().year}',
              style: const pw.TextStyle(fontSize: 8, color: NeoBrutalPdfColors.lightGrey),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: NeoBrutalPdfColors.lightGrey),
            ),
          ],
        ),
      ],
    );
  }
}
