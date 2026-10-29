import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tag_tweaker/models/product_model.dart';
import 'package:tag_tweaker/models/quotation.dart';
import 'package:tag_tweaker/services/pdf_image_loader_service.dart';
import 'package:tag_tweaker/widgets/pdf/neo_brutal_pdf_theme.dart';
import 'package:tag_tweaker/widgets/pdf/product_pdf_widget.dart';
import 'package:tag_tweaker/widgets/pdf/quotation_summary_pdf.dart';

/// Modular service responsible for building and compiling Neo-Brutal PDF Catalogs.
class CatalogPdfService {
  /// Compiles a list of Product models into an on-device PDF catalog.
  static Future<String> generateCatalogPdf(List<Product> items) async {
    try {
      // Fetch all images concurrently in parallel with memory caching
      final images = await PdfImageLoaderService.loadImagesConcurrently(items);
      return await _writeTemp(
        await buildDocument(items: items, images: images),
      );
    } catch (e) {
      debugPrint('CatalogPdfService error: $e');
      throw Exception('Error generating PDF: $e');
    }
  }

  /// Compiles a client quotation: priced summary table first, followed by
  /// product detail pages for [products] (when available) at quoted prices.
  static Future<String> generateQuotationPdf(
    Quotation quote, [
    List<Product> products = const [],
  ]) async {
    try {
      final quoted = _applyQuotedPrices(products, quote);
      final images = await PdfImageLoaderService.loadImagesConcurrently(quoted);
      return await _writeTemp(
        await buildDocument(items: quoted, images: images, quotation: quote),
      );
    } catch (e) {
      debugPrint('CatalogPdfService error: $e');
      throw Exception('Error generating PDF: $e');
    }
  }

  /// Builds the PDF bytes. Pure (no file system or network access), so it
  /// can be exercised directly in unit tests.
  static Future<Uint8List> buildDocument({
    required List<Product> items,
    Map<String, pw.MemoryImage?> images = const {},
    Quotation? quotation,
  }) {
    final pdf = pw.Document();
    final List<pw.Widget> pdfContent = [
      if (quotation != null) ...buildQuotationSummaryPdf(quotation),
    ];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final image = images[item.id];

      pdfContent.add(buildProductPdfWidget(item, image));

      if (i < items.length - 1) {
        pdfContent.add(pw.SizedBox(height: 20));
        pdfContent.add(
          pw.Divider(color: NeoBrutalPdfColors.mediumGrey, thickness: 1),
        );
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
        header: (context) =>
            _buildHeader(quotation != null ? 'QUOTATION' : 'PRODUCT CATALOG'),
        footer: _buildFooter,
        build: (pw.Context context) => pdfContent,
      ),
    );

    return pdf.save();
  }

  /// Product pages in a quotation show the quoted unit price, not the
  /// catalog price.
  static List<Product> _applyQuotedPrices(
    List<Product> products,
    Quotation quote,
  ) {
    final unitPrices = {for (final l in quote.lines) l.productId: l.unitPrice};
    return [
      for (final p in products)
        if (unitPrices.containsKey(p.id)) p.copyWith(price: unitPrices[p.id]),
    ];
  }

  static Future<String> _writeTemp(Uint8List bytes) async {
    final output = await getTemporaryDirectory();
    await _deleteOldCatalogs(output);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${output.path}/tag_tweaker_catalog_$timestamp.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Removes previously generated catalogs so temp storage doesn't grow
  /// unbounded and stale price sheets don't linger on the device.
  static Future<void> _deleteOldCatalogs(Directory dir) async {
    try {
      await for (final entity in dir.list()) {
        final name = entity.uri.pathSegments.last;
        if (entity is File &&
            name.startsWith('tag_tweaker_catalog_') &&
            name.endsWith('.pdf')) {
          await entity.delete();
        }
      }
    } catch (e) {
      debugPrint('CatalogPdfService cleanup error: $e');
    }
  }

  static pw.Widget _buildHeader(String subtitle) {
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
                  style: const pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: NeoBrutalPdfColors.white,
                  ),
                ),
                pw.Text(
                  subtitle,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: NeoBrutalPdfColors.lime,
                    letterSpacing: 2,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: NeoBrutalPdfTheme.brutalBox(
                color: NeoBrutalPdfColors.purple,
                borderColor: NeoBrutalPdfColors.white,
              ),
              child: pw.Text(
                'OFFICIAL DOCUMENT',
                style: const pw.TextStyle(
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
              'Tag Tweaker (c) ${DateTime.now().year}',
              style: const pw.TextStyle(
                fontSize: 8,
                color: NeoBrutalPdfColors.lightGrey,
              ),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(
                fontSize: 8,
                color: NeoBrutalPdfColors.lightGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
